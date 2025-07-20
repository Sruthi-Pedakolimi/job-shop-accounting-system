DROP PROCEDURE IF EXISTS addCustomerDetails
DROP PROCEDURE IF EXISTS addDepartmentDetails
DROP PROCEDURE IF EXISTS addNewProcess
DROP PROCEDURE IF EXISTS addNewAssembly
DROP PROCEDURE IF EXISTS addAccountDetailsAndProcess
DROP PROCEDURE IF EXISTS addJobDetails
DROP PROCEDURE IF EXISTS ChangeColorPaintJob;
DROP PROCEDURE IF EXISTS deleteCutJobs;
DROP PROCEDURE IF EXISTS getCustomersForCategories;
DROP PROCEDURE IF EXISTS getProcessDepartmentDetails;
DROP PROCEDURE IF EXISTS getTotalCostIncurred;
DROP PROCEDURE IF EXISTS updateCostDetails;
DROP PROCEDURE IF EXISTS GetTotalLaborTimeInDepartment
DROP PROCEDURE IF EXISTS updateJobDetails;
DROP PROCEDURE IF EXISTS getCustomerData
--------------------------------------------------------------------------------------------------
-- 1. Enter a new customer (30/day).
---------------------------------------------------------------------------------------------------
GO
CREATE PROCEDURE addCustomerDetails
    @customer_name VARCHAR(250),
    @customer_address VARCHAR(250),
    @category INT
AS
BEGIN

    INSERT INTO customers(customer_name, customer_address, category)
    VALUES (@customer_name, @customer_address, @category);

END
---------------------------------------------------------------------------------------------------
-- 2. Enter a new department (infrequent).
---------------------------------------------------------------------------------------------------
GO
CREATE PROCEDURE addDepartmentDetails
    @department_number INT,
    @department_data VARCHAR(255)
AS
BEGIN

    INSERT INTO departments (department_number, department_data)
    VALUES (@department_number, @department_data);

END
------------------------------------------------------------------------------------------------------------------------
-- 3. Enter a new process-id and its department together with its type and information relevant to the type (infrequent)
------------------------------------------------------------------------------------------------------------------------
GO
CREATE PROCEDURE addNewProcess
    @process_id INT,
    @process_data VARCHAR(250),
    @paint_type VARCHAR(250),
    @painting_method VARCHAR(250),
    @fit_type VARCHAR(250),
    @cutting_type VARCHAR(250),
    @machine_type VARCHAR(250),
    @department_number INT,
    @process_type VARCHAR(250)
AS
BEGIN
    -- Insert into process and supervised tables
    INSERT INTO process (process_id, process_data) VALUES (@process_id, @process_data);
    INSERT INTO supervised (process_id, department_number ) VALUES (@process_id, @department_number)
    -- Inserting into respective process types based on the user selection
    IF @process_type = 'fit'
    BEGIN
        INSERT INTO fit_process (process_id, fit_type)
        VALUES (@process_id, @fit_type);
    END
    ELSE IF @process_type = 'paint'
    BEGIN
        INSERT INTO paint_process (process_id, paint_type, painting_method)
        VALUES (@process_id, @paint_type, @painting_method);
    END
    ELSE IF @process_type = 'cut'
    BEGIN
        INSERT INTO cut_process (process_id, cutting_type, machine_type)
        VALUES (@process_id, @cutting_type,@machine_type);
    END
END;


---------------------------------------------------------------------------------------------------
-- 4 Enter a new assembly with its customer-name, assembly-details, assembly-id, and date-ordered 
-- and associate it with one or more processes (40/day)
---------------------------------------------------------------------------------------------------
GO
CREATE PROCEDURE addNewAssembly(
    @assembly_id INT,
    @date_ordered VARCHAR(30),
    @assembly_details VARCHAR(250),
    @customer_name VARCHAR(250),
    @process_id VARCHAR(250)
)
AS
BEGIN
    -- Insert in assembly, order and manufactures
    INSERT INTO assemblies (assembly_id, date_ordered, assembly_details)
    VALUES (@assembly_id, @date_ordered, @assembly_details);
    
    INSERT INTO orders (assembly_id, customer_name)
    VALUES (@assembly_id, @customer_name);

    INSERT INTO manufactures (assembly_id, process_id) 
    VALUES (@assembly_id, @process_id)
    
END


------------------------------------------------------------------------------------------------------------------------
-- 5. Create a new account and associate it with the process, assembly, or department to which it is applicable (10/day)
------------------------------------------------------------------------------------------------------------------------
GO
-- Create the procedure
CREATE PROCEDURE addAccountDetailsAndProcess
    @account_type VARCHAR(50),
    @account_number INT,
    @cost_details DECIMAL(10, 2),
    @date_established VARCHAR(30),
    @process_id INT,
    @assembly_id INT,
    @department_number INT
