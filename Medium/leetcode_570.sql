select m.name 
from Employee e
join Employee m ON e.managerId = m.id
GROUP BY m.id, m.name 
HAVING COUNT(e.id) >=5