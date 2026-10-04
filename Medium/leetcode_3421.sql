WITH RankedScores AS (
    SELECT 
        student_id,
        subject,
        score,
        ROW_NUMBER() OVER(PARTITION BY student_id, subject ORDER BY exam_date ASC) AS rn_first,
        ROW_NUMBER() OVER(PARTITION BY student_id, subject ORDER BY exam_date DESC) AS rn_latest
    FROM 
        Scores
)
SELECT 
    f.student_id,
    f.subject,
    f.score AS first_score,
    l.score AS latest_score
FROM 
    RankedScores f
JOIN 
    RankedScores l 
    ON f.student_id = l.student_id 
    AND f.subject = l.subject
WHERE 
    f.rn_first = 1 
    AND l.rn_latest = 1
    AND l.score > f.score
ORDER BY 
    student_id ASC, 
    subject ASC;
