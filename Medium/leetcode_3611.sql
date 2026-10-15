# Write your MySQL query statement below
with weekly_meetings as (
    select
        employee_id,
        date_sub(
            meeting_date,
            interval weekday(meeting_date) day
        ) as week_start,
        sum(duration_hours) as total_hours
    from meetings
    group by
        employee_id,
        date_sub(
            meeting_date,
            interval weekday(meeting_date) day
        )
),
heavy_weeks as (
    select
        employee_id,
        count(*) as meeting_heavy_weeks
    from weekly_meetings
    where total_hours > 20
    group by employee_id
    having count(*) >= 2
)
select
    e.employee_id,
    e.employee_name,
    e.department,
    h.meeting_heavy_weeks
from heavy_weeks h
join employees e
    on h.employee_id = e.employee_id
order by
    h.meeting_heavy_weeks desc,
    e.employee_name asc;