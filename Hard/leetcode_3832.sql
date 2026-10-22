# Write your MySQL query statement below
with daily_actions as (
    select
        user_id,
        action_date,
        min(action) as action
    from activity
    group by user_id, action_date
    having count(*) = 1
),
numbered as (
    select
        user_id,
        action_date,
        action,
        row_number() over (
            partition by user_id, action
            order by action_date
        ) as rn
    from daily_actions
),
streak_groups as (
    select
        user_id,
        action,
        action_date,
        date_sub(action_date, interval rn day) as grp
    from numbered
),
streaks as (
    select
        user_id,
        action,
        min(action_date) as start_date,
        max(action_date) as end_date,
        count(*) as streak_length
    from streak_groups
    group by user_id, action, grp
    having count(*) >= 5
),
ranked as (
    select
        user_id,
        action,
        streak_length,
        start_date,
        end_date,
        row_number() over (
            partition by user_id
            order by
                streak_length desc,
                action asc,
                start_date desc
        ) as rn
    from streaks
)
select
    user_id,
    action,
    streak_length,
    start_date,
    end_date
from ranked
where rn = 1
order by streak_length desc, user_id asc;