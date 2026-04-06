--1. Thống kê tổng số lượng người mua và số lượng đơn hàng đã hoàn thành mỗi tháng 
-- Từ tháng 1/2019 --> 4/2022
-- Insight là gì? --> Nhận xét về sự tăng giảm theo thời gian
-- Output: month_year (yyyy-mm), total_user, total_order
WITH twt_table as (
SELECT 
FORMAT_TIMESTAMP('%Y-%m', delivered_at) AS month,
user_id,order_id
FROM bigquery-public-data.thelook_ecommerce.order_items
WHERE status='Complete' AND DATE(delivered_at) BETWEEN '2019-01-01' AND '2022-04-30')

SELECT month as month_year,
COUNT(distinct user_id) as total_user,
COUNT(distinct order_id) as total_order
FROM twt_table
GROUP BY month
ORDER BY month_year ASC;


-- 2. giá trị đơn hàng trung bình và số lượng khách hàng mỗi tháng 
-- Từ 1/2019 --> 4/2022
-- Output: Month_year, distinct_user, average_order_value

WITH twt_table_1 as (
SELECT 
FORMAT_TIMESTAMP('%Y-%m', delivered_at) AS month,
user_id,order_id,sale_price
FROM bigquery-public-data.thelook_ecommerce.order_items
WHERE DATE(delivered_at) BETWEEN '2019-01-01' AND '2022-04-30')

SELECT month as month_year,
COUNT(distinct user_id) as distinct_users,
SUM(sale_price)/COUNT(order_id) as average_order_value
FROM twt_table_1
GROUP BY month_year;

-- 3.Nhóm khách hàng theo độ tuổi
-- Tìm các khách hàng có trẻ tuổi nhất và lớn tuổi nhất theo từng giới tính(Từ 1/2019 - 4/2022 )
-- Output: first_name,last_name,gender,age,tag(hiển thị youngest nếu trẻ tuổi nhất, oldest nếu lớn tuổi nhất)

WITH twt_table_3 AS (
  SELECT *
  FROM `bigquery-public-data.thelook_ecommerce.order_items` a
  JOIN `bigquery-public-data.thelook_ecommerce.users` b
  ON a.user_id = b.id
  WHERE DATE(delivered_at) BETWEEN '2019-01-01' AND '2022-04-30'
)

-- youngest Female
SELECT 
  first_name,
  last_name,
  gender,
  age,
  'youngest' AS tag
FROM twt_table_3
WHERE gender = 'F'
AND age = (
  SELECT MIN(age)
  FROM twt_table_3
  WHERE gender = 'F'
)

UNION ALL

-- youngest Male
SELECT 
  first_name,
  last_name,
  gender,
  age,
  'youngest' AS tag
FROM twt_table_3
WHERE gender = 'M'
AND age = (
  SELECT MIN(age)
  FROM twt_table_3
  WHERE gender = 'M'
)

UNION ALL

-- oldest Female
SELECT 
  first_name,
  last_name,
  gender,
  age,
  'oldest' AS tag
FROM twt_table_3
WHERE gender = 'F'
AND age = (
  SELECT MAX(age)
  FROM twt_table_3
  WHERE gender = 'F'
)

UNION ALL

-- oldest Male
SELECT 
  first_name,
  last_name,
  gender,
  age,
  'oldest' AS tag
FROM twt_table_3
WHERE gender = 'M'
AND age = (
  SELECT MAX(age)
  FROM twt_table_3
  WHERE gender = 'M'
);

-- 4. Top 5 sản phẩm mỗi tháng 
-- top 5 sản phẩm có lợi nhuận cao nhất từng tháng
-- Output: month_year (yyyy-mm), product_id, product_name, sale, cost,profit, rank_per_month 
WITH twt_table_4 as (
SELECT * 
FROM bigquery-public-data.thelook_ecommerce.order_items as a
JOIN bigquery-public-data.thelook_ecommerce.products as b
ON a.product_id=b.id
WHERE a.status='Complete'), 
agg as (SELECT 
FORMAT_TIMESTAMP('%Y-%m', delivered_at) AS month,
product_id,
name as product_name,
SUM(sale_price) as sales,
SUM(cost) as cost,
SUM(sale_price)-SUM(cost) AS profit
FROM twt_table_4
GROUP BY month,product_id,product_name),
ranked as (
  SELECT *,
  DENSE_RANK() OVER(PARTITION BY month ORDER BY profit DESC) as rank_per_month 
  FROM agg)

  SELECT *
  FROM ranked
  WHERE rank_per_month <=5
  ORDER BY month,rank_per_month;
