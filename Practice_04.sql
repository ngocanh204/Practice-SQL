/* Bài tập 1:https://datalemur.com/questions/laptop-mobile-viewership */
SELECT 
COUNT(CASE
WHEN device_type ='laptop' THEN 0
END) as Laptop_views,
COUNT(CASE
WHEN device_type IN ('tablet','phone') THEN 0
END) as mobile_views
FROM viewership

/* Bài tập 2:https://leetcode.com/problems/triangle-judgement/?envType=study-plan-v2&envId=top-sql-50 */
SELECT x,y,z,
CASE 
WHEN x+y>z and x+z>y and z+y>x THEN 'Yes'
ELSE 'No'
END AS triangle
FROM Triangle

/* Bài tập 3:https://datalemur.com/questions/uncategorized-calls-percentage */





/* Bài tập 4 https://leetcode.com/problems/find-customer-referee/?envType=study-plan-v2&envId=top-sql-50 */
SELECT name FROM Customer 
WHERE referee_id !=2 OR referee_id IS NULL

/* Bài tập 5 https://platform.stratascratch.com/coding/9881-make-a-report-showing-the-number-of-survivors-and-non-survivors-by-passenger-class?code_type=1 */
select survived,
COUNT(CASE 
WHEN pclass='1' THEN 1
END) AS first_class,
COUNT(CASE 
WHEN pclass='2' THEN 1
END) AS second_class,
COUNT(CASE
WHEN pclass='3' THEN 1
END) AS third_class
from titanic
GROUP BY survived
