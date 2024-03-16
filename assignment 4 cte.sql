-- 1.  
-- In the Sakila database, we can identify the "film" table as potentially violating the first normal form (1NF). 
-- The "film" table contains multiple attributes in a single field, such as the "actors" column which typically stores multiple actor IDs separated by commas.
-- To achieve 1NF, we need to ensure that each attribute contains atomic values, i.e., no multivalued attributes. Here's how we can normalize the "film" table to achieve 1NF:
-- Create a new table for actors: We need to create a separate table to store information about actors. This new table will have at least two columns: actor_id and actor_name.
CREATE TABLE actor (
    actor_id INT PRIMARY KEY AUTO_INCREMENT,
    actor_name VARCHAR(45) NOT NULL
);
-- Modify the film table: Instead of storing multiple actor IDs in a single column, we'll introduce a new table column that references the "actor" table.
ALTER TABLE film
ADD COLUMN actor_id INT;
-- Populate the actor_id column: We'll need to extract the actor IDs from the existing comma-separated list and insert them into the new "actor_id" column. 
-- This may require writing a script or running an update query depending on the complexity of the existing data.
-- Remove the multivalued attribute: Now that we have a separate table for actors and a column in the "film" table referencing these actors, we can remove the "actors" column from the "film" table.

-- 2.  
--  Let's consider the "payment" table in the Sakila database for this example. The "payment" table stores information about payments made by customers. It contains the following columns:
-- payment_id (Primary Key)
-- customer_id
-- staff_id
-- rental_id
-- amount
-- payment_date
-- To determine whether the "payment" table is in 2NF, we need to check if it meets two criteria:
-- It is already in 1NF.
-- All non-prime attributes (attributes not part of the primary key) are fully functionally dependent on the entire primary key.
-- Now, let's analyze the "payment" table:
-- The table has a primary key, "payment_id," so it meets the first criterion of being in 1NF.
-- The non-prime attributes are "customer_id," "staff_id," "rental_id," "amount," and "payment_date."
-- The "payment_date" and "amount" attributes are fully functionally dependent on the primary key, "payment_id," so they meet the second criterion.
-- However, the attributes "customer_id," "staff_id," and "rental_id" are not fully functionally dependent on the primary key. Instead, they are functionally dependent on subsets of the primary key.
-- Therefore, the "payment" table violates 2NF.
-- To normalize the "payment" table to achieve 2NF, we can follow these steps:
-- Identify the functional dependencies: From the "payment" table, we observe that "customer_id," "staff_id," and "rental_id" are functionally dependent on the composite primary key {payment_id, customer_id}.
-- Create separate tables for related attributes:
-- Create a "customer" table with columns: customer_id (Primary Key), first_name, last_name, email, etc.
-- Create a "staff" table with columns: staff_id (Primary Key), first_name, last_name, email, etc.
-- Create a "rental" table with columns: rental_id (Primary Key), rental_date, return_date, etc.
-- Modify the "payment" table:
-- Remove "customer_id," "staff_id," and "rental_id" from the "payment" table as they will be referenced from the new tables.
-- Add foreign key constraints to establish relationships between the "payment" table and the newly created tables.
-- After normalization, the "payment" table would maintain only information directly related to payments, while customer, staff
-- and rental information would be stored in separate tables, eliminating the violation of 2NF.

-- 3.
-- Let's consider the "inventory" table in the Sakila database for this example. The "inventory" table stores information about film inventory in the rental store. It contains the following columns:
-- inventory_id (Primary Key)
-- film_id
-- store_id
-- last_update
-- The potential transitive dependency in the "inventory" table is between "film_id" and "store_id" via "film_id."
-- Here's how it breaks down:
-- "film_id" determines information about the film, such as title, description, etc.
-- "store_id" determines information about the store, such as address, manager, etc.
-- Therefore, "film_id" indirectly determines information about the store through "film_id."
-- This transitive dependency creates redundancy because if we have multiple records with the same "film_id," we would have the same "store_id" repeated, 
-- leading to potential data anomalies and inefficiencies.
-- To normalize the "inventory" table to 3NF, we need to remove this transitive dependency. Here are the steps:
-- Create a new table for films: Create a "film" table that stores information about films. This table should have at least "film_id" (Primary Key), title, description, etc.
-- CREATE TABLE film (
    -- film_id INT PRIMARY KEY,
    -- title VARCHAR(255),
    -- description TEXT,
-- other film attributes
-- );
-- Create a new table for stores: Create a "store" table that stores information about stores. This table should have at least "store_id" (Primary Key), address, manager, etc.
-- CREATE TABLE store (
   --  store_id INT PRIMARY KEY,
   --  address VARCHAR(255),
   --  manager VARCHAR(255),
    -- other store attributes
-- );
-- Modify the "inventory" table:
-- Remove the "film_id" and "store_id" columns from the "inventory" table.
-- Add foreign key constraints to reference the "film" and "store" tables.
-- ALTER TABLE inventory
-- DROP COLUMN film_id,
-- DROP COLUMN store_id;
-- ALTER TABLE inventory
-- ADD COLUMN film_id INT,
-- ADD COLUMN store_id INT,
-- ADD CONSTRAINT fk_film FOREIGN KEY (film_id) REFERENCES film(film_id),
-- ADD CONSTRAINT fk_store FOREIGN KEY (store_id) REFERENCES store(store_id);
-- By following these steps, we've normalized the "inventory" table to 3NF. Each attribute is functionally dependent on the primary key,
--  and there are no transitive dependencies present, reducing redundancy and potential data anomalies.

-- 4.
-- Let's consider the "film_actor" table in the Sakila database for this example. The "film_actor" table stores the relationship between films and actors. It contains the following columns:
-- actor_id (Foreign Key)
-- film_id (Foreign Key)
-- last_update
-- First Normal Form (1NF):
-- To achieve 1NF, we need to ensure that each attribute contains atomic values, and there are no repeating groups. This table already satisfies 1NF as there are no multivalued attributes.
-- Second Normal Form (2NF):
-- To achieve 2NF, we need to ensure that the table is in 1NF and all non-prime attributes are fully functionally dependent on the entire primary key.
-- In the "film_actor" table, the primary key is the combination of {film_id, actor_id}. The only non-prime attribute is "last_update," and it is fully functionally dependent on the entire primary key.
-- Therefore, the "film_actor" table is already in 2NF.
-- Steps to Normalize:
-- Identify functional dependencies: Determine the functional dependencies in the table.
-- Decompose into separate tables: Based on the functional dependencies, create separate tables.
-- Define primary keys and foreign keys: Establish relationships between tables using primary keys and foreign keys.
-- Ensure each table is in 2NF: Verify that each table is in 2NF by checking for partial dependencies.
-- Since the "film_actor" table was already in 2NF, no further normalization steps are needed.

-- 5.
-- 










