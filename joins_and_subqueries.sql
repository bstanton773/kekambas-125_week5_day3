SELECT *
FROM actor;

SELECT *
FROM film;

SELECT *
FROM film_actor;

-- Join the actor table to the film_actor table
SELECT *
FROM film_actor fa
JOIN actor a
ON a.actor_id = fa.actor_id;


-- Join the film table to the film_actor table
SELECT *
FROM film_actor fa
JOIN film f
ON fa.film_id = f.film_id ;


-- Multi Join
SELECT f.title, f.release_year, f.film_id, fa.film_id, fa.actor_id, a.actor_id, a.first_name, a.last_name
FROM film_actor fa 
JOIN film f
ON f.film_id = fa.film_id
JOIN actor a
ON fa.actor_id = a.actor_id;


-- Display customer name and film rented -- customer -> rental -> inventory -> film
SELECT c.first_name, c.last_name, c.customer_id, r.customer_id, r.rental_date, r.inventory_id, i.inventory_id, i.film_id, f.film_id, f.title 
FROM customer c
JOIN rental r
ON c.customer_id = r.customer_id 
JOIN inventory i 
ON r.inventory_id = i.inventory_id
JOIN film f
ON i.film_id = f.film_id;

-- Still do all of the other FUN DQL clauses
SELECT c.first_name, c.last_name, c.customer_id, r.customer_id, r.rental_date, r.inventory_id, i.inventory_id, i.film_id, f.film_id, f.title 
FROM customer c
JOIN rental r
ON c.customer_id = r.customer_id 
JOIN inventory i 
ON r.inventory_id = i.inventory_id
JOIN film f
ON i.film_id = f.film_id
WHERE c.last_name LIKE 'R%'
ORDER BY f.title DESC
OFFSET 10
LIMIT 20;


-- SUBQUERIES!!!
-- Subquery is a query within another query

-- Ex. Which films have exactly 12 actors in the film?

-- Step 1. Get ths IDs of the films that have exactly 12 actors
SELECT film_id, COUNT(*)
FROM film_actor
GROUP BY film_id
HAVING COUNT(*) = 12;

--film_id|
---------+
--    529|
--    802|
--     34|
--    892|
--    414|
--    517|

-- Step 2. Get the films from the film table that match those IDs
SELECT *
FROM film 
WHERE film_id IN (
	529,
	802,
	34,
	892,
	414,
	517
);

-- Put the two steps together into one query - using a Subquery!
-- The query that you want to execute FIRST is the subquery.
-- ** Subquery must return only ONE column **       *unless used in a FROM clause 
SELECT *
FROM film 
WHERE film_id IN (
	SELECT film_id
	FROM film_actor
	GROUP BY film_id
	HAVING COUNT(*) = 12
);


-- What employee sold the most rentals (use the rental table)?

SELECT *
FROM staff 
WHERE staff_id = (
	SELECT staff_id
	FROM rental
	GROUP BY staff_id
	ORDER BY COUNT(*) DESC
	LIMIT 1
);

-- Show the employee with the most rentals and the count 
SELECT first_name, last_name, COUNT(*)
FROM staff 
JOIN rental 
ON staff.staff_id = rental.staff_id
GROUP BY first_name, last_name
ORDER BY COUNT(*) DESC 
LIMIT 2;



-- Use subqueries for calculations
-- List out all of the payments that are more than the average payment amount

SELECT *
FROM payment 
WHERE amount > (
	SELECT AVG(amount)
	FROM payment
);


-- Subqueries with the FROM clause 
-- *Subquery in a FROM must have an alias*


-- Ex. Find the average number of rentals per customer

-- Step 1. Get the count of rentals for each customer

SELECT customer_id, COUNT(*) AS num_rentals
FROM rental
GROUP BY customer_id ;

-- Step 2. Use the temp table from step 1 as a subquery to query from 
SELECT AVG(num_rentals)
FROM (
	SELECT customer_id, COUNT(*) AS num_rentals
	FROM rental
	GROUP BY customer_id 
) AS customer_rental_totals;



-- Using subqueries in DML statements

-- Setup for Example - Add loyalty_member boolean column to customer table
ALTER TABLE customer
ADD COLUMN loyalty_member BOOLEAN;

-- Set all customers to be FALSE for loyalty_member
UPDATE customer
SET loyalty_member = FALSE;

SELECT *
FROM customer;

-- Update the customer table to make every customer who has at least 25 rentals a loyalty member

-- Step 1. Find all of the customer IDs that have made at least 25 rentals
SELECT customer_id, COUNT(*)
FROM rental
GROUP BY customer_id
HAVING COUNT(*) >= 25;

-- Step 2. Update the customer table to set loyalty = TRUE if customer_id in the subquery
UPDATE customer
SET loyalty_member = TRUE 
WHERE customer_id IN (
	SELECT customer_id
	FROM rental
	GROUP BY customer_id
	HAVING COUNT(*) >= 25
);

-- Confirm loyalty status
SELECT *
FROM customer
WHERE loyalty_member = TRUE;


-- Multiple subqueries in one query is totally cool

-- Get the customer info on the customer who have rented more than the average customer

SELECT *
FROM customer 
WHERE customer_id IN (
	SELECT customer_id
	FROM rental 
	GROUP BY customer_id 
	HAVING COUNT(*) > (
		SELECT AVG(num_rentals)
		FROM (
			SELECT customer_id, COUNT(*) AS num_rentals
			FROM rental
			GROUP BY customer_id 
		) AS customer_rental_totals
	)
);


-- Joins and Subqueries are friendly
SELECT c.first_name, c.last_name, COUNT(*)
FROM rental r
JOIN customer c
ON r.customer_id = c.customer_id 
GROUP BY c.first_name, c.last_name
HAVING COUNT(*) > (
	SELECT AVG(num_rentals)
	FROM (
		SELECT customer_id, COUNT(*) AS num_rentals
		FROM rental
		GROUP BY customer_id 
	) AS customer_rental_totals
);

