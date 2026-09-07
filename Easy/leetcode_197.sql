# Write your MySQL query statement below
#t for today and y for yesterday
SELECT t.id
FROM Weather t
JOIN Weather y ON DATEDIFF(t.recordDate, y.recordDate) = 1
WHERE t.temperature > y.temperature;
