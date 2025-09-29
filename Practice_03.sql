/* Bài tập 1:https://www.hackerrank.com/challenges/more-than-75-marks/problem */
select name FROM students WHERE
marks>75 order BY (right(name,3)),id

/* Bài tập 2:https://leetcode.com/problems/fix-names-in-a-table/?envType=study-plan-v2&envId=top-sql-50 */
SELECT user_id,
CONCAT(UPPER(LEFT(name,1)),LOWER(SUBSTRING(name from 2))) AS name 
FROM Users
ORDER BY user_id

/* Bài tập 3: https://datalemur.com/questions/total-drugs-sales */
SELECT 
manufacturer,
CONCAT('$',ROUND(SUM(total_sales)/1000000,0),' ','million') AS sales_mil
FROM pharmacy_sales
GROUP BY manufacturer
ORDER BY SUM(total_sales) DESC, manufacturer ASC

/* Bài tập 4: https://datalemur.com/questions/sql-avg-review-ratings */ 
SELECT 
EXTRACT(month from submit_date) AS mth,
product_id AS product,
ROUND(AVG(stars),2) AS avg_stars
FROM reviews
GROUP BY EXTRACT(month from submit_date), product_id
ORDER BY EXTRACT(month from submit_date), product_id

/* Bài tập 5:https://datalemur.com/questions/teams-power-users */
SELECT
sender_id,
count(message_id) AS 	message_count
FROM messages
WHERE EXTRACT( month FROM sent_date)=8
AND EXTRACT(year FROM	sent_date)=2022
GROUP BY sender_id 
ORDER BY message_count DESC
LIMIT 2

/* Bài tập 6: https://leetcode.com/problems/invalid-tweets/description/?envType=study-plan-v2&envId=top-sql-50 */
SELECT 
tweet_id
FROM Tweets
WHERE length(content)>15

/* Bài tập 7: https://leetcode.com/problems/user-activity-for-the-past-30-days-i/description/?envType=study-plan-v2&envId=top-sql-50 */
SELECT activity_date AS day,
COUNT(DISTINCT user_id) AS active_users
FROM Activity
WHERE activity_date >'2019/06/28' AND activity_date<='2019/07/28'
GROUP BY day 

/* Bài tập 8: https://learndatawithjulie.com/courses/sql-for-data-analyst/lessons/1-huong-dan-practice-3/ */
select 
count(id) AS number_employee
from employees
WHERE joining_date>=2022-01-01 AND joining_date<=2022-07-3

/* Bài tập 9:https://platform.stratascratch.com/coding/9829-positions-of-letter-a?code_type=1 */
select 
POSITION('a' in first_name)
from worker
WHERE first_name='Amitah';

/* Bài tập 10: https://platform.stratascratch.com/coding/10039-macedonian-vintages?code_type=1 */
select  
SUBSTRING(title FROM length(winery)+2 FOR 4)
from winemag_p2
WHERE country='Macedonia'
