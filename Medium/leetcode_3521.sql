# Write your MySQL query statement below
select 
    p1.product_id as product1_id, 
    p2.product_id as product2_id,
    i1.category as product1_category,
    i2.category as product2_category,
    count(distinct p1.user_id) as customer_count
from 
    productpurchases p1
join 
    productpurchases p2 on p1.user_id = p2.user_id 
    and p1.product_id < p2.product_id
join
    productinfo i1 on p1.product_id = i1.product_id
join
    productinfo i2 on p2.product_id = i2.product_id
group by 
    p1.product_id, 
    p2.product_id,
    i1.category,
    i2.category
having 
    count(distinct p1.user_id) >= 3
order by 
    customer_count desc, 
    product1_id asc, 
    product2_id asc;
