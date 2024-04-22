-- Active: 1713367857756@@127.0.0.1@3306@airbnb
USE airbnb;


-- Select all data from the table
SELECT * FROM airbnb.host;


-- Select all columns where host_is_superhost is true
SELECT * FROM airbnb.host WHERE host_is_superhost = 1;

-- Select listing name, price, property type where review_scores_rating in review table is greater than 4.8
SELECT 
    l.name, 
    l.price, 
    l.property_type
FROM airbnb.listing l
JOIN airbnb.review r 
    ON l.id = r.listing_id
WHERE r.review_scores_rating > 4.8;


-- Filter data using WHERE clause
SELECT * FROM employees WHERE age > 30;

-- Sort data using ORDER BY clause
SELECT * FROM employees ORDER BY salary DESC;

-- Calculate the average salary
SELECT AVG(salary) AS average_salary FROM employees;

-- Count the number of employees
SELECT COUNT(*) AS total_employees FROM employees;

-- Group data using GROUP BY clause
SELECT age, COUNT(*) AS count FROM employees GROUP BY age;

-- Join two tables
SELECT e.name, d.department_name
FROM employees e
JOIN departments d ON e.department_id = d.id;













#SELECT
#Select all columns from payments.
USE sql_invoicing;
SELECT * FROM payments;

#SELECT
#Select all columns from offices.
SELECT * FROM sql_hr.offices;

#WHERE
#Select all columns from products where quantity in stock is greater than 50.
SELECT * FROM sql_store.products
WHERE quantity_in_stock > 70;

#WHERE
#Select all columns from orders where customer id is 2.
USE sql_store;
SELECT * FROM orders
WHERE customer_id = 2;

#ORDER BY
#Select all columns from order_items where quantity greater than 5 and order by unit price from high to low.
SELECT * FROM sql_store.order_items
WHERE quantity > 5
ORDER BY unit_price DESC;

#AND, OR, and NOT Operators
#Select all columns from customers where the customer has more than 1200 points or if the customer is born after 1990-01-01 and from Florida.
SELECT * FROM sql_store.customers
WHERE points >= '1200' OR
    (birth_date > '1990-01-01' AND state = 'FL');

#Select all columns from products where the quantity in stock is smaller than 50 and unit price times question is smaller than 100.
SELECT * FROM sql_store.products
WHERE quantity_in_stock < 50 AND unit_price*quantity_in_stock < 100;


#IN
#Select all columns from order_items where the product id is not 2, 3, 4.
SELECT * FROM sql_store.order_items
WHERE product_id NOT IN (2, 3, 4);

#Select all columns from order_items where quantity is 2, 4, 5.
SELECT * FROM sql_store.order_items
WHERE quantity IN (2, 4, 5);

#Select all columns from customers where last name ends with y.
USE sql_store;
SELECT * FROM customers
WHERE last_name LIKE '%y';

#Inner Join
#Join all columns from products and order_items using product_id
SELECT * FROM products
JOIN order_items
    on products.product_id = order_items.product_id;

#Inner Join using alias
#Join order and customers using customer_id and select order_id, customer_id, order_date, and shipped_date.
USE sql_store;
SELECT order_id, o.customer_id, order_date, shipped_date
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id

#Join across two databases
#Join products from sql_inventory and order_items from sql_store using product_id.
USE sql_inventory;
SELECT *
FROM sql_store.order_items oi
JOIN products p
    ON oi.product_id = p.product_id

#Join with 3 tables
#Join products and order_items using product_id and join order_item_notes using order_id.
USE sql_store;
SELECT *
FROM products p
JOIN order_items oi
    ON p.product_id = oi.product_id
JOIN order_item_notes oin
    ON oi.order_id = oin.order_id

#Join with the table itself
#Join offices with itself using office_id.
USE sql_hr;
SELECT 
    o.office_id,
    o.address,
    f.city
FROM offices o
JOIN offices f
    ON o.office_id = f.office_id;

#Join with two conditions
USE sql_store;
SELECT *
FROM order_items oi
JOIN order_item_notes oin
    ON oi.order_id = oin.order_id
    AND oi.product_id = oin.product_id;

#Right outer join product with order items.
USE sql_store;
SELECT
    p.product_id,
    p.name,
    oi.order_id
FROM products p
RIGHT JOIN order_items oi 
    ON p.product_id = oi.product_id
ORDER BY p.product_id


#Left outer join
SELECT
    p.product_id,
    p.name,
    oi.order_id
FROM products p
LEFT JOIN order_items oi 
    ON p.product_id = oi.product_id
ORDER BY p.product_id

#Using
SELECT 
    p.product_id,
    oi.order_id
FROM products p
JOIN order_items oi
    USING (product_id)

#Using
USE sql_invoicing;
SELECT *
FROM clients c 
JOIN invoices i 
    USING (client_id);

#Insert the fifth payment method to payment_methods 
USE sql_invoicing;
INSERT INTO payment_methods (payment_method_id, name)
VAlues (5, 'check')

#Update a single row
#Update the phone number for client with client_id = 1
USE sql_invoicing;
UPDATE clients
SET phone = '123-456-7890'
WHERE client_id = 1


#Update multiple rows
#Update unit price for products with in stock quantity less than 20.
USE sql_inventory;
UPDATE products
SET unit_price = unit_price + 10
WHERE quantity_in_stock < 20;

#Update multiple rows
#Update payment total and payment date for any row with null payment date.
USE sql_invoicing;
UPDATE invoices
SET payment_total = invoice_total - 50,
    payment_date = due_date
WHERE payment_date IS NULL;

#Increase unite price by 20 for products with product_id 1, 2, 4.
USE sql_store;
UPDATE products
SET unit_price = unit_price + 20
WHERE product_id IN (1, 2, 4);

#Subqueries
#Change payment total to 70% of invoice total for client Yadel.
USE sql_invoicing;
UPDATE invoices
SET 
    payment_total = invoice_total * 0.7,
    payment_date = due_date
WHERE client_id = 
    (SELECT client_id
    From clients
    WHERE name = 'Yadel')


#Subquery
#Change payment total to 80% of invoice total for clients with names Vinte, Kwideo, and Topiclounge.
UPDATE invoices
SET 
    payment_total = invoice_total * 0.8,
    payment_date = due_date
WHERE client_id IN 
    (SELECT client_id
    FROM clients
    WHERE name IN ('Vinte', 'Kwideo', 'Topiclounge'));

#Delete rows
#Delete the row with employee_id 33391
USE sql_hr;
DELETE FROM employees
WHERE employee_id = 56274;