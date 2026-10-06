# Write your MySQL query statement below
select user_id,
    round(avg(case when activity_type = 'free_trial' then activity_duration end), 2) as trial_avg_duration,
    round(avg(case when activity_type = 'paid' then activity_duration end), 2) as paid_avg_duration
from useractivity
where activity_type in ('free_trial', 'paid')
group by user_id
having count(distinct activity_type) = 2;
