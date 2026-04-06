/* Hackerrank Bài tập 1:https://www.hackerrank.com/challenges/revising-the-select-query-2/problem?isFullScreen=true */
Select name from city   
WHERE countrycode = 'USA' AND population>120000

/* Hackerrank Bài tập 2:https://www.hackerrank.com/challenges/japanese-cities-attributes/problem?isFullScreen=true */
SELECT * FROM city 
WHERE countrycode = "JPN"

/* Hackerrank Bài tập 3 :https://www.hackerrank.com/challenges/weather-observation-station-1/problem?isFullScreen=true */
SELECT city,state From Station

/* Hackerrank Bài tập 4 :https://www.hackerrank.com/challenges/weather-observation-station-6/problem?isFullScreen=true */
SELECT DISTINCT city From station 
WHERE city LIKE 'I%' or city LIKE 'E%' OR city LIKE 'O%' OR city LIKE 'A%' OR city LIKE 'U%'

/* Hackerrank Bài tập 5 :https://www.hackerrank.com/challenges/weather-observation-station-7/problem?isFullScreen=true */
SELECT DISTINCT city FROM station
WHERE city LIKE '%a' OR city LIKE '%e' OR city LIKE '%i' OR city LIKE '%o' OR city LIKE '%u'

/* Hackerrank Bài tập 6 :https://www.hackerrank.com/challenges/weather-observation-station-9/problem?isFullScreen=true */
SELECT DISTINCT city FROM station 
WHERE city NOT LIKE 'A%' AND city NOT LIKE 'U%' AND city NOT LIKE 'E%' AND city NOT LIKE 'O%'
AND city NOT LIKE 'I%'

/* Hackerrank Bài tập 7 :https://www.hackerrank.com/challenges/name-of-employees/problem?isFullScreen=true */
SELECT name FROM employee
ORDER BY name ASC

/* Hackerrank Bài tập 8 :https://www.hackerrank.com/challenges/salary-of-employees/problem?isFullScreen=true */
SELECT name FROM employee 
WHERE salary>2000 and months<10
ORDER BY employee_id ASC

/* Leetcode  Bài tập 9 :https://leetcode.com/problems/recyclable-and-low-fat-products/description/?envType=study-plan-v2&envId=top-sql-50 */
    SELECT product_id FROM Products 
    WHERE low_fats='Y' AND recyclable='Y'

/* Leetcode Bài tập 10 :https://leetcode.com/problems/find-customer-referee/description/?envType=study-plan-v2&envId=top-sql-50 */
SELECT name FROM Customer 
WHERE referee_id !=2 OR referee_id IS NULL

/* Leetcode Bài tập 11 :https://leetcode.com/problems/big-countries/description/?envType=study-plan-v2&envId=top-sql-50 */
# Write your MySQL query statement below
SELECT name, population, area FROM World
WHERE area>=3000000 OR population>=25000000

/* Leetcode Bài tập 12 :https://leetcode.com/problems/article-views-i/?envType=study-plan-v2&envId=top-sql-50 */
SELECT DISTINCT author_id AS id FROM Views
WHERE author_id=viewer_id 
ORDER BY author_id

/* Datalemur Bài tập 13 :https://datalemur.com/questions/tesla-unfinished-parts */
SELECT part, assembly_step
FROM parts_assembly
WHERE finish_date is NULL

/* Stratascratch Bài tập 14 :https://platform.stratascratch.com/coding/10003-lyft-driver-wages?code_type=1 */
select * from lyft_drivers 
Where yearly_salary<=30000 OR yearly_salary>=70000 

/* Stratascratch Bài tập 15 :https://platform.stratascratch.com/coding/10002-find-the-advertising-channel-where-uber-spent-more-than-100k-usd-in-2019?code_type=1 */
select advertising_channel from uber_advertising
WHERE year=2019 AND money_spent >=100000 
