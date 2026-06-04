CREATE DATABASE IF NOT EXISTS test_task;
USE test_task;

CREATE TABLE audience (
    date         DATE,
    user_id      VARCHAR(50),
    view_adverts INT
);

CREATE TABLE ab_tests (
    experiment_num   INT,
    experiment_group VARCHAR(10),
    user_id          BIGINT,
    revenue          INT
);

CREATE TABLE listers (
    user_id      INT,
    date         DATE,
    cnt_adverts  INT,
    age          INT,
    cnt_contacts INT,
    revenue      INT
);

SELECT COUNT(*) FROM listers;
SELECT * FROM listers;

# 1 вопрос. MAU 
SELECT COUNT(DISTINCT user_id) AS MAU
FROM audience
WHERE DATE_FORMAT(date, '%Y-%m') = '2023-11';

#2 вопрос. DAU 
SELECT ROUND(AVG(daily_users), 1) AS DAU
FROM (
    SELECT date, COUNT(DISTINCT user_id) AS daily_users
    FROM audience
    GROUP BY date
) AS daily;

#3 вопрос. Retention Day 
SELECT 
    COUNT(DISTINCT a2.user_id) AS retained,        
    COUNT(DISTINCT a1.user_id) AS new_users,        
    ROUND(COUNT(DISTINCT a2.user_id) / COUNT(DISTINCT a1.user_id) * 100, 1) AS retention_pct
FROM audience a1
LEFT JOIN audience a2 
    ON a1.user_id = a2.user_id 
    AND a2.date = '2023-11-02'
WHERE a1.date = '2023-11-01';

#5 вопрос. view_adverts
SELECT 
    COUNT(DISTINCT user_id) AS total_users,
    COUNT(DISTINCT CASE WHEN view_adverts > 0 THEN user_id END) AS users_with_views,
    ROUND(
        COUNT(DISTINCT CASE WHEN view_adverts > 0 THEN user_id END) * 100.0 / 
        COUNT(DISTINCT user_id), 2) AS conversion
FROM audience;

# 6 вопрос. cр.кол-во просмотров
SELECT 
    SUM(view_adverts) AS total_adverts,
    COUNT(DISTINCT user_id) AS uniq_users,
    ROUND(SUM(view_adverts) / COUNT(DISTINCT user_id), 1) AS avg_adverts_per_user
FROM audience;

# 9 вопрос. средний доход на пользователя
SELECT 
    SUM(revenue) AS total_revenue,
    COUNT(DISTINCT user_id) AS unique_users,
    SUM(revenue) / COUNT(DISTINCT user_id) AS arpu
FROM listers;