-- E-Commerce Order Management System
===============================================================================

CREATE DATABASE IF NOT EXISTS ecommerce_management;
USE ecommerce_management;

===============================================================================
-- 1. Create tables with primary and foreign key relationships
DROP TABLE IF EXISTS Shipping;
DROP TABLE IF EXISTS Payments;
DROP TABLE IF EXISTS Order_Items;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Products;
DROP TABLE IF EXISTS Customers;
DROP TABLE IF EXISTS Categories;

CREATE TABLE Categories (
    category_id INT PRIMARY KEY AUTO_INCREMENT,
    category_name VARCHAR(100) NOT NULL
);

CREATE TABLE Products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(150) NOT NULL,
    category_id INT,
    price DECIMAL(10,2) NOT NULL,
    stock_quantity INT NOT NULL DEFAULT 0,
    added_date DATE,
    sold_units INT NOT NULL DEFAULT 0,
    FOREIGN KEY (category_id) REFERENCES Categories(category_id)
);

CREATE TABLE Customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(150) NOT NULL,
    email VARCHAR(150),
    phone_number VARCHAR(20),
    address VARCHAR(255),
    registration_date DATE
);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    status ENUM('Pending','Shipped','Delivered','Cancelled') DEFAULT 'Pending',
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

CREATE TABLE Order_Items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);

CREATE TABLE Payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    payment_date DATE,
    payment_method ENUM('Credit Card','PayPal','UPI'),
    payment_status ENUM('Paid','Pending','Failed') DEFAULT 'Pending',
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);

CREATE TABLE Shipping (
    shipping_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    shipping_date DATE,
    delivery_date DATE,
    shipping_status ENUM('Dispatched','In Transit','Delivered') DEFAULT 'Dispatched',
    FOREIGN KEY (order_id) REFERENCES Orders(order_id)
);


-- Sample data for running and testing the required queries
INSERT INTO Categories (category_name) VALUES
('Mobiles'), ('Laptops'), ('Accessories'), ('Televisions');

INSERT INTO Products (name, category_id, price, stock_quantity, added_date, sold_units) VALUES
('Smartphone A', 1, 18000, 25, '2025-01-10', 620),
('Laptop Pro', 2, 65000, 8, '2025-02-15', 350),
('Wireless Mouse', 3, 800, 0, '2025-03-05', 240),
('LED Television', 4, 42000, 12, '2025-04-20', 520),
('USB Cable', 3, 250, 100, '2025-05-12', 120),
('Budget Phone', 1, 9500, 15, '2025-06-08', 180);

INSERT INTO Customers (name, email, phone_number, address, registration_date) VALUES
('Aarav Sharma', 'aarav@example.com', '9876500001', 'Ahmedabad', '2021-05-10'),
('Priya Patel', 'priya@example.com', '9876500002', 'Surat', '2023-02-18'),
('Rahul Verma', NULL, '9876500003', 'Vadodara', '2024-07-12'),
('Neha Singh', 'neha@example.com', '9876500004', 'Rajkot', '2022-11-25'),
('Kabir Shah', 'kabir@example.com', '9876500005', 'Ahmedabad', '2025-01-09'),
('Isha Mehta', 'isha@example.com', '9876500006', 'Gandhinagar', '2020-08-01');

INSERT INTO Orders (customer_id, order_date, total_amount, status) VALUES
(1, DATE_SUB(CURDATE(), INTERVAL 20 DAY), 18800, 'Delivered'),
(2, DATE_SUB(CURDATE(), INTERVAL 45 DAY), 65000, 'Shipped'),
(1, DATE_SUB(CURDATE(), INTERVAL 80 DAY), 42000, 'Delivered'),
(3, DATE_SUB(CURDATE(), INTERVAL 130 DAY), 9500, 'Pending'),
(4, DATE_SUB(CURDATE(), INTERVAL 200 DAY), 18000, 'Cancelled'),
(5, DATE_SUB(CURDATE(), INTERVAL 15 DAY), 42000, 'Delivered'),
(2, DATE_SUB(CURDATE(), INTERVAL 300 DAY), 1050, 'Delivered'),
(6, DATE_SUB(CURDATE(), INTERVAL 400 DAY), 65000, 'Delivered');

INSERT INTO Order_Items (order_id, product_id, quantity, subtotal) VALUES
(1, 1, 1, 18000), (1, 3, 1, 800),
(2, 2, 1, 65000),
(3, 4, 1, 42000),
(4, 6, 1, 9500),
(5, 1, 1, 18000),
(6, 4, 1, 42000),
(7, 3, 1, 800), (7, 5, 1, 250),
(8, 2, 1, 65000);

INSERT INTO Payments (order_id, payment_date, payment_method, payment_status) VALUES
(1, CURDATE(), 'UPI', 'Paid'),
(2, CURDATE(), 'Credit Card', 'Paid'),
(3, CURDATE(), 'PayPal', 'Paid'),
(4, CURDATE(), 'UPI', 'Pending'),
(5, CURDATE(), 'Credit Card', 'Failed'),
(6, CURDATE(), 'UPI', 'Paid'),
(7, CURDATE(), 'PayPal', 'Paid'),
(8, CURDATE(), 'Credit Card', 'Paid');

