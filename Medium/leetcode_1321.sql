# Write your MySQL query statement below
select
    d1.visited_on,
    sum(d2.daily_amount) as amount,
    round(sum(d2.daily_amount) / 7, 2) as average_amount
from (
    select visited_on, sum(amount) as daily_amount
    from customer
    group by visited_on
) d1
join (
    select visited_on, sum(amount) as daily_amount
    from customer
    group by visited_on
) d2
    on d2.visited_on between
       date_sub(d1.visited_on, interval 6 day)
       and d1.visited_on
group by d1.visited_on
having count(*) = 7
order by d1.visited_on;