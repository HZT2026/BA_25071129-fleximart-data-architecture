-- =========================================================
-- Task 3.2: Star Schema Data Population
-- Database: fleximart_dw
-- =========================================================

-- -----------------------------
-- DIMENSION: DATE (30 records)
-- January–February 2024
-- -----------------------------
INSERT INTO dim_date (date_key, full_date, day_of_week, day_of_month, month, month_name, quarter, year, is_weekend) VALUES
(20240101,'2024-01-01','Monday',1,1,'January','Q1',2024,FALSE),
(20240102,'2024-01-02','Tuesday',2,1,'January','Q1',2024,FALSE),
(20240103,'2024-01-03','Wednesday',3,1,'January','Q1',2024,FALSE),
(20240104,'2024-01-04','Thursday',4,1,'January','Q1',2024,FALSE),
(20240105,'2024-01-05','Friday',5,1,'January','Q1',2024,FALSE),
(20240106,'2024-01-06','Saturday',6,1,'January','Q1',2024,TRUE),
(20240107,'2024-01-07','Sunday',7,1,'January','Q1',2024,TRUE),
(20240108,'2024-01-08','Monday',8,1,'January','Q1',2024,FALSE),
(20240109,'2024-01-09','Tuesday',9,1,'January','Q1',2024,FALSE),
(20240110,'2024-01-10','Wednesday',10,1,'January','Q1',2024,FALSE),
(20240111,'2024-01-11','Thursday',11,1,'January','Q1',2024,FALSE),
(20240112,'2024-01-12','Friday',12,1,'January','Q1',2024,FALSE),
(20240113,'2024-01-13','Saturday',13,1,'January','Q1',2024,TRUE),
(20240114,'2024-01-14','Sunday',14,1,'January','Q1',2024,TRUE),
(20240115,'2024-01-15','Monday',15,1,'January','Q1',2024,FALSE),
(20240201,'2024-02-01','Thursday',1,2,'February','Q1',2024,FALSE),
(20240202,'2024-02-02','Friday',2,2,'February','Q1',2024,FALSE),
(20240203,'2024-02-03','Saturday',3,2,'February','Q1',2024,TRUE),
(20240204,'2024-02-04','Sunday',4,2,'February','Q1',2024,TRUE),
(20240205,'2024-02-05','Monday',5,2,'February','Q1',2024,FALSE),
(20240206,'2024-02-06','Tuesday',6,2,'February','Q1',2024,FALSE),
(20240207,'2024-02-07','Wednesday',7,2,'February','Q1',2024,FALSE),
(20240208,'2024-02-08','Thursday',8,2,'February','Q1',2024,FALSE),
(20240209,'2024-02-09','Friday',9,2,'February','Q1',2024,FALSE),
(20240210,'2024-02-10','Saturday',10,2,'February','Q1',2024,TRUE),
(20240211,'2024-02-11','Sunday',11,2,'February','Q1',2024,TRUE),
(20240212,'2024-02-12','Monday',12,2,'February','Q1',2024,FALSE),
(20240213,'2024-02-13','Tuesday',13,2,'February','Q1',2024,FALSE),
(20240214,'2024-02-14','Wednesday',14,2,'February','Q1',2024,FALSE),
(20240215,'2024-02-15','Thursday',15,2,'February','Q1',2024,FALSE);

-- -----------------------------
-- DIMENSION: PRODUCT (15 records)
-- 3 categories
-- -----------------------------
INSERT INTO dim_product (product_key, product_id, product_name, category, subcategory, unit_price) VALUES
(1,'P001','Laptop Pro','Electronics','Computers',75000),
(2,'P002','Smartphone X','Electronics','Mobiles',45000),
(3,'P003','Wireless Earbuds','Electronics','Accessories',8000),
(4,'P004','Running Shoes','Fashion','Footwear',6000),
(5,'P005','Denim Jacket','Fashion','Clothing',4500),
(6,'P006','Sports Watch','Fashion','Accessories',12000),
(7,'P007','Office Chair','Furniture','Seating',15000),
(8,'P008','Study Table','Furniture','Tables',18000),
(9,'P009','Bookshelf','Furniture','Storage',10000),
(10,'P010','Gaming Mouse','Electronics','Accessories',3500),
(11,'P011','Bluetooth Speaker','Electronics','Audio',9000),
(12,'P012','T-Shirt','Fashion','Clothing',1500),
(13,'P013','Sofa Set','Furniture','Seating',55000),
(14,'P014','Smart TV','Electronics','TV',65000),
(15,'P015','Winter Coat','Fashion','Clothing',8000);

