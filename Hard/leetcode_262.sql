select
    t.request_at as day,
    round(
        sum(
            case
                when t.status in ('cancelled_by_client', 'cancelled_by_driver')
                then 1
                else 0
            end
        ) / count(*),
        2
    ) as 'cancellation rate'
from trips t
join users c
    on t.client_id = c.users_id
    and c.banned = 'No'
join users d
    on t.driver_id = d.users_id
    and d.banned = 'No'
where t.request_at between '2013-10-01' and '2013-10-03'
group by t.request_at;