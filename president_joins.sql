-- DDL Statements to set up the DATABASE 

-- Create a customer table

CREATE TABLE IF NOT EXISTS customer(
	customer_id SERIAL PRIMARY KEY,
	first_name VARCHAR(50),
	last_name VARCHAR(50),
	email VARCHAR(50),
	address VARCHAR(50),
	city VARCHAR(50),
	state VARCHAR(50)
);

SELECT *
FROM customer;

-- Create a receipt table
CREATE TABLE IF NOT EXISTS receipt(
	receipt_id SERIAL PRIMARY KEY,
	receipt_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	amount NUMERIC(5,2), -- Max 5 total digits, 2 TO the RIGHT OF the decimal (XXX.XX)
	customer_id INTEGER, -- CAN BE NULL!
	FOREIGN KEY(customer_id) REFERENCES customer(customer_id)
);


SELECT *
FROM receipt;


-- DML Statements to add data to our tables

-- Inserting customers into the customer table
INSERT INTO customer(first_name, last_name, email, address, city, state)
VALUES('George', 'Washington', 'firstpres@usa.gov', '3200 Mt. Vernon Way', 'Mt. Vernon', 'VA'),
('John', 'Adams', 'jadams@whitehouse.org', '1234 W Presidential Place', 'Quincy', 'MA'),
('Thomas', 'Jefferson', 'iwrotethedeclaration@freeamerica.org', '555 Independence Drive', 'Charleston', 'VA'),
('James', 'Madison', 'fatherofconstitution@prez.io', '8345 E Eastern Ave', 'Richmond', 'VA'),
('James', 'Monroe', 'jmonroe@usa.gov', '3682 N Monroe Parkway', 'Chicago', 'IL');

SELECT *
FROM customer;


-- Add some receipts (one at a time so we have different receipt_dates)
INSERT INTO receipt (amount, customer_id)
VALUES (55.55, 1);

INSERT INTO receipt (amount, customer_id)
VALUES (78.32, 3);

INSERT INTO receipt (amount, customer_id)
VALUES (234.56, 1);

INSERT INTO receipt (amount, customer_id)
VALUES (111.22, 2);

INSERT INTO receipt (amount, customer_id)
VALUES (99.99, null);

INSERT INTO receipt (amount, customer_id)
VALUES (543.21, null);

SELECT *
FROM receipt;



SELECT *
FROM customer 
WHERE customer_id = 1;

SELECT *
FROM receipt
WHERE customer_id = 1;

-- using JOINs we can combine these tables on a common field
-- Syntax:
-- SELECT col_1, col_2, etc. (can be from either table)
-- FROM table_name_1 (will be considered the LEFT table)
-- JOIN table_name_2 (will be considered the RIGHT table)
-- ON table_name_1.col_name = table_name_2.col_name (where col_name is FK to other col_name)

-- Inner Join

SELECT first_name, last_name, email, c.customer_id AS cust_cust_id, r.customer_id AS rec_cust_id, receipt_date, amount
FROM customer c
JOIN receipt r
ON c.customer_id = r.customer_id;

-- Each Join

-- JOIN or INNER JOIN - returns records that have matching values in both tables
SELECT *
FROM customer
JOIN receipt 
ON customer.customer_id = receipt.customer_id;

SELECT *
FROM customer;

SELECT *
FROM receipt;


-- FULL JOIN -- Returns all records when there is a match in either left or right table
SELECT *
FROM customer
FULL JOIN receipt 
ON customer.customer_id = receipt.customer_id;


-- LEFT JOIN - Returns all records from the left table, and the matched records from the right table
SELECT *
FROM customer -- LEFT table
LEFT JOIN receipt  -- RIGHT table
ON customer.customer_id = receipt.customer_id;

-- RIGHT JOIN - Returns all records from the right table, and the matched records from the left table
SELECT *
FROM customer -- LEFT table
RIGHT JOIN receipt  -- RIGHT table
ON customer.customer_id = receipt.customer_id;

-- RIGHT JOIN again *flip-flop right and left table*
SELECT *
FROM receipt -- LEFT table
RIGHT JOIN customer  -- RIGHT table
ON customer.customer_id = receipt.customer_id;


-- JOIN...ON comes after the SELECT FROM and before the WHERE 

--SELECT 
--FROM 
--JOIN
--ON 
--WHERE 
--GROUP BY 
--HAVING 
--ORDER BY 
--LIMIT 
--OFFSET

SELECT *
FROM customer 
JOIN receipt 
ON customer.customer_id = receipt.customer_id 
WHERE last_name = 'Washington';

SELECT first_name, last_name, SUM(amount), COUNT(amount)
FROM customer
JOIN receipt 
ON customer.customer_id = receipt.customer_id 
GROUP BY first_name, last_name
HAVING COUNT(amount) = 1; 


SELECT *
FROM receipt;


-- Aliasing table names 

CREATE TABLE teacher (
	teacher_id SERIAL PRIMARY KEY,
	first_name VARCHAR,
	last_name VARCHAR
);

INSERT INTO teacher(first_name, last_name) VALUES ('Bob', 'Bobbertson'), ('Frank', 'Franklinson');
SELECT * FROM teacher;

CREATE TABLE student (
	student_id SERIAL PRIMARY KEY,
	first_name VARCHAR,
	last_name VARCHAR,
	teacher_id INTEGER NOT NULL,
	FOREIGN KEY(teacher_id) REFERENCES teacher(teacher_id)
);


INSERT INTO student (first_name, last_name, teacher_id)
VALUES ('Mickey', 'Mouse', 1),
('Minnie', 'Mouse', 2),
('Donald', 'Duck', 1),
('Daffy', 'Duck', 2);

SELECT * FROM student;


SELECT teacher.first_name, teacher.last_name, student.first_name, student.last_name
FROM teacher 
JOIN student 
ON teacher.teacher_id = student.teacher_id;


-- Alias the table names and then you MUST reference the table by its alias 
SELECT t.first_name, t.last_name, s.first_name, s.last_name
FROM teacher t
JOIN student s
ON t.teacher_id = s.teacher_id;


SELECT *
FROM teacher;