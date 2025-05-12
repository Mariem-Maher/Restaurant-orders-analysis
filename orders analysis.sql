USE restaurant_db;

--View the menu_items table --
SELEct *
FROM menu_items ;
--write a query to find the number of items on the menu--
SELECT COUNT(menu_item_id) 
AS num_of_items
FROM menu_items ;

--What are the least items on the menu?--
SELECT TOP 1 item_name
FROM menu_items 
ORDER BY price;

--What are the  most expensive items on the menu?--
SELECT TOP 1 item_name
FROM menu_items 
ORDER BY price DESC;

--How many Italian dishes are on the menu?
SELECT COUNT(item_name) AS num_of_italian_dishes
FROM menu_items
WHERE category ='Italian';

--What are the least and most expensive Italian dishes on the menu?--
SELECT top 1 item_name
FROM menu_items
WHERE category ='Italian'
ORDER BY price ;

SELECT top 1 item_name
FROM menu_items
WHERE category ='Italian'
ORDER BY price DESC ;

--How many dishes are in each category? What is the average dish price within each category?--
SELECT category,
COUNT(item_name) AS num_of_dishes,
AVG(price) AS avg_price
FROM menu_items
GROUP BY category;

--View the order_details table. What is the date range of the table?
SELECT
MIN(order_date) AS first_order, 
MAX(order_date) AS last_order
FROM order_details;

--How many orders were made within this date range? 
SELECT 
COUNT(DISTINCT order_id) AS num_of_orders
FROM order_details;

--How many items were ordered within this date range?
SELECT 
COUNT(order_details_id)
FROM order_details;

--Which orders had the most number of items?
SELECT
order_id,
COUNT(item_id) AS num_of_items
FROM order_details
GROUP BY order_id
ORDER BY num_of_items DESC;

--How many orders had more than 12 items?
SELECT 
COUNT(*) AS num_orders
FROM(SELECT 
order_id,
COUNT(item_id) AS num_of_items
FROM order_details
GROUP BY order_id
HAVING COUNT(item_id)>12) AS num_orders;

--Combine the menu_items and order_details tables into a single table
SELECT *
FROM order_details
JOIN menu_items
ON menu_item_id = item_id;

--What were the least and most ordered items? What categories were they in?
SELECT  top 1
item_name ,
COUNT(item_name) AS times ,
category
FROM order_details
JOIN menu_items
ON menu_item_id = item_id
GROUP BY item_name , category
ORDER BY times;

SELECT  top 1 
item_name ,
COUNT(item_name) AS times ,
category
FROM order_details
JOIN menu_items
ON menu_item_id = item_id
GROUP BY item_name , category
ORDER BY times DESC;

--What were the top 5 orders that spent the most money?
SELECT TOP 5 order_id ,SUM(price) AS total_price
FROM order_details
JOIN menu_items
ON menu_item_id = item_id
GROUP BY order_id
ORDER BY total_price DESC;

--View the details of the highest spend order. Which specific items were purchased?
SELECT top 1 order_id,SUM(price) AS total_price
FROM order_details
JOIN menu_items
ON menu_item_id = item_id
GROUP BY order_id 
ORDER BY total_price DESC
;
SELECT * FROM order_details
JOIN menu_items
ON menu_item_id = item_id
WHERE order_id = (SELECT  top 1 order_id 
FROM order_details
JOIN menu_items
ON menu_item_id = item_id 
GROUP BY order_id 
ORDER BY SUM(price) DESC)
;

-- View the details of the top 5 highest spend orders

SELECT * FROM order_details
JOIN menu_items
ON menu_item_id = item_id
WHERE order_id IN (SELECT  top 5 order_id 
FROM order_details
JOIN menu_items
ON menu_item_id = item_id 
GROUP BY order_id 
ORDER BY SUM(price) DESC)