-- -----------------------------
-- DIMENSION: CUSTOMER (12 records)
-- 4 cities
-- -----------------------------
INSERT INTO dim_customer (customer_key, customer_id, customer_name, city, state, customer_segment) VALUES
(1,'C001','Rahul Sharma','Mumbai','Maharashtra','Regular'),
(2,'C002','Anita Verma','Delhi','Delhi','Premium'),
(3,'C003','Karan Mehta','Bangalore','Karnataka','Regular'),
(4,'C004','Sneha Iyer','Chennai','Tamil Nadu','Premium'),
(5,'C005','Amit Singh','Mumbai','Maharashtra','Regular'),
(6,'C006','Neha Kapoor','Delhi','Delhi','Regular'),
(7,'C007','Rohit Jain','Bangalore','Karnataka','Premium'),
(8,'C008','Pooja Nair','Chennai','Tamil Nadu','Regular'),
(9,'C009','Suresh Kumar','Mumbai','Maharashtra','Regular'),
(10,'C010','Divya Malhotra','Delhi','Delhi','Premium'),
(11,'C011','Arjun Patel','Bangalore','Karnataka','Regular'),
(12,'C012','Meera Das','Chennai','Tamil Nadu','Premium');

-- -----------------------------
-- FACT: SALES (40 records)
-- -----------------------------
INSERT INTO fact_sales (sale_key, date_key, product_key, customer_key, quantity_sold, unit_price, discount_amount, total_amount) VALUES
(1,20240101,1,1,1,75000,5000,70000),
(2,20240102,2,2,1,45000,3000,42000),
(3,20240103,3,3,2,8000,0,16000),
(4,20240104,4,4,1,6000,500,5500),
(5,20240105,5,5,2,4500,500,8500),
(6,20240106,6,6,1,12000,1000,11000),
(7,20240107,7,7,1,15000,0,15000),
(8,20240108,8,8,1,18000,2000,16000),
(9,20240109,9,9,1,10000,500,9500),
(10,20240110,10,10,2,3500,0,7000),
(11,20240111,11,11,1,9000,1000,8000),
(12,20240112,12,12,3,1500,0,4500),
(13,20240113,13,1,1,55000,5000,50000),
(14,20240114,14,2,1,65000,5000,60000),
(15,20240115,15,3,1,8000,500,7500),
(16,20240201,1,4,1,75000,7000,68000),
(17,20240202,2,5,2,45000,5000,85000),
(18,20240203,3,6,1,8000,0,8000),
(19,20240204,4,7,2,6000,500,11500),
(20,20240205,5,8,1,4500,0,4500),
(21,20240206,6,9,1,12000,1000,11000),
(22,20240207,7,10,1,15000,2000,13000),
(23,20240208,8,11,1,18000,3000,15000),
(24,20240209,9,12,1,10000,500,9500),
(25,20240210,10,1,1,3500,0,3500),
(26,20240211,11,2,1,9000,1000,8000),
(27,20240212,12,3,2,1500,0,3000),
(28,20240213,13,4,1,55000,5000,50000),
(29,20240214,14,5,1,65000,6000,59000),
(30,20240215,15,6,1,8000,500,7500),
(31,20240101,3,7,1,8000,0,8000),
(32,20240102,6,8,1,12000,1000,11000),
(33,20240103,9,9,1,10000,0,10000),
(34,20240104,12,10,2,1500,0,3000),
(35,20240105,4,11,1,6000,500,5500),
(36,20240106,8,12,1,18000,2000,16000),
(37,20240107,1,2,1,75000,5000,70000),
(38,20240108,2,3,1,45000,3000,42000),
(39,20240109,14,4,1,65000,5000,60000),
(40,20240110,7,5,1,15000,0,15000);
