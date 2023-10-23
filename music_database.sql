-- KEY SKILLS: aggregations, joins, sub-queries and with , case, date functions, window functions
-- EMPLOYEE ANALYSIS
-- QUERY 1 - WHO IS THE SENIOR MOST EMPLOYEE
SELECT employee_id
	,first_name
	,last_name
	,title
FROM employee
ORDER BY levels DESC LIMIT 1

-- QUERY 2 Most helpful Employee
SELECT e.first_name || ' ' || e.last_name employee
	,COUNT(c.customer_id)
FROM employee e
INNER JOIN customer c
	ON CAST(e.employee_id AS INT) = c.support_rep_id
INNER JOIN invoice i
	ON c.customer_id = i.customer_id
GROUP BY 1
ORDER BY 2 DESC

-- MArgaret Park did the most sales



-- REGIONAL ANALYSIS
-- Query 3 - Which countries have the most invoices
SELECT billing_country
	,COUNT(*)
FROM invoice
GROUP BY 1
ORDER BY 2 DESC LIMIT 1

-- USA had the most sales, 131


-- -- Query 4 - Top 3 cities with the biggest sum toal of invoices
SELECT billing_city
	,SUM(total) AS city_total
FROM invoice
GROUP BY 1
ORDER BY 2 DESC

-- Prague is the top city based on invoice totals



-- CUSTOMER ANALYSIS
-- -- Query 5 - BEST Customer based on total money spent by them
SELECT c.first_name || ' ' || c.last_name AS customer_
	,SUM(i.total)
FROM customer c
INNER JOIN invoice i
	ON c.customer_id = i.customer_id
GROUP BY 1
ORDER BY 2 DESC LIMIT 1

-- R Madhav is the best customer



-- Query 6 - FInd out email, first name, last name of all the listeners of rock genre
-- Arrange the listeners in alphatical order based on email
SELECT DISTINCT c.email
	,c.first_name
	,c.last_name
FROM genre g
INNER JOIN track t
	ON g.genre_id = t.genre_id
INNER JOIN invoice_line il
	ON il.track_id = t.track_id
INNER JOIN invoice i
	ON i.invoice_id = il.invoice_id
INNER JOIN customer c
	ON c.customer_id = i.customer_id
WHERE g.name = 'Rock'
ORDER BY 1

-- We found out that there are total 59 listeners of Rock genre



-- QUERY 7 Money Spent by each customer on each artist
SELECT (c.first_name || ' ' || c.last_name) AS cx
	,ar.artist_id
	,ar.name
	,SUM(il.quantity * il.unit_price)
FROM customer c
INNER JOIN invoice i
	ON c.customer_id = i.customer_id
INNER JOIN invoice_line il
	ON il.invoice_id = i.invoice_id
INNER JOIN track t
	ON il.track_id = t.track_id
INNER JOIN album al
	ON t.album_id = al.album_id
INNER JOIN artist ar
	ON ar.artist_id = al.artist_id
GROUP BY 1
	,2
	,3
ORDER BY 1
	,4 DESC
	
	
-- Query 8 Customer that has spent the most for each country
WITH customer_total_purchases AS (
		SELECT c.customer_id
			,(c.first_name || ' ' || c.last_name) AS customer
			,c.country
			,SUM(total) AS tot_spent
			,ROW_NUMBER() OVER (
				PARTITION BY c.country ORDER BY SUM(i.total) DESC
				) AS standing
		FROM invoice i
		INNER JOIN customer c
			ON c.customer_id = i.customer_id
		GROUP BY 1
			,2
			,3
		ORDER BY 2
			,4 DESC
		)

SELECT *
FROM customer_total_purchases
WHERE standing <= 1
ORDER BY 3



-- MUSIC ANALYSIS
-- Query 9 Top 10 artist by the number of songs released for the genre rock
SELECT ar.name
	,COUNT(ar.artist_id)
FROM artist ar
INNER JOIN album al
	ON ar.artist_id = al.artist_id
INNER JOIN track t
	ON t.album_id = al.album_id
INNER JOIN genre g
	ON t.genre_id = g.genre_id
WHERE g.name LIKE '%Rock%'
GROUP BY 1
ORDER BY 2 DESC LIMIT 10



-- Query 10 Best Selling artist based on total money spent on them by all the customers
SELECT ar.name artist_name
	,SUM(il.unit_price * il.quantity)
FROM artist ar
INNER JOIN album al
	ON ar.artist_id = al.artist_id
INNER JOIN track t
	ON al.album_id = t.album_id
INNER JOIN invoice_line il
	ON t.track_id = il.track_id
GROUP BY 1
ORDER BY 2 DESC LIMIT 1

-- Queen is the best selling artist



-- QUERY 11 Most popular media type sold
SELECT m.name
	,COUNT(il.invoice_line_id)