INSERT INTO Shipping (order_id, shipping_date, delivery_date, shipping_status) VALUES
(1, DATE_SUB(CURDATE(), INTERVAL 19 DAY), DATE_SUB(CURDATE(), INTERVAL 17 DAY), 'Delivered'),
(2, DATE_SUB(CURDATE(), INTERVAL 44 DAY), NULL, 'In Transit'),
(3, DATE_SUB(CURDATE(), INTERVAL 79 DAY), DATE_SUB(CURDATE(), INTERVAL 76 DAY), 'Delivered'),
(6, DATE_SUB(CURDATE(), INTERVAL 14 DAY), DATE_SUB(CURDATE(), INTERVAL 12 DAY), 'Delivered');

=========================================================================================================
-- 2. CRUD operations
-- Insert a sample product
INSERT INTO Products (name, category_id, price, stock_quantity, added_date, sold_units)
VALUES ('Bluetooth Speaker', 3, 2200, 30, CURDATE(), 0);


-- Update stock when an order is placed (example)
UPDATE Products
SET stock_quantity = stock_quantity - 1
WHERE product_id = 1 AND stock_quantity >= 1;


-- Delete cancelled orders older than 30 days
DELETE FROM Orders
WHERE status = 'Cancelled'
  AND order_date < DATE_SUB(CURDATE(), INTERVAL 30 DAY);

=========================================================================================================
-- 3. WHERE, HAVING and LIMIT
-- Orders placed in the last 6 months
SELECT * FROM Orders
WHERE order_date >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH);


-- Top 5 highest-priced products
SELECT * FROM Products
ORDER BY price DESC
LIMIT 5;



-- Customers who have placed more than 3 orders
SELECT c.customer_id, c.name, COUNT(o.order_id) AS order_count
FROM Customers c
JOIN Orders o ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.name
HAVING COUNT(o.order_id) > 3;

=========================================================================================================
-- 4. SQL operators: AND, OR, NOT
-- Pending orders whose payment is paid
SELECT o.order_id, o.customer_id, o.order_date, o.total_amount, o.status
FROM Orders o
JOIN Payments p ON p.order_id = o.order_id
WHERE o.status = 'Pending' AND p.payment_status = 'Paid';


-- Products that are not out of stock
SELECT * FROM Products
WHERE NOT stock_quantity = 0;


-- Customers registered after 2022 OR with purchases above Rs. 10,000
SELECT DISTINCT c.customer_id, c.name, c.registration_date
FROM Customers c
LEFT JOIN Orders o ON o.customer_id = c.customer_id
WHERE c.registration_date >= '2023-01-01'
   OR o.total_amount > 10000;

=========================================================================================================
-- 5. Sorting and grouping
-- Products sorted by price descending
SELECT * FROM Products ORDER BY price DESC;


-- Number of orders placed by each customer
SELECT c.customer_id, c.name, COUNT(o.order_id) AS total_orders
FROM Customers c
LEFT JOIN Orders o ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.name;


-- Total revenue generated per category
SELECT cat.category_id, cat.category_name, SUM(oi.subtotal) AS category_revenue
FROM Categories cat
JOIN Products p ON p.category_id = cat.category_id
JOIN Order_Items oi ON oi.product_id = p.product_id
JOIN Orders o ON o.order_id = oi.order_id
WHERE o.status <> 'Cancelled'
GROUP BY cat.category_id, cat.category_name;

=========================================================================================================
-- 6. Aggregate functions: SUM, AVG, MAX, MIN, COUNT
-- Total revenue generated by the store
SELECT SUM(total_amount) AS total_revenue
FROM Orders
WHERE status <> 'Cancelled';

-- Most purchased product by total quantity
SELECT p.product_id, p.name, SUM(oi.quantity) AS total_quantity_sold
FROM Products p
JOIN Order_Items oi ON oi.product_id = p.product_id
JOIN Orders o ON o.order_id = oi.order_id
WHERE o.status <> 'Cancelled'
GROUP BY p.product_id, p.name
ORDER BY total_quantity_sold DESC
LIMIT 1;

-- Average order value
SELECT AVG(total_amount) AS average_order_value
FROM Orders
WHERE status <> 'Cancelled';

=========================================================================================================
-- 7. Primary and foreign key relationships are defined in CREATE TABLE statements above.

-- 8. Joins
-- INNER JOIN: products with category names
SELECT p.product_id, p.name AS product_name, cat.category_name
FROM Products p
INNER JOIN Categories cat ON cat.category_id = p.category_id;

-- LEFT JOIN: all orders with customer details
SELECT o.order_id, o.order_date, o.total_amount, o.status,
       c.customer_id, c.name AS customer_name, c.email
FROM Orders o
LEFT JOIN Customers c ON c.customer_id = o.customer_id;

-- RIGHT JOIN: orders that have not been shipped (no Shipping row)
SELECT o.order_id, o.status, s.shipping_id, s.shipping_status
FROM Shipping s
RIGHT JOIN Orders o ON o.order_id = s.order_id
WHERE s.shipping_id IS NULL;

