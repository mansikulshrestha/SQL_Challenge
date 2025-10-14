/*
SQL Interview Question: Meta/Facebook

A table named “famous” has two columns — user_id and follower_id.
Each record means: follower_id follows user_id.
Find the Famous Percentage for each user.

Famous Percentage = (Number of followers a user has / Total number of users on the platform) * 100
*/

CREATE TABLE famous (user_id INT, follower_id INT);

INSERT INTO famous VALUES
(1, 2), (1, 3), (2, 4), (5, 1), (5, 3), 
(11, 7), (12, 8), (13, 5), (13, 10), 
(14, 12), (14, 3), (15, 14), (15, 13);

WITH distinct_users AS (
    SELECT user_id AS users FROM famous
    UNION
    SELECT follower_id AS users FROM famous
),
follower_count AS (
    SELECT 
        user_id,
        COUNT(follower_id) AS followers
    FROM famous
    GROUP BY user_id
)
SELECT 
    f.user_id,
    (followers * 100.0) / (SELECT COUNT(users) FROM distinct_users) AS famous_percentage
FROM follower_count f
ORDER BY famous_percentage DESC;