AS
BEGIN
    
    INSERT INTO account (account_number, date_established)
    VALUES (@account_number, @date_established)
    -- Create the account for the account type the user inputs.
    IF @account_type = 'process'
    BEGIN
        INSERT INTO process_account (account_number, cost_details_3)
        VALUES (@account_number, @cost_details);
        INSERT INTO maintains_process (process_id, account_number)
        VALUES (@process_id, @account_number);
    END
    ELSE IF @account_type = 'assembly'
    BEGIN
        INSERT INTO assembly_account (account_number, cost_details_1)
        VALUES (@account_number, @cost_details);

        INSERT INTO maintains_assembly (assembly_id, account_number)
        VALUES (@assembly_id, @account_number);
    END
    ELSE IF @account_type = 'department'
    BEGIN
        INSERT INTO department_account (account_number, cost_details_2)
        VALUES (@account_number, @cost_details);

        INSERT INTO maintains_department (department_number, account_number)
        VALUES (@department_number, @account_number);
    END
    ELSE
    BEGIN
        -- Handle invalid account type
        SELECT 'Invalid account type. Supported types are process_account, assembly_account, and department_account.' AS Message;
        RETURN;
    END
END;
GO

--------------------------------------------------------------------------------------------------
-- 6. Enter a new job, given its job-no, assembly-id, process-id, and date the job commenced
-------------------------------------------------------------------------------------------------
GO
CREATE PROCEDURE addJobDetails
    @job_number INT,
    @assembly_id INT,
    @process_id INT,
    @job_commenced_date VARCHAR(30),
    @job_type VARCHAR(20),
    @machine_type_used VARCHAR(250),
    @material_used VARCHAR(250),
    @color VARCHAR(250),
    @volume VARCHAR(250)
AS
BEGIN
    
    INSERT INTO job(job_number, job_commenced_date, job_completed_date, labor_time) VALUES (@job_number, @job_commenced_date, null, null)
    INSERT INTO assigns (assembly_id, process_id, job_number) VALUES (@assembly_id, @process_id, @job_number);
    IF @job_type = 'cut'
    BEGIN
        INSERT INTO cut_job (job_number, machine_type_used, amount_of_time_machine_used, material_used)
        VALUES (@job_number, @machine_type_used, null, @material_used);
    END
    ELSE IF @job_type = 'paint'
    BEGIN
       INSERT INTO paint_job (job_number, color, volume)
        VALUES (@job_number, @color, @volume);

    END
    ELSE IF @job_type = 'fit'
    BEGIN
        INSERT INTO fit_job (job_number)
        VALUES (@job_number);

    END
    
END;

-------------------------------------------------------------------------------------------------------------
-- 7. At the completion of a job, enter the date it completed and the information relevant to the type of job (50/day). 
-------------------------------------------------------------------------------------------------------------
GO
CREATE PROCEDURE updateJobDetails
    @job_number INT,
    @job_completed_date  VARCHAR(15),
    @amount_of_time_machine_used  DECIMAL(10,2),
    @labor_time  DECIMAL(10,2)

AS
BEGIN
    DECLARE @job_type VARCHAR
    UPDATE Job
    SET job_completed_date = @job_completed_date,
    labor_time = @labor_time
    WHERE job_number= @job_number;

    SELECT @job_type = 
        CASE
            WHEN EXISTS (SELECT 1 FROM fit_job WHERE job_number= @job_number) THEN 'fit'
            WHEN EXISTS (SELECT 1 FROM cut_job WHERE job_number= @job_number) THEN 'cut'
            WHEN EXISTS (SELECT 1 FROM paint_job WHERE job_number= @job_number) THEN 'paint'
            ELSE NULL
        END;

   IF @job_type = 'cut'
    BEGIN

        Update Cut_Job SET 
        amount_of_time_machine_used  = @amount_of_time_machine_used
        WHERE job_number = @job_number; 
    END
END;
---------------------------------------------------------------------------------------------------
-- 8. Enter a transaction-no and its sup-cost and update all the costs 
--(details) of the affected accounts by adding sup-cost to their current values of details (50/day)
---------------------------------------------------------------------------------------------------
GO
CREATE PROCEDURE updateCostDetails
    @transaction_number INT,
    @sup_cost DECIMAL,
    @account_number INT
   
