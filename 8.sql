BEGIN TRY  
	BEGIN TRAN; 
		UPDATE accounts SET current_balance = current_balance - 100 WHERE account_id = 1;
		INSERT INTO transactions VALUES (1, -100, GETDATE());
        
		UPDATE accounts SET current_balance = current_balance + 100 WHERE account_id = 5;
		INSERT INTO transactions VALUES (5, 100, GETDATE());
	COMMIT TRAN;     
END TRY
BEGIN CATCH  
	ROLLBACK TRAN;
END CATCH

---**---
BEGIN TRY  
	-- Begin the transaction
	BEGIN TRAN;
		UPDATE accounts SET current_balance = current_balance - 100 WHERE account_id = 1;
		INSERT INTO transactions VALUES (1, -100, GETDATE());
        
		UPDATE accounts SET current_balance = current_balance + 100 WHERE account_id = 5;
        -- Correct it
		INSERT INTO transactions VALUES (5, 100, GETDATE());
    -- Commit the transaction
	COMMIT TRAN;    
END TRY
BEGIN CATCH  
	SELECT 'Rolling back the transaction';
    -- Rollback the transaction
	ROLLBACK TRAN;
END CATCH
---**---

-- Begin the transaction
BEGIN TRAN;
	UPDATE accounts set current_balance = current_balance + 100
		WHERE current_balance < 5000;
	-- Check number of affected rows
	IF @@ROWCOUNT > 200 
		BEGIN 
        	-- Rollback the transaction
			ROLLBACK TRAN; 
			SELECT 'More accounts than expected. Rolling back'; 
		END
	ELSE
		BEGIN 
        	-- Commit the transaction
			COMMIT TRAN; 
			SELECT 'Updates commited'; 
		END

---**---

BEGIN TRY
	-- Begin the transaction
	BEGIN TRAN;
    	-- Correct the mistake
		UPDATE accounts SET current_balance = current_balance + 200
			WHERE account_id = 10;
    	-- Check if there is a transaction
		IF @@TRANCOUNT > 0     
    		-- Commit the transaction
			COMMIT TRAN;
     
	SELECT * FROM accounts
    	WHERE account_id = 10;      
END TRY
BEGIN CATCH  
    SELECT 'Rolling back the transaction'; 
    -- Check if there is a transaction
    IF @@TRANCOUNT > 0   	
    	-- Rollback the transaction
        ROLLBACK TRAN;
END CATCH
---**---
BEGIN TRAN;
	-- Mark savepoint1
	SAVE TRAN savepoint1;
	INSERT INTO customers VALUES ('Mark', 'Davis', 'markdavis@mail.com', '555909090');

	-- Mark savepoint2
    SAVE TRAN savepoint2;
	INSERT INTO customers VALUES ('Zack', 'Roberts', 'zackroberts@mail.com', '555919191');

	-- Rollback savepoint2
	ROLLBACK TRAN savepoint2;
    -- Rollback savepoint1
	ROLLBACK TRAN savepoint1;

	-- Mark savepoint3
	SAVE TRAN savepoint3;
	INSERT INTO customers VALUES ('Jeremy', 'Johnsson', 'jeremyjohnsson@mail.com', '555929292');
-- Commit the transaction
COMMIT TRAN;
---**---

-- Use the appropriate setting
SET XACT_ABORT ON;
-- Begin the transaction
BEGIN TRAN; 
	UPDATE accounts set current_balance = current_balance - current_balance * 0.01 / 100
		WHERE current_balance > 5000000;
	IF @@ROWCOUNT <= 10	
    	-- Throw the error
		THROW 55000, 'Not enough wealthy customers!', 1;
	ELSE		
    	-- Commit the transaction
		COMMIT TRAN; 

---**---
-- Use the appropriate setting
SET XACT_ABORT ON;
BEGIN TRY
	BEGIN TRAN;
		INSERT INTO customers VALUES ('Mark', 'Davis', 'markdavis@mail.com', '555909090');
		INSERT INTO customers VALUES ('Dylan', 'Smith', 'dylansmith@mail.com', '555888999');
	COMMIT TRAN;
END TRY
BEGIN CATCH
	-- Check if there is an open transaction
	IF XACT_STATE() <> 0
    	-- Rollback the transaction
		ROLLBACK TRAN;
    -- Select the message of the error
    SELECT ERROR_MESSAGE() AS Error_message;
END CATCH
