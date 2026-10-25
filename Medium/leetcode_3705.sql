# Write your MySQL query statement below
select
    customer_id,
    count(*) as total_orders,
    round(
        100.0 * sum(
            case
                when time(order_timestamp) between '11:00:00' and '14:00:00'
                  or time(order_timestamp) between '18:00:00' and '21:00:00'
                then 1
                else 0
            end
        ) / count(*),
        0
    ) as peak_hour_percentage,
    round(avg(order_rating), 2) as average_rating
from restaurant_orders
group by customer_id
having count(*) >= 3
   and sum(
       case
           when time(order_timestamp) between '11:00:00' and '14:00:00'
             or time(order_timestamp) between '18:00:00' and '21:00:00'
           then 1
           else 0
       end
   ) / count(*) >= 0.60
   and avg(order_rating) >= 4.0
   and count(order_rating) / count(*) >= 0.50
order by average_rating desc, customer_id desc;