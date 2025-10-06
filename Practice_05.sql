/* Bài tập 1: https://www.hackerrank.com/challenges/average-population-of-each-continent/problem */
SELECT COUNTRY.Continent,
FLOOR(AVG(CITY.Population))
FROM COUNTRY
INNER JOIN city 
ON CITY.COUNTRYCODE=COUNTRY.CODE
GROUP BY COUNTRY.Continent


/* Bài tập 2: https://datalemur.com/questions/signup-confirmation-rate */
SELECT 
ROUND(CAST(COUNT(signup_action) AS decimal)/COUNT(user_id),2) as confirm_rate
FROM emails
LEFT JOIN texts ON emails.email_id=texts.email_id
AND texts.signup_action='Confirmed'

/* Bài tập 3:https://datalemur.com/questions/time-spent-snaps */
SELECT b.age_bucket, 
ROUND((SUM(CASE WHEN activity_type  = 'send' THEN time_spent ELSE 0 END)* 100.0 /SUM(time_spent)),2) AS send_perc, 
ROUND((SUM(CASE WHEN activity_type  = 'open' THEN time_spent ELSE 0 END)* 100.0 /SUM(time_spent)),2) AS open_perc 
FROM activities as a
LEFT JOIN age_breakdown as b ON a.user_id = b.user_id
WHERE activity_type IN ('open', 'send')
GROUP BY b.age_bucket;

/* Bài tập 4: https://datalemur.com/questions/supercloud-customer */
SELECT customer_id
FROM customer_contracts
INNER JOIN products 
ON products.product_id=customer_contracts.product_id
GROUP BY customer_id
HAVING COUNT(DISTINCT product_category)=3

/* Bài tập 5: https://leetcode.com/problems/the-number-of-employees-which-report-to-each-employee/?envType=study-plan-v2&envId=top-sql-50 */
SELECT 
a.employee_id,
a.name,
COUNT(b.reports_to) as reports_count,
ROUND(avg(b.age)) as average_age
FROM Employees as a
JOIN Employees as b
ON a.employee_id=b.reports_to
GROUP BY a.employee_id
