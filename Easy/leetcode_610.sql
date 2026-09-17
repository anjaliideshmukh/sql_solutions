select x, y, z, case when x+y>z and y+z>x and x+z>y then 'yes'
 else 'no'
 end as triangle
from Triangle ;