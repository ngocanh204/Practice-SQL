-- PROJECT 3
-- 1.Doanh thu theo từng ProductLine,Year,Dealsize

SELECT
productline,
year_id,
dealsize,
SUM(sales) as revenue
FROM public.sales_dataset_rfm_prj
GROUP BY productline, year_id, dealsize
ORDER BY year_id DESC, revenue DESC;

--2. Đâu là tháng có bán tốt nhất mỗi năm
-- Output: MONTH_ID, REVENUE, ORDER_NUMBER
SELECT year_id,month_id, revenue, order_number FROM (
SELECT month_id, year_id,
SUM(sales) as revenue,
COUNT(ordernumber) AS order_number,
ROW_NUMBER() OVER(PARTITION BY year_id ORDER BY SUM(sales) DESC) as rank
FROM public.sales_dataset_rfm_prj
GROUP BY month_id, year_id ) AS subquery 
WHERE RANK=1
--3. Productline nào được bán nhiều ở tháng 11
-- Output: month_id, revenue, order_number

SELECT month_id,
SUM(sales) as revenue,
COUNT(ordernumber) AS order_number,
productline
FROM public.sales_dataset_rfm_prj
WHERE month_id='11' 
GROUP BY month_id,Productline
ORDER BY revenue DESC
LIMIT 1;

--4. Sản phẩm có doanh thu tốt nhất ở UK mỗi năm
-- Xếp hạng doanh thu đó theo từng năm
-- year_id,productline,revennue, rank

SELECT year_id,
productline,
SUM(sales) as revenue,
RANK() OVER(PARTITION BY year_id ORDER BY year_id,SUM(sales) DESC) as rank
FROM public.sales_dataset_rfm_prj
WHERE country='UK'
GROUP BY year_id,productline

--5. Ai là khách hàng tốt nhất, phân tích dựa vào RFM
SELECT 
custmername,
CURRENT_DATE - MAX
