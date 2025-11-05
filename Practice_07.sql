/* Bài tập 1: https://datalemur.com/questions/yoy-growth-rate */

SELECT
EXTRACT(YEAR from transaction_date) AS year,
product_id,
spend as curr_year_spend,
LAG(spend) OVER(PARTITION BY product_id ) as prev_year_spend,
ROUND((spend-LAG(spend) OVER(PARTITION BY product_id) )*100/LAG(spend) OVER(PARTITION BY product_id ),2) as yoy_rate
FROM user_transactions

/* Bài tập 2: https://datalemur.com/questions/card-launch-success */ 

WITH twt_rank_table as (SELECT 
card_name,
issue_year,
issue_month,
issued_amount,
DENSE_RANK() OVER(PARTITION BY card_name ORDER BY issue_year ASC,issue_month ASC) as Rank_amount
FROM monthly_cards_issued) 

SELECT 
card_name,
issued_amount
FROM twt_rank_table
WHERE rank_amount=1 
ORDER BY card_name DESC

/* Bài tập 3: https://datalemur.com/questions/sql-third-transaction */

WITH twt_transaction_3rd as(
SELECT *,
COUNT(*) OVER(PARTITION BY user_id ) as count_transaction,
DENSE_RANK() OVER(PARTITION BY user_id ORDER BY transaction_date ASC) as rank_transaction
FROM transactions ) 

SELECT user_id,
spend,
transaction_date
FROM twt_transaction_3rd 
WHERE count_transaction>=3 and rank_transaction=3 
