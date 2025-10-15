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
