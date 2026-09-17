select person_name
from (select person_name, turn, sum(weight) over (order by turn) as total_weight from Queue) as q 
where total_weight<=1000
order by turn desc
limit 1;
