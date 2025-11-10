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

/* Bài tập 4: 
