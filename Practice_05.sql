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
