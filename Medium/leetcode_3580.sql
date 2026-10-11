# Write your MySQL query statement below
select
    r1.employee_id,
    e.name,
    r1.rating - r3.rating as improvement_score
from performance_reviews r1
join performance_reviews r2
    on r1.employee_id = r2.employee_id
join performance_reviews r3
    on r1.employee_id = r3.employee_id
join employees e
    on r1.employee_id = e.employee_id
where r1.review_date > r2.review_date
  and r2.review_date > r3.review_date
  and r1.rating > r2.rating
  and r2.rating > r3.rating
  and not exists (
      select 1
      from performance_reviews r
      where r.employee_id = r1.employee_id
        and r.review_date > r1.review_date
  )
  and not exists (
      select 1
      from performance_reviews r
      where r.employee_id = r1.employee_id
        and r.review_date > r2.review_date
        and r.review_date < r1.review_date
  )
  and not exists (
      select 1
      from performance_reviews r
      where r.employee_id = r1.employee_id
        and r.review_date > r3.review_date
        and r.review_date < r2.review_date
  )
order by improvement_score desc, e.name asc;