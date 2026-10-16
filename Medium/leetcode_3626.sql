# Write your MySQL query statement below
with product_counts as (
    select
        store_id,
        count(distinct product_name) as total_products
    from inventory
    group by store_id
),
ranked_inventory as (
    select
        i.store_id,
        i.product_name,
        i.quantity,
        i.price,
        row_number() over (
            partition by i.store_id
            order by i.price desc, i.product_name asc
        ) as expensive_rank,
        row_number() over (
            partition by i.store_id
            order by i.price asc, i.product_name asc
        ) as cheap_rank
    from inventory i
),
store_imbalance as (
    select
        store_id,
        max(case when expensive_rank = 1
            then product_name end) as most_exp_product,
        max(case when expensive_rank = 1
            then quantity end) as expensive_quantity,
        max(case when cheap_rank = 1
            then product_name end) as cheapest_product,
        max(case when cheap_rank = 1
            then quantity end) as cheapest_quantity
    from ranked_inventory
    group by store_id
)
select
    s.store_id,
    s.store_name,
    s.location,
    si.most_exp_product,
    si.cheapest_product,
    round(
        si.cheapest_quantity / si.expensive_quantity, 2
    ) as imbalance_ratio
from store_imbalance si
join product_counts pc
    on si.store_id = pc.store_id
join stores s
    on si.store_id = s.store_id
where pc.total_products >= 3
  and si.expensive_quantity < si.cheapest_quantity
order by imbalance_ratio desc, s.store_name asc;