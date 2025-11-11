/* Bài tập 1:https://leetcode.com/problems/immediate-food-delivery-ii/?envType=study-plan-v2&envId=top-sql-50 */

WITH twt_delivery as (
    SELECT 
customer_id,order_date,
customer_pref_delivery_date ,
DENSE_RANK() OVER(PARTITION BY customer_id ORDER BY order_date  ASC) as rank_order_date
FROM Delivery) 

SELECT
(SELECT 
COUNT(*)
FROM twt_delivery
WHERE order_date =customer_pref_delivery_date and rank_order_date =1)*100.00/COUNT(*) as immediate_percentage 
FROM twt_delivery
WHERE rank_order_date =1

/* Bài tập 2: https://leetcode.com/problems/game-play-analysis-iv/description/?envType=study-plan-v2&envId=top-sql-50 */

WITH ordered AS (
    SELECT 
        player_id,
        event_date,
        LEAD(event_date) OVER(PARTITION BY player_id ORDER BY event_date) AS next_date,
        ROW_NUMBER() OVER(PARTITION BY player_id ORDER BY event_date) AS rn
    FROM Activity
)
SELECT 
    ROUND(
        SUM(CASE WHEN next_date = event_date + INTERVAL '1 day' THEN 1 ELSE 0 END)::numeric
        / COUNT(*), 2
    ) AS fraction
FROM ordered
WHERE rn = 1;

/* Bài tập 3: https://leetcode.com/problems/exchange-seats/?envType=study-plan-v2&envId=top-sql-50 */

SELECT 
CASE WHEN 
id %2=1 and id=(SELECT MAX(id) FROM Seat) then id
WHEN id %2=1 then id+1 
ELSE id-1 
END as id, 
student 
FROM Seat 
ORDER BY id asc

/* Bài tập 4: https://leetcode.com/problems/restaurant-growth/?envType=study-plan-v2&envId=top-sql-50 */

WITH TWT_AMOUNT as (
    SELECT visited_on   ,
    SUM(amount) as daily_amount
    FROM Customer 
    GROUP BY visited_on   
),
seven_day as (
    SELECT visited_on,
    SUM( daily_amount) OVER(ORDER BY visited_on
    ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) AS amount,
    ROUND(AVG(daily_amount) OVER(ORDER BY visited_on  ROWS BETWEEN 6 PRECEDING AND CURRENT ROW),2) as average_amount ,
    COUNT(*) OVER(ORDER BY visited_on
    ROWS BETWEEN 6 PRECEDING AND CURRENT ROW) as Day_count
    FROM TWT_AMOUNT
)
SELECT 
visited_on,amount ,average_amount  
from seven_day
WHERE Day_count = 7 


/* Bài tập 5: https://leetcode.com/problems/investments-in-2016/?envType=study-plan-v2&envId=top-sql-50 */

WITH twt_city as(
SELECT lat, lon
FROM Insurance
GROUP BY lat, lon
HAVING COUNT(*) = 1
), 
duplicate_twt as(
SELECT tiv_2015,
COUNT(tiv_2015)
FROM Insurance
GROUP BY tiv_2015
HAVING COUNT(tiv_2015) >1
)

select  
ROUND(SUM(tiv_2016)::numeric ,2) as tiv_2016 
FROM Insurance
WHERE tiv_2015 in (SELECT tiv_2015 FROM duplicate_twt )
AND (lat, lon) in (SELECT lat, lon FROM twt_city)


/* Bài tập 6: https://leetcode.com/problems/department-top-three-salaries/?envType=study-plan-v2&envId=top-sql-50 */

WITH twt_company as (
    SELECT 
b.name as Department ,
a.name as Employee ,
a.Salary,
DENSE_RANK() OVER(PARTITION BY b.name ORDER BY a.Salary DESC)
FROM Employee as a 
JOIN Department AS b 
ON a.departmentId = b.id )

SELECT department,
employee,
salary 
FROM twt_company
WHERE dense_rank <=3
