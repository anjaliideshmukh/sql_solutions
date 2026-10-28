# Write your MySQL query statement below
WITH RECURSIVE chars AS (
    SELECT
        content_id,
        content_text,
        1 AS pos,
        CHAR_LENGTH(content_text) AS txt_len,
        CAST('' AS CHAR(10000)) AS converted_text
    FROM user_content

    UNION ALL

    SELECT
        content_id,
        content_text,
        pos + 1,
        txt_len,
        CONCAT(
            converted_text,
            CASE
                WHEN SUBSTRING(content_text, pos, 1) = ' '
                    THEN ' '

                WHEN SUBSTRING(
                    content_text,
                    pos - CHAR_LENGTH(
                        SUBSTRING_INDEX(
                            LEFT(content_text, pos - 1), ' ', -1
                        )
                    ),
                    1
                ) NOT REGEXP '^[A-Za-z]$'
                    THEN SUBSTRING(content_text, pos, 1)

                WHEN SUBSTRING(
                    content_text,
                    pos - CHAR_LENGTH(
                        SUBSTRING_INDEX(
                            LEFT(content_text, pos - 1), ' ', -1
                        )
                    ),
                    CHAR_LENGTH(
                        SUBSTRING_INDEX(
                            LEFT(content_text, pos - 1), ' ', -1
                        )
                    ) +
                    CHAR_LENGTH(
                        SUBSTRING_INDEX(
                            SUBSTRING(content_text, pos), ' ', 1
                        )
                    )
                ) REGEXP '^[A-Za-z]+(-[A-Za-z]+)+$'
                AND (
                    pos = pos - CHAR_LENGTH(
                        SUBSTRING_INDEX(
                            LEFT(content_text, pos - 1), ' ', -1
                        )
                    )
                    OR SUBSTRING(content_text, pos - 1, 1) = '-'
                )
                    THEN UPPER(SUBSTRING(content_text, pos, 1))

                WHEN pos = pos - CHAR_LENGTH(
                    SUBSTRING_INDEX(
                        LEFT(content_text, pos - 1), ' ', -1
                    )
                )
                    THEN UPPER(SUBSTRING(content_text, pos, 1))

                WHEN SUBSTRING(content_text, pos, 1)
                     REGEXP '^[A-Za-z]$'
                    THEN LOWER(SUBSTRING(content_text, pos, 1))

                ELSE SUBSTRING(content_text, pos, 1)
            END
        )
    FROM chars
    WHERE pos <= txt_len
)
SELECT
    content_id,
    content_text AS original_text,
    converted_text
FROM chars
WHERE pos = txt_len + 1
ORDER BY content_id;