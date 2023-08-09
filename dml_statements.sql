-- Data Manipulation Language (DML)


-- Add a row of data to a table
-- Syntax: INSERT INTO table_name(col_1, col_2, etc.) VALUES (val_1, val_2, etc.)

SELECT *
FROM customer;

INSERT INTO customer (
	first_name,
	last_name,
	email,
	image_url,
	username
) VALUES (
	'Brian',
	'Stanton',
	'brians@ct.com',
	'https://image.com/1',
	'brians'
);


SELECT *
FROM customer;


-- ORDER OF COLUMNS MATTER!
INSERT INTO customer (
	email,
	last_name,
	username,
	image_url,
	first_name
) VALUES (
	'sarahs@ct.com',
	'Stodder',
	'sarahs',
	'https://image.com/2',
	'Sarah'
);

SELECT *
FROM customer;


SELECT *
FROM vendor;

-- Insert values only
-- Syntax: INSERT INTO table_name VALUES (val_1, val_2, etc.)
-- Follows the original order that the columns were added

INSERT INTO vendor VALUES (
	1,
	'Awesome Vendor Unltd.',
	'Really awesome products from a reall awesome vendor',
	'awesome@vendor.com',
	'https://image.com/3'
);

SELECT *
FROM vendor;

-- Because we put in the first vendor manually with an ID of 1, the SERIAL did not call nextval
-- so if we try to create another vendor, it will initially throw an error
INSERT INTO vendor (
	vendor_name,
	description,
	email,
	image_url
) VALUES (
	'Rad Vendors LLC',
	'Super rad vendors',
	'rad@vendor.com',
	'https://image.com/4'
);

SELECT *
FROM vendor;

SELECT nextval('vendor_vendor_id_seq');

INSERT INTO vendor (
	vendor_name,
	description,
	email,
	image_url
) VALUES (
	'Boring Vendor',
	'Nothing cool about us',
	'boring@vendor.com',
	'https://image.com/5'
);

SELECT *
FROM vendor;

-- Insert Mutliple rows of data in one commmand
-- Syntax: INSERT INTO table(col_1, col_2, etc) VALUES (val_a_1, val_a_2, etc), (val_b_1, val_b_2, etc.)

SELECT *
FROM product;

INSERT INTO product (
	prod_name,
	description,
	price,
	vendor_id,
	image_url
) VALUES (
	'Mirror',
	'See yourself!',
	49.99,
	1,
	'https://image.com/6'
), (
	'Backscratcher',
	'Scratch those hard to reach parts of your back',
	9.99,
	2,
	'https://image.com/7'
), (
	'Monitor',
	'Another screen to see code',
	39.50,
	6,
	'https://image.com/8'
);

SELECT *
FROM product;

-- Try to add a product with a vendor_id that does not exist
--INSERT INTO product (
--	prod_name,
--	description,
--	price,
--	vendor_id,
--	image_url 
--) VALUES (
--	'Pillow Pets',
--	'They are like pets but also pillows!',
--	24.50,
--	30, -- Vendor WITH ID 30 does NOT EXIST!
--	'https://image.com/9'
--);


-- UPDATE

-- Syntax: UPDATE table_name SET col_name1 = value1, col_name2 = value2, etc WHERE condition
-- WHERE is not required but highly recommended *without WHERE every row will be updated

SELECT *
FROM customer;

UPDATE customer
SET email = 'bstanton@ct.com'
WHERE customer_id = 1;


-- add more customers for example...
INSERT INTO customer (
	first_name,
	last_name,
	email,
	username
) VALUES (
	'Michael',
	'Jordan',
	'mj@jumpman.com',
	'goat'
), (
	'Scottie',
	'Pippen',
	'sidekick@jumpman.com',
	'scottie'
), (
	'Dennis',
	'Rodman',
	'crazy@jumpman.com',
	'worm'
);

SELECT *
FROM customer;


-- An UPDATE/SET without a WHERE will update all rows
UPDATE customer 
SET loyalty_member = TRUE;

SELECT *
FROM customer;

-- set all customers with a 'jumpman' email to not be loyalty_members
UPDATE customer
SET loyalty_member = 'off'
WHERE email LIKE '%jumpman%';

SELECT *
FROM customer;


-- Update multiple columns in one command - SET col_1 = val1, col_2 = val2, etc
SELECT *
FROM product;

UPDATE product
SET description = 'Scratches your back', price = 19.99
WHERE product_id = 2;

SELECT *
FROM product;

-- DELETE 

-- Syntax: DELETE FROM table_name WHERE condition 
-- WHERE is not required but highly recommended *without WHERE every row will be deleted

SELECT *
FROM customer;

DELETE FROM customer
WHERE customer_id >= 4;

SELECT *
FROM customer;



-- A DELETE FROM without a WHERE will delete all rows
DELETE FROM product;

SELECT *
FROM product;

SELECT *
FROM vendor;

-- INSERT a product that is related to vendor 1
INSERT INTO product(
	prod_name,
	description,
	price,
	vendor_id
) VALUES (
	'Awesome Product',
	'No really, it is super awesome',
	9.99,
	1
);

SELECT *
FROM product;

SELECT *
FROM vendor;

ALTER TABLE product
DROP CONSTRAINT product_vendor_id_fkey;

ALTER TABLE product
ADD FOREIGN KEY (vendor_id) REFERENCES vendor(vendor_id) ON DELETE CASCADE;

-- DELETE vendor 1 (or whichever vendor the above product is related to)
DELETE FROM vendor
WHERE vendor_id = 1;

SELECT *
FROM vendor;

SELECT *
FROM product;



