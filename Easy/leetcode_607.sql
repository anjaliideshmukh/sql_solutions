# Write your MySQL query statement below
select s.name
from salesperson s
left join (
    select distinct o.sales_id
    from orders o
    join company c
        on o.com_id = c.com_id
    where c.name = 'RED'
) r
    on s.sales_id = r.sales_id
where r.sales_id is null;