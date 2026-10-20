# Write your MySQL query statement below
select
    p1.category as category1,
    p2.category as category2,
    count(distinct pp1.user_id) as customer_count
from ProductPurchases pp1
join ProductInfo p1
    on pp1.product_id = p1.product_id
join ProductPurchases pp2
    on pp1.user_id = pp2.user_id
join ProductInfo p2
    on pp2.product_id = p2.product_id
where p1.category < p2.category
group by p1.category, p2.category
having count(distinct pp1.user_id) >= 3
order by
    customer_count desc,
    category1 asc,
    category2 asc;