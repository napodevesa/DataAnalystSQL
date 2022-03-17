CREATE PROCEDURE insert_product
  @product_name VARCHAR(50),
  @stock INT,
  @price DECIMAL

AS

BEGIN TRY
	INSERT INTO products (product_name, stock, price)
		VALUES (@product_name, @stock, @price);
END TRY
-- Set up the CATCH block
BEGIN CATCH	
	-- Insert the error and end the statement with a semicolon
    INSERT INTO errors VALUES ('Error inserting a product');  
    -- Re-throw the error
	THROW;  
END CATCH

----***----

BEGIN TRY
	-- Execute the stored procedure
	EXEC insert_product 
    	-- Set the values for the parameters
    	@product_name = 'Trek Conduit+',
        @stock = 3,
        @price = 499.99;
END TRY
-- Set up the CATCH block
BEGIN CATCH
	-- Select the error message
	SELECT ERROR_MESSAGE();
END CATCH
----***----

DECLARE @staff_id INT = 4;

IF NOT EXISTS (SELECT * FROM staff WHERE staff_id = @staff_id)
   	-- Invoke the THROW statement with parameters
	THROW 50001, 'No staff member with such id', 1;
ELSE
   	SELECT * FROM staff WHERE staff_id = @staff_id

----***----

   	