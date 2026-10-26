# Write your MySQL query statement below
with top_students as (
    select user_id
    from course_completions
    group by user_id
    having count(*) >= 5
       and avg(course_rating) >= 4
),
course_sequence as (
    select
        c.user_id,
        c.course_name as first_course,
        lead(c.course_name) over (
            partition by c.user_id
            order by c.completion_date, c.course_id
        ) as second_course
    from course_completions c
    join top_students t
        on c.user_id = t.user_id
)
select
    first_course,
    second_course,
    count(*) as transition_count
from course_sequence
where second_course is not null
group by first_course, second_course
order by
    transition_count desc,
    first_course asc,
    second_course asc;
