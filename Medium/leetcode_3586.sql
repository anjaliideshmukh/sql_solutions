# Write your MySQL query statement below
SELECT 
    p.patient_id,
    p.patient_name,
    p.age,
    DATEDIFF(MIN(t2.test_date), MIN(t1.test_date)) AS recovery_time
FROM covid_tests t1
INNER JOIN covid_tests t2 
    ON t1.patient_id = t2.patient_id 
    AND t1.result = 'Positive' 
    AND t2.result = 'Negative' 
    AND t1.test_date < t2.test_date
INNER JOIN patients p 
    ON t1.patient_id = p.patient_id
GROUP BY p.patient_id, p.patient_name
ORDER BY recovery_time ASC, p.patient_name ASC;