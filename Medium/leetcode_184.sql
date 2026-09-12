# Write your MySQL query statement below
Select 
    d.name as Department,
    e.name as Employee,
    e.salary as Salary
from Employee e
join Department d
    on e.departmentId = d.id
join (
    select departmentId, MAX(salary) as max_salary
    from Employee
    group by departmentId
) m
    on e.departmentId = m.departmentId
    and e.salary = m.max_salary;