-- FULL OUTER JOIN equivalent in MySQL: customers with and without orders
SELECT c.customer_id, c.name, o.order_id
FROM Customers c
LEFT JOIN Orders o ON o.customer_id = c.customer_id
UNION
SELECT c.customer_id, c.name, o.order_id
FROM Customers c
RIGHT JOIN Orders o ON o.customer_id = c.customer_id;

=========================================================================================================
-- 9. Subqueries
-- Orders placed by customers registered after 2022
SELECT *
FROM Orders
WHERE customer_id IN (
    SELECT customer_id FROM Customers
    WHERE registration_date >= '2023-01-01'
);

-- Customer who has spent the most (excluding cancelled orders)
SELECT c.customer_id, c.name, SUM(o.total_amount) AS total_spent
FROM Customers c
JOIN Orders o ON o.customer_id = c.customer_id
WHERE o.status <> 'Cancelled'
GROUP BY c.customer_id, c.name
HAVING SUM(o.total_amount) = (
    SELECT MAX(customer_total)
    FROM (
        SELECT SUM(total_amount) AS customer_total
        FROM Orders
        WHERE status <> 'Cancelled'
        GROUP BY customer_id
    ) AS totals
);

-- Products that have never been ordered
SELECT p.product_id, p.name
FROM Products p
WHERE NOT EXISTS (
    SELECT 1 FROM Order_Items oi
    WHERE oi.product_id = p.product_id
);

=========================================================================================================
-- 10. Date and time functions
-- Count orders per month
SELECT YEAR(order_date) AS order_year, MONTH(order_date) AS order_month,
       COUNT(*) AS order_count
FROM Orders
GROUP BY YEAR(order_date), MONTH(order_date)
ORDER BY order_year, order_month;

-- Delivery time in days
SELECT shipping_id, order_id,
       DATEDIFF(delivery_date, shipping_date) AS delivery_days
FROM Shipping
WHERE delivery_date IS NOT NULL;

-- Format order date as DD-MM-YYYY
SELECT order_id, DATE_FORMAT(order_date, '%d-%m-%Y') AS formatted_order_date
FROM Orders;

=========================================================================================================
-- 11. String manipulation functions
-- Convert product names to uppercase
SELECT product_id, UPPER(name) AS uppercase_product_name FROM Products;

-- Trim whitespace from customer names
SELECT customer_id, TRIM(name) AS trimmed_customer_name FROM Customers;

-- Replace missing email values with 'Not Provided'
SELECT customer_id, name,
       COALESCE(NULLIF(TRIM(email), ''), 'Not Provided') AS email
FROM Customers;

=========================================================================================================
-- 12. Window functions
-- Rank customers based on total spending
WITH customer_spending AS (
    SELECT c.customer_id, c.name,
           COALESCE(SUM(CASE WHEN o.status <> 'Cancelled' THEN o.total_amount ELSE 0 END), 0) AS total_spending
    FROM Customers c
    LEFT JOIN Orders o ON o.customer_id = c.customer_id
    GROUP BY c.customer_id, c.name
)
SELECT customer_id, name, total_spending,
       RANK() OVER (ORDER BY total_spending DESC) AS spending_rank
FROM customer_spending;

-- Running total of revenue per month
WITH monthly_revenue AS (
    SELECT DATE_FORMAT(order_date, '%Y-%m-01') AS order_month,
           SUM(total_amount) AS monthly_revenue
    FROM Orders
    WHERE status <> 'Cancelled'
    GROUP BY DATE_FORMAT(order_date, '%Y-%m-01')
)
SELECT order_month, monthly_revenue,
       SUM(monthly_revenue) OVER (ORDER BY order_month) AS running_total_revenue
FROM monthly_revenue;

-- Running total of orders placed (chronological order)
SELECT order_id, order_date, total_amount,
       SUM(total_amount) OVER (ORDER BY order_date, order_id) AS running_order_total
FROM Orders;

=========================================================================================================
-- 13. CASE expressions
-- Loyalty status based on total spending
WITH customer_spending AS (
    SELECT c.customer_id, c.name,
           COALESCE(SUM(CASE WHEN o.status <> 'Cancelled' THEN o.total_amount ELSE 0 END), 0) AS total_spending
    FROM Customers c
    LEFT JOIN Orders o ON o.customer_id = c.customer_id
    GROUP BY c.customer_id, c.name
)
SELECT customer_id, name, total_spending,
       CASE
           WHEN total_spending > 50000 THEN 'Gold'
           WHEN total_spending BETWEEN 20000 AND 50000 THEN 'Silver'
           ELSE 'Bronze'
       END AS Loyalty_Status
FROM customer_spending;

-- Product category based on sold units
SELECT product_id, name, sold_units,
       CASE
           WHEN sold_units > 500 THEN 'Best Seller'
           WHEN sold_units BETWEEN 200 AND 500 THEN 'Popular'
           ELSE 'Regular'
       END AS product_category
FROM Products;

=========================================================================================================