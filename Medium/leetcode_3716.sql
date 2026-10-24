# Write your MySQL query statement below
with ranked_events as (
    select
        *,
        row_number() over (
            partition by user_id
            order by event_date desc, event_id desc
        ) as rn
    from subscription_events
),
user_stats as (
    select
        user_id,
        min(case
            when event_type = 'start' then event_date
        end) as start_date,
        max(monthly_amount) as max_historical_amount,
        max(case
            when event_type = 'downgrade' then 1
            else 0
        end) as has_downgrade
    from subscription_events
    group by user_id
)
select
    r.user_id,
    r.plan_name as current_plan,
    r.monthly_amount as current_monthly_amount,
    s.max_historical_amount,
    datediff(r.event_date, s.start_date) as days_as_subscriber
from ranked_events r
join user_stats s
    on r.user_id = s.user_id
where r.rn = 1
  and r.event_type <> 'cancel'
  and s.has_downgrade = 1
  and r.monthly_amount < 0.5 * s.max_historical_amount
  and datediff(r.event_date, s.start_date) >= 60
order by
    days_as_subscriber desc,
    r.user_id asc;
