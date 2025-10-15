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



