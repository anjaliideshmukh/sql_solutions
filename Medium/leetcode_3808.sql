# Write your MySQL query statement below
with reaction_counts as (
    select
        user_id,
        reaction,
        count(*) as type_count
    from reactions
    group by user_id, reaction
),
user_stats as (
    select
        user_id,
        sum(type_count) as total_reactions,
        max(type_count) as max_reactions
    from reaction_counts
    group by user_id
),
ranked_reactions as (
    select
        user_id,
        reaction,
        type_count,
        row_number() over (
            partition by user_id
            order by type_count desc, reaction asc
        ) as rn
    from reaction_counts
)
select
    rr.user_id,
    rr.reaction as dominant_reaction,
    round(us.max_reactions / us.total_reactions, 2) as reaction_ratio
from ranked_reactions rr
join user_stats us
    on rr.user_id = us.user_id
where rr.rn = 1
  and us.total_reactions >= 5
  and us.max_reactions / us.total_reactions >= 0.60
  and rr.user_id in (
      select user_id
      from reactions
      group by user_id
      having count(distinct content_id) >= 5
  )
order by reaction_ratio desc, rr.user_id asc;