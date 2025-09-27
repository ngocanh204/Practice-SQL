/* Bài tập 1: https://www.hackerrank.com/challenges/weather-observation-station-3/problem?isFullScreen=true */
SELECT DISTINCT city FROM station 
WHERE ID%2=0

/* Bài tập 2: https://www.hackerrank.com/challenges/weather-observation-station-4/problem?isFullScreen=true */
SELECT 
COUNT(city)- COUNT(DISTINCT city)
FROM station

/* Bài tập 3: https://www.hackerrank.com/challenges/the-blunder/problem?isFullScreen=true */




/* Bài tập 4: https://datalemur.com/questions/alibaba-compressed-mean */
SELECT 
ROUND(CAST(SUM(item_count*order_occurrences)/SUM(order_occurrences) AS DECIMAL) ,1) AS mean
FROM items_per_order;

/* Bài tập 5: https://datalemur.com/questions/matching-skills */
SELECT candidate_id
FROM candidates
WHERE skill in ('Python', 'Tableau','PostgreSQL')
GROUP BY candidate_id
HAVING COUNT(skill)=3

/* Bài tập 6: https://datalemur.com/questions/sql-average-post-hiatus-1 */
SELECT
user_id,
DATE(MAX(post_date))-DATE(MIN(post_date)) AS days_between
FROM posts
WHERE post_date BETWEEN '2021-01-01' AND '2022-01-01'
GROUP BY user_id
HAVING COUNT(post_id)>=2

/* Bài tập 7: https://datalemur.com/questions/cards-issued-difference */
-- INPUT: card_name , issued_amount,issue_month	, issue_year
-- OUTPUT: card_name, difference
-- Dieu kien: chenh lech giua so luong the trong , sap xep tu cao xuong thap 
SELECT card_name,
MAX(issued_amount)-MIN(issued_amount) AS difference
FROM monthly_cards_issued
GROUP BY card_name
ORDER BY MAX(issued_amount)-MIN(issued_amount) DESC

/* Bài tập 8: https://datalemur.com/questions/non-profitable-drugs */
