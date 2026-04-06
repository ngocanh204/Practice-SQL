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



