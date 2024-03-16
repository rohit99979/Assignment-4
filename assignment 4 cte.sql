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
WITH ActorFilmCounts AS (
    SELECT 
        actor.actor_id,
        actor.first_name || ' ' || actor.last_name AS actor_name,
        COUNT(film_actor.film_id) AS film_count
    FROM 
        actor
    INNER JOIN 
        film_actor ON actor.actor_id = film_actor.actor_id
    GROUP BY 
        actor.actor_id, actor.first_name, actor.last_name
)

SELECT 
    actor_name,
    film_count
FROM 
    ActorFilmCounts;
    
-- 6.
WITH RECURSIVE CategoryHierarchy AS (
    SELECT 
        category_id,
        name,
        parent_id,
        1 AS level
    FROM 
        category
    WHERE 
        parent_id IS NULL -- Start with top-level categories
    
    UNION ALL
    
    SELECT 
        c.category_id,
        c.name,
        c.parent_id,
        ch.level + 1 AS level
    FROM 
        category c
    INNER JOIN 
        CategoryHierarchy ch ON c.parent_id = ch.category_id
)

SELECT 
    category_id,
    name,
    level
FROM 
    CategoryHierarchy
ORDER BY 
    level, category_id;

-- 7.
WITH FilmLanguageInfo AS (
    SELECT 
        f.title AS film_title,
        l.name AS language_name,
        f.rental_rate
    FROM 
        film f
    JOIN 
        language l ON f.language_id = l.language_id
)

SELECT 
    film_title,
    language_name,
    rental_rate
FROM 
    FilmLanguageInfo;

-- 8.
WITH CustomerRevenue AS (
    SELECT 
        c.customer_id,
        c.first_name || ' ' || c.last_name AS customer_name,
        SUM(p.amount) AS total_revenue
    FROM 
        customer c
    LEFT JOIN 
        payment p ON c.customer_id = p.customer_id
    GROUP BY 
        c.customer_id, customer_name
)

SELECT 
    customer_id,
    customer_name,
    COALESCE(total_revenue, 0) AS total_revenue
FROM 
    CustomerRevenue
ORDER BY 
    total_revenue DESC;

-- 9.
WITH FilmRank AS (
    SELECT 
        film_id,
        title,
        rental_duration,
        ROW_NUMBER() OVER (ORDER BY rental_duration DESC) AS duration_rank
    FROM 
        film
)

SELECT 
    film_id,
    title,
    rental_duration,
    duration_rank
FROM 
    FilmRank;

-- 10.
WITH CustomerRentals AS (
    SELECT 
        customer_id,
        COUNT(*) AS rental_count
    FROM 
        rental
    GROUP BY 
        customer_id
    HAVING 
        COUNT(*) > 2
)

SELECT 
    c.*,
    cr.rental_count
FROM 
    customer c
JOIN 
    CustomerRentals cr ON c.customer_id = cr.customer_id;

-- 11.
WITH MonthlyRentals AS (
    SELECT 
        EXTRACT(MONTH FROM rental_date) AS rental_month,
        COUNT(*) AS rental_count
    FROM 
        rental
    GROUP BY 
        EXTRACT(MONTH FROM rental_date)
)

SELECT 
    rental_month,
    rental_count
FROM 
    MonthlyRentals
ORDER BY 
    rental_month;

-- 12.
WITH PaymentPivot AS (
    SELECT 
        customer_id,
        SUM(CASE WHEN payment_type = 'Cash' THEN amount ELSE 0 END) AS cash_payments,
        SUM(CASE WHEN payment_type = 'Credit Card' THEN amount ELSE 0 END) AS credit_card_payments,
        SUM(CASE WHEN payment_type = 'Debit Card' THEN amount ELSE 0 END) AS debit_card_payments
    FROM 
        payment
    GROUP BY 
        customer_id
)

SELECT 
    customer_id,
    cash_payments,
    credit_card_payments,
    debit_card_payments
FROM 
    PaymentPivot;

-- 13.
WITH ActorPairs AS (
    SELECT 
        fa1.film_id,
        fa1.actor_id AS actor1_id,
        fa2.actor_id AS actor2_id
    FROM 
        film_actor fa1
    JOIN 
        film_actor fa2 ON fa1.film_id = fa2.film_id
    WHERE 
        fa1.actor_id < fa2.actor_id
)

SELECT 
    DISTINCT ap.actor1_id,
    ap.actor2_id
FROM 
    ActorPairs ap;

-- 14.
WITH RECURSIVE EmployeeHierarchy AS (
    SELECT 
        staff_id,
        first_name,
        last_name,
        reports_to
    FROM 
        staff
    WHERE 
        reports_to = manager_id -- Specify the manager's ID here

    UNION ALL

    SELECT 
        s.staff_id,
        s.first_name,
        s.last_name,
        s.reports_to
    FROM 
        staff s
    JOIN 
        EmployeeHierarchy e ON s.reports_to = e.staff_id
)

SELECT 
    staff_id,
    first_name,
    last_name
FROM 
    EmployeeHierarchy;
    
    











