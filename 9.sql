-- Set the appropriate isolation level
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	-- Select first_name, last_name, email and phone
	SELECT
    	first_name, 
        last_name, 
        email, 
        phone
    FROM customers;

    ---***---

    -- Set the appropriate isolation level
SET TRANSACTION ISOLATION LEVEL READ COMMITTED

-- Count the accounts
SELECT COUNT(*) AS number_of_accounts
FROM accounts
WHERE current_balance >= 50000;

    ---***---

    -- Set the appropriate isolation level
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ

-- Begin a transaction
BEGIN TRAN

SELECT * FROM customers;

-- some mathematical operations, don't care about them...

SELECT * FROM customers;

-- Commit the transaction
COMMIT TRAN

    ---***---

    -- Set the appropriate isolation level
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE

-- Begin a transaction
BEGIN TRAN

SELECT * FROM customers;

-- After some mathematical operations, we selected information from the customers table.
SELECT * FROM customers;

-- Commit the transaction
COMMIT TRAN

    ---***---

    -- Set the appropriate isolation level
SET TRANSACTION ISOLATION LEVEL SERIALIZABLE

-- Begin a transaction
BEGIN TRAN

-- Select customer_id between 1 and 10
SELECT * 
FROM customers
WHERE customer_id BETWEEN 1 AND 10;

-- After completing some mathematical operation, select customer_id between 1 and 10
SELECT * 
FROM customers
WHERE customer_id BETWEEN 1 AND 10;

-- Commit the transaction
COMMIT TRAN

    ---***---

    SELECT *
	-- Avoid being blocked
	FROM transactions WITH (NOLOCK)
WHERE account_id = 1