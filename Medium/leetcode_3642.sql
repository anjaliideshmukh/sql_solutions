# Write your MySQL query statement below
WITH book_stats AS (
    SELECT 
        b.book_id,
        b.title,
        b.author,
        b.genre,
        b.pages,
        COUNT(r.session_id) AS total_sessions,
        MAX(r.session_rating) AS highest_rating,
        MIN(r.session_rating) AS lowest_rating,
        SUM(CASE WHEN r.session_rating <= 2 OR r.session_rating >= 4 THEN 1 ELSE 0 END) AS extreme_sessions
    FROM books b
    JOIN reading_sessions r ON b.book_id = r.book_id
    GROUP BY b.book_id, b.title, b.author, b.genre, b.pages
    HAVING COUNT(r.session_id) >= 5
       AND MAX(r.session_rating) >= 4
       AND MIN(r.session_rating) <= 2
)
SELECT 
    book_id,
    title,
    author,
    genre,
    pages,
    (highest_rating - lowest_rating) AS rating_spread,
    ROUND(extreme_sessions / total_sessions, 2) AS polarization_score
FROM book_stats
WHERE (extreme_sessions / total_sessions) >= 0.6
ORDER BY polarization_score DESC, title DESC;