FROM media_type m
INNER JOIN track t
	ON m.media_type_id = t.media_type_id
INNER JOIN invoice_line il
	ON t.track_id = il.track_id
GROUP BY 1
ORDER BY 2 DESC

-- MPEG audio file is the most popular media type sold.


-- QUERY 12 total number of tracks that have a song length longer than the average song length
SELECT count(*)
FROM (
	SELECT name
		,milliseconds
	FROM track
	WHERE milliseconds > (
			SELECT AVG(milliseconds)
			FROM track
			)
	ORDER BY 2 DESC
	) t1
	
	
	
	-- QUERY 13 Which artist had the most money spent on him by a single customer on him and how much
WITH t1
AS (
	SELECT (c.first_name || ' ' || c.last_name) AS cx
		,ar.artist_id
		,ar.name AS artist_name
		,SUM(il.quantity * il.unit_price) total_spent
	FROM customer c
	INNER JOIN invoice i
		ON c.customer_id = i.customer_id
	INNER JOIN invoice_line il
		ON il.invoice_id = i.invoice_id
	INNER JOIN track t
		ON il.track_id = t.track_id
	INNER JOIN album al
		ON t.album_id = al.album_id
	INNER JOIN artist ar
		ON ar.artist_id = al.artist_id
	GROUP BY 1
		,2
		,3
	ORDER BY 1
		,4 DESC
	)
SELECT cx
	,artist_name
	,total_spent
FROM t1
WHERE t1.total_spent = (
		SELECT MAX(total_spent)
		FROM t1
		)
-- Queen had the most amount spent on an artist, $27		
		


-- QUERY 14 Most popular Music Genre for each country by Number
WITH pop_genre AS (
		SELECT i.billing_country
			,g.name
			,COUNT(il.quantity) AS total_sales
			,ROW_NUMBER() OVER (
				PARTITION BY i.billing_country ORDER BY COUNT(il.quantity) DESC
				) AS row_no
		FROM genre g
		INNER JOIN track t
			ON g.genre_id = t.genre_id
		INNER JOIN album al
			ON al.album_id = t.album_id
		INNER JOIN invoice_line il
			ON t.track_id = il.track_id
		INNER JOIN invoice i
			ON i.invoice_id = il.invoice_id
		GROUP BY 1
			,2
		ORDER BY 1
			,3 DESC
		)

SELECT billing_country
	,name
	,total_sales
FROM pop_genre
WHERE row_no <= 1


-- INVOICE ANALYSIS
-- Query 15 Average Invoice total
SELECT AVG(i.total)
FROM invoice i
	-- QUERY 16 We want to know how many receipts have total number of songs below the average number and how many have more.
	WITH t1 AS (
		SELECT il.invoice_id
			,COUNT(il.invoice_line_id)
			,ROW_NUMBER() OVER (
				ORDER BY COUNT(il.invoice_line_id) DESC
				) AS row_no
		FROM invoice_line il
		GROUP BY 1
		)
	,t2 AS (
		SELECT il.invoice_id
			,COUNT(il.invoice_line_id)
			,CASE 
				WHEN COUNT(il.invoice_line_id) >= (
						SELECT AVG(t1.count)
						FROM t1
						)
					THEN 'Above_avg'
				ELSE 'BELOW_AVG'
				END AS COunt_category
		FROM invoice_line il
		GROUP BY 1
		ORDER BY 1
		)

SELECT count_category
	,COUNT(*)
FROM t2
GROUP BY 1

-- 325 purchases had more than average number of songs on a receipt and 289 had less than the average.



-- Average monthly change in monthly sales
SELECT AVG(monthly_change) * 100
FROM (
	SELECT month_
		,(total_monthly_sales - previous_month_) AS monthly_change
	FROM (
		SELECT DATE_TRUNC('month', i.invoice_date) AS month_
			,SUM(i.total) AS total_monthly_sales
			,LAG(SUM(i.total)) OVER (
				ORDER BY DATE_TRUNC('month', i.invoice_date)
				) AS previous_month_
		FROM invoice i
		GROUP BY 1
		ORDER BY 1
		) t1
	) t2

-- Store had on average a drop in monthly sales
SELECT AVG(annual_change)
FROM (
	SELECT year_
		,(total_annual_sales - previous_year_) AS annual_change
	FROM (
		SELECT DATE_TRUNC('year', i.invoice_date) AS year_
			,SUM(i.total) AS total_annual_sales
			,LAG(SUM(i.total)) OVER (
				ORDER BY DATE_TRUNC('year', i.invoice_date)
				) AS previous_year_
		FROM invoice i
		GROUP BY 1
		ORDER BY 1
		) t1
	) t2
	--Store saw on average a decrease in annual sales