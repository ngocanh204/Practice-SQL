--1.Chuyển đổi trường dữ liệu phù hợp cho các trường

ALTER TABLE public.sales_dataset_rfm_prj
ALTER COLUMN ordernumber TYPE INT USING NULLIF(TRIM(ordernumber), '')::INT,
ALTER COLUMN quantityordered TYPE INT USING NULLIF(TRIM(quantityordered), '')::INT,
ALTER COLUMN priceeach TYPE DECIMAL(10,2) USING NULLIF(TRIM(priceeach), '')::DECIMAL,
ALTER COLUMN orderlinenumber TYPE INT USING NULLIF(TRIM(orderlinenumber), '')::INT,
ALTER COLUMN sales TYPE DECIMAL(10,2) USING NULLIF(TRIM(sales), '')::DECIMAL,
ALTER COLUMN orderdate TYPE TIMESTAMP USING TO_TIMESTAMP(orderdate, 'MM/DD/YYYY HH24:MI'),
ALTER COLUMN status TYPE VARCHAR(20),
ALTER COLUMN msrp TYPE INT USING NULLIF(TRIM(msrp), '')::INT,
ALTER COLUMN phone TYPE VARCHAR(50);


--2. Check NULL/BLANK (‘’) ở các trường: ORDERNUMBER, QUANTITYORDERED, PRICEEACH, ORDERLINENUMBER, SALES, ORDERDATE

SELECT *
FROM public.sales_dataset_rfm_prj
WHERE 
    ordernumber IS NULL
    OR quantityordered IS NULL
    OR priceeach IS NULL
    OR orderlinenumberr IS NULL
    OR sales IS NULL
    OR orderdate IS NULL; 

/* 3.Thêm cột CONTACTLASTNAME, CONTACTFIRSTNAME được tách ra từ CONTACTFULLNAME .

Chuẩn hóa CONTACTLASTNAME, CONTACTFIRSTNAME theo định dạng chữ cái đầu tiên viết hoa, chữ cái tiếp theo viết thường. */

ALTER TABLE public.sales_dataset_rfm_prj
ADD COLUMN contactlastname VARCHAR(50),
ADD COLUMN contactfirstname VARCHAR(50);

UPDATE public.sales_dataset_rfm_prj
SET 
    contactlastname = 
        UPPER(LEFT(SPLIT_PART(contactfullname, '-', 1), 1)) ||
        LOWER(SUBSTRING(SPLIT_PART(contactfullname, '-', 1) FROM 2)),
        
    contactfirstname = 
        UPPER(LEFT(SPLIT_PART(contactfullname, '-', 2), 1)) ||
        LOWER(SUBSTRING(SPLIT_PART(contactfullname, '-', 2) FROM 2));

-- 4.Thêm cột QTR_ID, MONTH_ID, YEAR_ID lần lượt là Qúy, tháng, năm được lấy ra từ ORDERDATE

ALTER TABLE public.sales_dataset_rfm_prj
ADD COLUMN qtr_id VARCHAR(50),
ADD COLUMN month_id VARCHAR(50),
ADD COLUMN year_id VARCHAR(50)

UPDATE public.sales_dataset_rfm_prj
SET qtr_id=EXTRACT(QUARTER FROM ORDERDATE),
month_id=EXTRACT(MONTH FROM ORDERDATE),
YEAR_ID=EXTRACT(YEAR FROM ORDERDATE)

-- 5. Hãy tìm outlier (nếu có) cho cột QUANTITYORDERED và hãy chọn cách xử lý cho bản ghi đó

-- Q1,Q3 VÀ IQR VÀ LƯU NÓ VÀO BẢNG TẠM
WITH twt_iqr_table as(
SELECT 
PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY QUANTITYORDERED) AS q1,
PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY QUANTITYORDERED) AS q3,
PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY QUANTITYORDERED) - PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY QUANTITYORDERED) as IQR
FROM public.sales_dataset_rfm_prj),
-- Tìm cận trên/cận dưới
twt_bound as(
SELECT q1,q3,iqr,
(q1-1,5*iqr) as Min_bound,
(q3+1,5*iqr) as Max_bound
FROM twt_iqr_table)
--Tìm bản ghi có giá trị nhỏ hơn 26,89 hoặc lớn hơn 44,80
SELECT * FROM public.sales_dataset_rfm_prj
WHERE quantityordered <26.89 OR quantityordered>44.80;

--Có 2 cách xử lý cho các bản ghi outlier

-- Cách 1: Xóa bản ghi lỗi 

-- KHÔNG chạy khi chưa backup

DELETE FROM public.sales_dataset_rfm_prj
WHERE quantityordered <26.89 OR quantityordered>44.80;

-- Cách 2: Thay thế Mode
with twt_mode as (
SELECT 
MODE() WITHIN GROUP(ORDER BY quantityordered) AS mode_value
FROM public.sales_dataset_rfm_prj )

UPDATE public.sales_dataset_rfm_prj
SET quantityordered=mode_value
FROM twt_mode
WHERE quantityordered < 26.89 OR quantityordered >44.80 
   
-- Thay thế Mean
UPDATE public.sales_dataset_rfm_prj
SET quantityordered = (
SELECT AVG(quantityordered)
FROM public.sales_dataset_rfm_prj
GROUP BY quantityordered)
WHERE quantityordered < 26.89 OR quantityordered >44.80 ;
