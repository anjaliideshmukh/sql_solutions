# Write your MySQL query statement below
select id,
    sum(case when month = 'Jan' then revenue end) AS Jan_Revenue,
    sum(case when month = 'Feb' then revenue end) AS Feb_Revenue,
    sum(case when month = 'Mar' then revenue end) AS Mar_Revenue,
    sum(case when month = 'Apr' then revenue end) AS Apr_Revenue,
    sum(case when month = 'May' then revenue end) AS May_Revenue,
    sum(case when month = 'Jun' then revenue end) AS Jun_Revenue,
    sum(case when month = 'Jul' then revenue end) AS Jul_Revenue,
    sum(case when month = 'Aug' then revenue end) AS Aug_Revenue,
    sum(case when month = 'Sep' then revenue end) AS Sep_Revenue,
    sum(case when month = 'Oct' then revenue end) AS Oct_Revenue,
    sum(case when month = 'Nov' then revenue end) AS Nov_Revenue,
    sum(case when month = 'Dec' then revenue end) AS Dec_Revenue
from Department
group by id;
