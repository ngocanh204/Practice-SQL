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


/* Bài tập 4: https://datalemur.com/questions/histogram-users-purchases */

with twt_nearest_time_trans as(
SELECT 
transaction_date,
user_id,
DENSE_RANK() OVER(PARTITION BY user_id ORDER BY transaction_date DESC) AS time_rank
FROM user_transactions) 

SELECT 
transaction_date,
user_id,
COUNT(*) 
FROM twt_nearest_time_trans
WHERE time_rank=1 
GROUP BY transaction_date,user_id

/́ Bài tập 5: https://datalemur.com/questions/rolling-average-tweets */

SELECT    
  user_id,    
  tweet_date,   
  ROUND(AVG(tweet_count) OVER (
    PARTITION BY user_id     
    ORDER BY tweet_date     
    ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)
  ,2) AS rolling_avg_3d
FROM tweets;

/* Bài tập 6: https://datalemur.com/questions/repeated-payments */

with twt_payments as (SELECT 
merchant_id,
credit_card_id,
amount,
transaction_timestamp,
EXTRACT(MINUTE from transaction_timestamp) - 
EXTRACT(MINUTE FROM Lag(transaction_timestamp) OVER(PARTITION BY merchant_id,credit_card_id,amount ORDER BY transaction_timestamp )) as minute_difference 
FROM transactions)

SELECT COUNT(merchant_id) AS payment_count
FROM twt_payments 
WHERE minute_difference BETWEEN 0 and 9 

/* Bài tập 7: https://datalemur.com/questions/sql-highest-grossing */

with twt_ranking AS  (
SELECT 
category,
product,
SUM(spend) as total_spend,
RANK()  OVER (PARTITION BY category ORDER BY SUM(spend) desc) as ranking  
FROM product_spend 
WHERE EXTRACT(YEAR FROM transaction_date) = 2022
GROUP BY category, product)
SELECT 
category,
product,
total_spend
FROM twt_ranking
WHERE ranking in (1,2)

/* Bài tập 8: https://datalemur.com/questions/top-fans-rank */

WITH TWT_SONG AS(
SELECT
a.artist_name,
DENSE_RANK() OVER(ORDER BY COUNT(b.song_id) desc) AS artist_rank
FROM artists as a 
JOIN songs as b ON a.artist_id=b.artist_id
JOIN global_song_rank as c ON b.song_id=c.song_id
WHERE c.rank <= 10
GROUP BY a.artist_name)
SELECT 
artist_name,
artist_rank
FROM TWT_SONG
WHERE artist_rank <= 5


