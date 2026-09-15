# Write your MySQL query statement below
select  a.student_id, a.student_name, sub.subject_name, count(e.subject_name) as attended_exams
from Students a
cross join Subjects sub
left join Examinations e on a.student_id=e.student_id and sub.subject_name=e.subject_name
group by a.student_id, a.student_name, sub.subject_name
order by a.student_id, sub.subject_name;