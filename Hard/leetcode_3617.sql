# Write your MySQL query statement below

with base as (
select *, max(pattern_start)
over (partition by student_id order by session_date rows between unbounded preceding and current row) as pattern_date
from
(
select *, case when datediff(session_date,lag(session_date) over (partition by student_id order by session_date )) <=2 then null else session_date end as pattern_start
from study_sessions
) t
),
consecutive_day as (
select *, row_number() over(partition by student_id,pattern_date,subject order by session_date) as inside_rank
from base
),
subject_pattern as (
select student_id,pattern_date,inside_rank,group_concat(subject order by session_date) as sub_pattern,count(subject) as total_subjects,sum(hours_studied) as total_hours
from consecutive_day
group by student_id,pattern_date,inside_rank
),
sequential_pat as (
select *, max(cycle_repeat)
over (partition by student_id,pattern_date order by inside_rank rows between unbounded preceding and current row) as cycle_seq_count
from(
select *, case when sub_pattern=lag(sub_pattern) over (partition by student_id,pattern_date order by inside_rank) then null else inside_rank end as cycle_repeat
from subject_pattern
) c
)


select p.student_id,s.student_name,s.major,cycle_length,total_study_hours
from (
select student_id,max(total_subjects) as cycle_length ,sum(total_hours) as total_study_hours
from sequential_pat 
where total_subjects>2
group by student_id,pattern_date,cycle_seq_count
having count(sub_pattern)>1) p join students s on p.student_id=s.student_id
where (select count(*) from students) >1
order by cycle_length desc,total_study_hours desc
