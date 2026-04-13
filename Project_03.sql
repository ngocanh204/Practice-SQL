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

--TÍNH TOÁN GIÁ TRỊ R-F-M THÔ 
WITH twt_rfm_value AS (
    SELECT 
        customername,
        EXTRACT(DAY FROM (CURRENT_DATE - MAX(orderdate))) AS Recency,
        COUNT(DISTINCT ordernumber) AS Frequency,
        SUM(sales) AS Monetary
    FROM public.sales_dataset_rfm_prj
    GROUP BY customername
),

-- CHẤM ĐIỂM THEO THANG ĐIỂM 1-5 THEO CÁC PHÂN VỊ
RFM_Score AS (
    SELECT
        customername,
        NTILE(5) OVER(ORDER BY recency DESC) AS R_score,
        NTILE(5) OVER(ORDER BY frequency ASC) AS F_score,
        NTILE(5) OVER(ORDER BY monetary ASC) AS M_score
    FROM twt_rfm_value
),
-- HỢP NHẤT CHỈ SỐ RFM
RFM AS (
    SELECT 
        customername,
        -- Chuyển đổi kiểu dữ liệu sang VARCHAR để ghép chuỗi điểm (ví dụ: 5-5-5).
        CAST(R_score AS VARCHAR) || CAST(F_score AS VARCHAR) || CAST(M_score AS VARCHAR) AS RFM_combined
    FROM RFM_Score
)
-- ĐỊNH DANH PHÂN KHÚC VÀ TRÍCH XUẤT NHÓM MỤC TIÊU 
SELECT 
    customername,
    RFM_combined,
    segment
FROM RFM AS RFM 
JOIN public.segment_score AS Segment
    ON RFM.RFM_combined = Segment.scores
WHERE segment = 'Champions';
