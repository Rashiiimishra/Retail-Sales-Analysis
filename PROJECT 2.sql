-- DROP TABLE command
DROP TABLE IF EXISTS warranty;
DROP TABLE IF EXISTS sales;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS category;
DROP TABLE IF EXISTS stores;

-- CREATE TABLE commands

CREATE TABLE stores(
store_id VARCHAR(5) PRIMARY KEY,
store_name	VARCHAR(30),
city	VARCHAR(25),
country VARCHAR(25)
);

DROP TABLE IF EXISTS category;
CREATE TABLE category
(category_id VARCHAR(10) PRIMARY KEY,
category_name VARCHAR(20)
);

CREATE TABLE products
(
product_id	VARCHAR(10) PRIMARY KEY,
product_name	VARCHAR(35),
category_id	VARCHAR(10),
launch_date	date,
price FLOAT,
CONSTRAINT fk_category FOREIGN KEY (category_id) REFERENCES category(category_id)
);

CREATE TABLE sales
(
sale_id	VARCHAR(15) PRIMARY KEY,
sale_date	DATE,
store_id	VARCHAR(10), -- this fk
product_id	VARCHAR(10), -- this fk
quantity INT,
CONSTRAINT fk_store FOREIGN KEY (store_id) REFERENCES stores(store_id),
CONSTRAINT fk_product FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE warranty
(
claim_id VARCHAR(10) PRIMARY KEY,	
claim_date	date,
sale_id	VARCHAR(15),
repair_status VARCHAR(15),
CONSTRAINT fk_orders FOREIGN KEY (sale_id) REFERENCES sales(sale_id)
);

-- Success Message
SELECT 'Schema created successful' as Success_Message;

SELECT * FROM category;
SELECT * FROM products;
SELECT * FROM stores;
SELECT * FROM sales;
SELECT * FROM warranty;

-- EDA
SELECT DISTINCT repair_status 
FROM warranty;
SELECT COUNT(*) 
FROM sales;

SELECT * FROM sales
WHERE product_id ='P-44'

CREATE INDEX sales_product_id ON sales(product_id);
CREATE INDEX sales_store_id ON sales(store_id);
CREATE INDEX sales_sale_date ON sales(sale_date);

SELECT * FROM sales
WHERE store_id ='ST-31'

-- 1. Find the number of stores in each country.

SELECT 
	country,
	COUNT(store_id) as total_stores
FROM stores
GROUP BY 1
ORDER BY 2 DESC

-- Q.2 Calculate the total number of units sold by each store.

SELECT 
	s.store_id,
	st.store_name,
	SUM(s.quantity) as total_unit_sold
FROM sales as s
JOIN
stores as st
ON st.store_id = s.store_id
GROUP BY 1, 2
ORDER BY 3 DESC

-- Q.3 Identify how many sales occurred in December 2023.


SELECT 
	COUNT(sale_id) as total_sale 
FROM sales
WHERE TO_CHAR(sale_date, 'MM-YYYY') = '12-2023'

-- Q.4 Determine how many stores have never had a warranty claim filed.

SELECT COUNT(*) FROM stores
WHERE store_id NOT IN (
						SELECT 
							DISTINCT store_id
						FROM sales as s
						RIGHT JOIN warranty as w
						ON s.sale_id = w.sale_id
						);

-- Q.5 Calculate the percentage of warranty claims marked as "Warranty Void".
no claim that as wv/total claim * 100

SELECT 
	ROUND
		(COUNT(claim_id)/
						(SELECT COUNT(*) FROM warranty)::numeric * 100, 2)as warranty_void_percentage
FROM warranty
WHERE repair_status = 'Warranty Void'

-- Q.6 Identify which store had the highest total units sold in the last year.

SELECT 
	s.store_id,
	st.store_name,
	SUM(s.quantity)
FROM sales as s
JOIN stores as st
ON s.store_id = st.store_id
WHERE sale_date >= (CURRENT_DATE - INTERVAL '1 year')
GROUP BY 1, 2
ORDER BY 3 DESC
LIMIT 1

-- Q.7 Count the number of unique products sold in the last year.

SELECT 
	COUNT(DISTINCT product_id)
FROM sales
WHERE sale_date >= (CURRENT_DATE - INTERVAL '1 year')

-- Q.8 Find the average price of products in each category.

SELECT 
	p.category_id,
	c.category_name,
	AVG(p.price) as avg_price
FROM products as p
JOIN 
category as c
ON p.category_id = c.category_id
GROUP BY 1, 2
ORDER BY 3 DESC

-- Q.9 How many warranty claims were filed in 2020?

SELECT 
	COUNT(*) as warranty_claim
FROM warranty
WHERE EXTRACT(YEAR FROM claim_date) = 2020

-- Q.10 For each store, identify the best-selling day based on highest quantity sold.

-- store_id, day_name, sum(qty)
--  window dense rank 


SELECT  * 
FROM
(
	SELECT 
		store_id,
		TO_CHAR(sale_date, 'Day') as day_name,
		SUM(quantity) as total_unit_sold,
		RANK() OVER(PARTITION BY store_id ORDER BY SUM(quantity) DESC) as rank
	FROM sales
	GROUP BY 1, 2
) as t1
WHERE rank = 1

-- Q.11 Identify the least selling product in each country for each year based on total units sold.


WITH product_rank
AS
(
SELECT 
	st.country,
	p.product_name,
	SUM(s.quantity) as total_qty_sold,
	RANK() OVER(PARTITION BY st.country ORDER BY SUM(s.quantity)) as rank
FROM sales as s
JOIN 
stores as st
ON s.store_id = st.store_id
JOIN
products as p
ON s.product_id = p.product_id
GROUP BY 1, 2
)
SELECT 
* 
FROM product_rank
WHERE rank = 1

-- Q.12 Calculate how many warranty claims were filed within 180 days of a product sale.

SELECT 
	COUNT(*)
FROM warranty as w
LEFT JOIN 
sales as s
ON s.sale_id = w.sale_id
WHERE 
	w.claim_date - sale_date <= 180

--Q.13  Determine how many warranty claims were filed for products launched in the last two years.
-- each prod 
--  no claim
--  no sale
-- each must be launcnhed in last 2 year

SELECT 
	p.product_name,
	COUNT(w.claim_id) as no_claim,
	COUNT(s.sale_id)
FROM warranty as w
RIGHT JOIN
sales as s 
ON s.sale_id = w.sale_id
JOIN products as p
ON p.product_id = s.product_id
WHERE p.launch_date >= CURRENT_DATE - INTERVAL '2 years'
GROUP BY 1
HAVING COUNT(w.claim_id) > 0

-- Q.14 List the months in the last three years where sales exceeded 5,000 units in the USA.

SELECT 
	TO_CHAR(sale_date, 'MM-YYYY') as month,
	SUM(s.quantity) as total_unit_sold
FROM sales as s
JOIN 
stores as st
ON s.store_id = st.store_id
WHERE 
	st.country = 'USA'
	AND
	s.sale_date >= CURRENT_DATE - INTERVAL '3 year'
GROUP BY 1
HAVING SUM(s.quantity) > 5000

---END OF PROJECT---