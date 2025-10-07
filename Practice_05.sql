/* Bài tập 1: https://www.hackerrank.com/challenges/average-population-of-each-continent/problem */
SELECT COUNTRY.Continent,
FLOOR(AVG(CITY.Population))
FROM COUNTRY
INNER JOIN city 
ON CITY.COUNTRYCODE=COUNTRY.CODE
GROUP BY COUNTRY.Continent


/* Bài tập 2: https://datalemur.com/questions/signup-confirmation-rate */
SELECT 
ROUND(CAST(COUNT(signup_action) AS decimal)/COUNT(user_id),2) as confirm_rate
FROM emails
LEFT JOIN texts ON emails.email_id=texts.email_id
AND texts.signup_action='Confirmed'

/* Bài tập 3:https://datalemur.com/questions/time-spent-snaps */
SELECT b.age_bucket, 
ROUND((SUM(CASE WHEN activity_type  = 'send' THEN time_spent ELSE 0 END)* 100.0 /SUM(time_spent)),2) AS send_perc, 
ROUND((SUM(CASE WHEN activity_type  = 'open' THEN time_spent ELSE 0 END)* 100.0 /SUM(time_spent)),2) AS open_perc 
FROM activities as a
LEFT JOIN age_breakdown as b ON a.user_id = b.user_id
WHERE activity_type IN ('open', 'send')
GROUP BY b.age_bucket;

/* Bài tập 4: https://datalemur.com/questions/supercloud-customer */
SELECT customer_id
FROM customer_contracts
INNER JOIN products 
ON products.product_id=customer_contracts.product_id
GROUP BY customer_id
HAVING COUNT(DISTINCT product_category)=3

/* Bài tập 5: https://leetcode.com/problems/the-number-of-employees-which-report-to-each-employee/?envType=study-plan-v2&envId=top-sql-50 */
SELECT 
a.employee_id,
a.name,
COUNT(b.reports_to) as reports_count,
ROUND(avg(b.age)) as average_age
FROM Employees as a
JOIN Employees as b
ON a.employee_id=b.reports_to
GROUP BY a.employee_id


/* Bài tập 6: https://leetcode.com/problems/list-the-products-ordered-in-a-period/?envType=study-plan-v2&envId=top-sql-50 */
SELECT a.product_name,
SUM(unit) AS unit
FROM Products as a
LEFT JOIN Orders as b
ON a.product_id=b.product_id
WHERE b.order_date LIKE '2020-02-%'
GROUP BY a.product_name
HAVING SUM(unit)>=100

/* Bài tập 7: https://datalemur.com/404 */

WEB LỖI Ạ 

/* Câu hỏi 1:

Question 1:

Level: Basic

Topic: DISTINCT

Task: Tạo danh sách tất cả chi phí thay thế (replacement costs ) khác nhau của các film.

Question: Chi phí thay thế thấp nhất là bao nhiêu?

Answer: 9.99 */

SELECT DISTINCT replacement_cost
FROM film
ORDER BY replacement_cost ASC


/* Question 2:

Level: Intermediate

Topic: CASE + GROUP BY

Task: Viết một truy vấn cung cấp cái nhìn tổng quan về số lượng phim có chi phí thay thế trong các phạm vi chi phí sau

1. low: 9.99 - 19.99

2. medium: 20.00 - 24.99

3. high: 25.00 - 29.99

Question: Có bao nhiêu phim có chi phí thay thế thuộc nhóm “low”?

Answer: 514 */

SELECT 
CASE 
WHEN replacement_cost BETWEEN 9.99 and 19.99 then 'low'
WHEN replacement_cost BETWEEN 20.00 and 24.99 then 'medium'
WHEN replacement_cost BETWEEN 25.00 and 29.99 then 'high'
END AS cost_category,
COUNT (*) AS FILM_COUNT
FROM FILM
GROUP BY cost_category

/* Question 3:

Level: c

Topic: JOIN

Task: Tạo danh sách các film_title bao gồm tiêu đề (title), 
độ dài (length) và tên danh mục (category_name) được sắp xếp theo độ dài giảm dần. 
Lọc kết quả để chỉ các phim trong danh mục 'Drama' hoặc 'Sports'.

Question: Phim dài nhất thuộc thể loại nào và dài bao nhiêu?

Answer: Sports : 184 */

SELECT a.title, a.length,c.name AS category_name
FROM film as a
JOIN public.film_category as b ON a.film_id=b.film_id
JOIN public.category as c ON b.category_id=c.category_id
WHERE c.name='Drama' OR c.name='Sports'
ORDER BY a.length DESC

/* Question 4:

Level: Intermediate

Topic: JOIN & GROUP BY

Task: Đưa ra cái nhìn tổng quan về số lượng phim (tilte) trong mỗi danh mục (category).

Question:Thể loại danh mục nào là phổ biến nhất trong số các bộ phim?

Answer: Sports :74 titles */

SELECT c.name,
COUNT(c.name) AS category
FROM film as a
JOIN public.film_category as b ON a.film_id=b.film_id
JOIN public.category as c ON b.category_id=c.category_id
GROUP BY c.name
ORDER BY category DESC

/* Question 5:

Level: Intermediate

Topic: JOIN & GROUP BY

Task:Đưa ra cái nhìn tổng quan về họ và tên của các diễn viên cũng như số lượng phim họ tham gia.

Question: Diễn viên nào đóng nhiều phim nhất?

Answer: Susan Davis : 54 movies */

SELECT a.first_name,a.last_name,
COUNT(film_id) AS count_film
FROM public.actor AS a
JOIN public.film_actor AS b 
ON a.actor_id=b.actor_id
GROUP BY a.first_name,a.last_name
ORDER BY COUNT(film_id) DESC

/* Question 6:

Level: Intermediate

Topic: LEFT JOIN & FILTERING

Task: Tìm các địa chỉ không liên quan đến bất kỳ khách hàng nào.

Question: Có bao nhiêu địa chỉ như vậy?
Answer: 4 */

SELECT COUNT(*) AS address_without_customer
FROM address a
LEFT JOIN customer b
ON a.address_id = b.address_id
WHERE b.customer_id IS NULL;

/* Question 7:

Level: Intermediate

Topic: JOIN & GROUP BY

Task: Danh sách các thành phố và doanh thu tương ừng trên từng thành phố

Question: Thành phố nào đạt doanh thu cao nhất ?

Answer: Cape Coral : 221.55 */

SELECT d.city,
SUM(a.amount) as doanh_thu
FROM public.payment as a
JOIN public.customer as b ON a.customer_id=b.customer_id
JOIN public.address as c ON b.address_id=c.address_id
JOIN public.city as d ON c.city_id=d.city_id
GROUP BY d.city
ORDER BY SUM(a.amount) DESC

/* Question 8:

Level: Intermediate

Topic: JOIN & GROUP BY

Task: Tạo danh sách trả ra 2 cột dữ liệu:

- cột 1: thông tin thành phố và đất nước ( format: “city, country")

- cột 2: doanh thu tương ứng với cột 1

Question: Thành phố của đất nước nào đat doanh thu thấp nhất ?

Answer: United States, Tallahassee : 50.85 */

SELECT 
city.city || ', ' || country.country AS city_country,
    SUM(payment.amount) AS total_revenue
FROM payment
JOIN rental ON payment.rental_id = rental.rental_id
JOIN customer ON rental.customer_id = customer.customer_id
JOIN address ON customer.address_id = address.address_id
JOIN city ON address.city_id = city.city_id
JOIN country ON city.country_id = country.country_id
GROUP BY city_country
ORDER BY total_revenue ASC;




