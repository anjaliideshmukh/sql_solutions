# Write your MySQL query statement below
with recursive hierarchy as (
    select
        employee_id,
        employee_name,
        manager_id,
        salary,
        1 as level
    from employees
    where manager_id is null

    union all

    select
        e.employee_id,
        e.employee_name,
        e.manager_id,
        e.salary,
        h.level + 1
    from employees e
    join hierarchy h
        on e.manager_id = h.employee_id
),
reporting_tree as (
    select
        employee_id as manager_id,
        employee_id as report_id
    from employees

    union all

    select
        rt.manager_id,
        e.employee_id
    from reporting_tree rt
    join employees e
        on e.manager_id = rt.report_id
),
team_stats as (
    select
        rt.manager_id as employee_id,
        count(*) - 1 as team_size,
        sum(e.salary) as budget
    from reporting_tree rt
    join employees e
        on e.employee_id = rt.report_id
    group by rt.manager_id
)
select
    h.employee_id,
    h.employee_name,
    h.level,
    coalesce(ts.team_size, 0) as team_size,
    coalesce(ts.budget, h.salary) as budget
from hierarchy h
left join team_stats ts
    on h.employee_id = ts.employee_id
order by
    h.level asc,
    budget desc,
    h.employee_name asc;