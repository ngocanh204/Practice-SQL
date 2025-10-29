/* Bài tập 1: https://datalemur.com/questions/duplicate-job-listings */
SELECT COUNT(DISTINCT company_id) AS duplicate_companies
FROM (
  SELECT 
    company_id, 
    title, 
    description, 
    COUNT(job_id) AS job_count
  FROM job_listings
  GROUP BY company_id, title, description
) AS job_count_cte
WHERE job_count > 1;


/* Bài tập 2: https://datalemur.com/questions/sql-highest-grossing */
WITH  category_total_spend as(
SELECT category,product,
SUM(spend) AS total_spend
FROM product_spend
WHERE EXTRACT(year from transaction_date)='2022'
GROUP BY category,product
ORDER BY total_spend desc
LIMIT 4)
SELECT * FROM category_total_spend
ORDER BY category asc


/* Bài tập 3: https://datalemur.com/questions/frequent-callers */ 
with policy_holder_table as(
SELECT policy_holder_id,
COUNT(case_id)
FROM callers
GROUP BY policy_holder_id
HAVING COUNT(case_id)>=3)
SELECT 
count(policy_holder_id) AS policy_holder_count
FROM policy_holder_table

/* Bài tập 4:  https://datalemur.com/questions/sql-page-with-no-likes */
SELECT a.page_id FROM pages as A 
LEFT JOIN page_likes as B 
ON a.page_id=b.page_id
WHERE user_id is NULL
ORDER BY page_id

/* Bài tập 5: https://datalemur.com/questions/user-retention */
SELECT
 EXTRACT(month from event_date) AS mth,
 COUNT(DISTINCT(user_id)) AS monthly_active_user
FROM user_actions 
WHERE user_id IN (
-- Give me the list of all distinct users in the month of June 2022
  SELECT 
  	DISTINCT(user_id)
  FROM user_actions
  WHERE EXTRACT(month from event_date) = 6 AND EXTRACT(year from event_date) = 2022
  )
AND EXTRACT(month from event_date) = 7 AND EXTRACT(year from event_date) = 2022
GROUP BY mth;

/* Bài 6: https://leetcode.com/problems/monthly-transactions-i/?envType=study-plan-v2&envId=top-sql-50 */

SELECT 
    TO_CHAR(trans_date, 'YYYY-MM') AS month,
    country,
    COUNT(*) AS trans_count,
    SUM(amount) AS trans_total_amount,
    COUNT(CASE WHEN state = 'approved' THEN 1 END) AS approved_count,
    SUM(CASE WHEN state = 'approved' THEN amount ELSE 0 END) AS approved_total_amount
FROM Transactions
GROUP BY TO_CHAR(trans_date, 'YYYY-MM'), country;


/* Bài 7:https://leetcode.com/problems/product-sales-analysis-iii/?envType=study-plan-v2&envId=top-sql-50 */

SELECT 
    product_id,
    year AS first_year,
    quantity,
    price
FROM Sales
WHERE (product_id, year) IN (
    SELECT product_id, MIN(year) AS first_year
    FROM Sales
    GROUP BY product_id
);


/* Bài tập 8 :https://leetcode.com/problems/customers-who-bought-all-products/?envType=study-plan-v2&envId=top-sql-50 */

SELECT CUSTOMER_ID 
FROM Customer
group by customer_id 
having count(distinct product_key )=(
    SELECT count(distinct product_key) from Product 
    );

/* Bài tập 9: https://leetcode.com/problems/employees-whose-manager-left-the-company/?envType=study-plan-v2&envId=top-sql-50 */

SELECT employee_id
FROM Employees 
WHERE salary <30000 AND manager_id not in (
    SELECT employee_id  FROM Employees 
)

/* Bài tập 10: https://datalemur.com/questions/duplicate-job-listings */

select count (DISTINCT company_id) AS duplicate_companies
FROM
(SELECT 
company_id,
title,
description,
COUNT(job_id)
from job_listings
GROUP BY company_id,title,description
HAVING COUNT(job_id)>1) AS job_count

/* Bài 11: https://leetcode.com/problems/movie-rating/description/?envType=study-plan-v2&envId=top-sql-50 */

(
  SELECT name AS results
  FROM Users u
  JOIN MovieRating mr ON u.user_id = mr.user_id
  GROUP BY u.user_id, u.name
  ORDER BY COUNT(*) DESC, u.name ASC
  LIMIT 1
)
UNION ALL
(
  SELECT title AS results
  FROM Movies m
  JOIN MovieRating mr ON m.movie_id = mr.movie_id
  WHERE mr.created_at BETWEEN '2020-02-01' AND '2020-02-29'
  GROUP BY m.movie_id, m.title
  ORDER BY AVG(mr.rating) DESC, m.title ASC
  LIMIT 1
); 

/* Bìa 12: https://leetcode.com/problems/friend-requests-ii-who-has-the-most-friends/?envType=study-plan-v2&envId=top-sql-50 */
WITH all_ids AS (
   SELECT requester_id AS id 
   FROM RequestAccepted
   UNION ALL
   SELECT accepter_id AS id
   FROM RequestAccepted)
SELECT id, 
   COUNT(id) AS num
FROM all_ids
GROUP BY id
ORDER BY COUNT(id) DESC
LIMIT 1