AS
BEGIN
    INSERT INTO cost_transactions(transaction_number, sup_cost, account_number)
    VALUES (@transaction_number,@sup_cost, @account_number)

    -- Update assembly account details
    IF EXISTS (SELECT 1 FROM assembly_account WHERE account_number = @account_number)
    BEGIN
        UPDATE assembly_account
        SET cost_details_1 = cost_details_1 + @sup_cost
        WHERE account_number = @account_number;
    END

    -- Update department account details
    ELSE IF EXISTS (SELECT 1 FROM department_account WHERE account_number = @account_number)
    BEGIN
        UPDATE department_account
        SET cost_details_2 = cost_details_2 +  @sup_cost
        WHERE account_number = @account_number;
    END
    ELSE IF EXISTS (SELECT 1 FROM process_account WHERE account_number = @account_number)
    BEGIN
        UPDATE process_account
        SET cost_details_3 = cost_details_3 + @sup_cost
        WHERE account_number = @account_number;
    END

END;

---------------------------------------------------------------------------
-- 9. Retrieve the total cost incurred on an assembly-id (200/day)
-----------------------------------------------------------------------------

GO
CREATE PROCEDURE getTotalCostIncurred
    @assembly_id  INT,
    @total_cost DECIMAL(10, 2) OUTPUT
AS
BEGIN
    SELECT @total_cost = SUM(ct.sup_cost) 
    FROM cost_transactions ct
    JOIN maintains_assembly ma ON ct.account_number = ma.account_number
    WHERE ma.assembly_id = @assembly_id;
END
PRINT 'total_sup_code: ' + CAST(@total_cost AS VARCHAR);
GO
------------------------------------------------------------------------------------------------------------
-- 10. Retrieve the total labor time within a department for jobs completed in the department during a given date 
----------------------------------------------------------------------------------------------------------
GO
CREATE PROCEDURE GetTotalLaborTimeInDepartment
    @department_number INT,
    @job_completed_date VARCHAR(30),
    @total_labor_time DECIMAL(10,2) OUTPUT
AS
BEGIN
    -- Calculate total labor time for jobs completed on the given date
    SELECT @total_labor_time = ISNULL(SUM(j.labor_time), 0)
    FROM job AS j
    WHERE j.job_number IN (
        SELECT job_number
        FROM assigns
        WHERE process_id IN (
            SELECT process_id
            FROM supervised
            WHERE department_number = @department_number
        )
    ) AND j.job_completed_date = @job_completed_date;
    SELECT @total_labor_time AS TotalLaborTime;
END;

--------------------------------------------------------------------------------------------
-- 11. Retrieve the processes through which a given assembly-id has passed so far (in date-
-- commenced order) and the department responsible for each process 
--------------------------------------------------------------------------------------------

GO
CREATE PROCEDURE getProcessDepartmentDetails
    @assembly_id INT 
AS
BEGIN
    SELECT s.process_id, s.department_number FROM supervised as s where 
    s.process_id in (SELECT a.process_id FROM assigns as a where a.assembly_id = @assembly_id)
    ORDER BY (SELECT job_commenced_date
    FROM job AS j
    WHERE j.job_number = (SELECT a.job_number FROM assigns AS a WHERE a.assembly_id = @assembly_id))

END
GO
--------------------------------------------------------------------------------------------
-- 12. Retrieve the customers (in name order) whose category is in a given range (100/day)
--------------------------------------------------------------------------------------------

GO
CREATE PROCEDURE getCustomersForCategories
    @range_start INT,
    @range_end INT    
AS
BEGIN
    SELECT * FROM customers
    WHERE category BETWEEN @range_start AND @range_end ORDER BY customer_name;
END
GO

------------------------------------------------------------------------------------
-- 13. Delete all cut-jobs whose job-no is in a given range (1/month).
-------------------------------------------------------------------------------------

GO
CREATE PROCEDURE deleteCutJobs
    @job_number_start INT,
    @job_number_end INT    
AS
BEGIN
    DELETE FROM cut_job
    WHERE job_number BETWEEN @job_number_start AND @job_number_end;

    DELETE FROM job
    WHERE job_number BETWEEN @job_number_start AND @job_number_end;
END
GO

---------------------------------------------------------------------------------------
-- 14.Change the color of a given paint job (1/week). 
--------------------------------------------------------------------------------------

GO
CREATE PROCEDURE ChangeColorPaintJob
    @paint_job_number INT,
    @color VARCHAR(50)
AS
BEGIN
    UPDATE paint_job
    SET color = @color
    WHERE job_number = @paint_job_number;
END;

-----------------------------------------------------------------------------------------
-- Get the customers based on category
-----------------------------------------------------------------------------------------
GO
CREATE PROCEDURE getCustomerData
    @min INT,
    @max INT
AS
BEGIN
    select * from customers where category >= @min and category <= @max
END;