-- Drop statements for maintaining referential integrity
DROP TABLE IF EXISTS maintains_assembly;
DROP TABLE IF EXISTS maintains_department;
DROP TABLE IF EXISTS maintains_process;
DROP TABLE IF EXISTS recorded;
DROP TABLE IF EXISTS cost_transactions;
DROP TABLE IF EXISTS manufactures;
DROP TABLE IF EXISTS supervised;
-- Drop statements for job-related tables
DROP TABLE IF EXISTS fit_job;
DROP TABLE IF EXISTS paint_job;
DROP TABLE IF EXISTS cut_job;
-- Drop statements for process-related tables
DROP TABLE IF EXISTS fit_process;
DROP TABLE IF EXISTS cut_process;
DROP TABLE IF EXISTS paint_process;
DROP TABLE IF EXISTS assigns;
-- Drop statements for assembly-related tables
DROP TABLE IF EXISTS assemblies;
DROP TABLE IF EXISTS customers;
-- Drop statements for department-related tables
DROP TABLE IF EXISTS departments;
DROP TABLE IF EXISTS department_account;
-- Drop statements for account-related tables
DROP TABLE IF EXISTS process_account;
DROP TABLE IF EXISTS assembly_account;
-- Drop statements for general tables
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS process;
DROP TABLE IF EXISTS account;
DROP TABLE IF EXISTS job;


-- Creating customer table
CREATE TABLE customers (
    customer_name VARCHAR(250),
    customer_address VARCHAR(250),
    category INT NOT NULL CHECK (category BETWEEN 1 AND 10)
    PRIMARY KEY (customer_name)
);

-- Creating assembly table
CREATE TABLE assemblies (
    assembly_id INT,
    date_ordered DATE,
    assembly_details VARCHAR(250),
    PRIMARY KEY (assembly_id),
);

-- Create orders table
CREATE TABLE orders (
    assembly_id INT,
    customer_name VARCHAR(250),
    PRIMARY KEY (assembly_id),
    FOREIGN KEY (assembly_id) REFERENCES assemblies(assembly_id),
    FOREIGN KEY (customer_name) REFERENCES customers(customer_name)
);

--Create departments table
CREATE TABLE departments (
    department_number INT,
    department_data VARCHAR(2500),
    PRIMARY KEY (department_number),
);  

-- Create process table
CREATE TABLE process (
    process_id INT,
    process_data VARCHAR(250),
    PRIMARY KEY (process_id),
);

-- Create paint process
CREATE TABLE paint_process (
    process_id INT,
    paint_type VARCHAR(250),
    painting_method VARCHAR(250),
    PRIMARY KEY (process_id),
    FOREIGN KEY (process_id) REFERENCES process(process_id)
);

-- Create fit process
CREATE TABLE fit_process (
    process_id INT,
    fit_type VARCHAR(250),
    PRIMARY KEY (process_id),
    FOREIGN KEY (process_id) REFERENCES process(process_id)
);

-- Create cut process
CREATE TABLE cut_process (
    process_id INT,
    cutting_type VARCHAR(250),
    machine_type VARCHAR(250),
    PRIMARY KEY (process_id),
    FOREIGN KEY (process_id) REFERENCES process(process_id)

);

CREATE TABLE supervised (
    process_id INT,
    department_number INT,
    PRIMARY KEY (process_id),
    FOREIGN KEY (process_id) REFERENCES process(process_id),
    FOREIGN KEY (department_number) REFERENCES departments(department_number)

)
CREATE INDEX Supervised_DepartmentName ON Supervised (department_number);

CREATE TABLE job (
    job_number INT,
    job_commenced_date DATE,
    job_completed_date DATE,
    labor_time DECIMAL(10,2),
    PRIMARY KEY (job_number)
)
CREATE INDEX Job_Completed_Date_Index ON job (job_completed_date);
CREATE INDEX JOB_JOB_NUMBER_INDEX ON job(job_number)

CREATE TABLE cut_job (
    job_number INT,   
    machine_type_used VARCHAR(250),
    amount_of_time_machine_used DECIMAL(10,2),
    material_used VARCHAR(250),
    PRIMARY KEY (job_number),
    FOREIGN KEY (job_number) REFERENCES job(job_number),
);
CREATE INDEX CUT_JOB_NUMBER_INDEX ON cut_job(job_number)

CREATE TABLE paint_job (
    job_number INT,
    color VARCHAR(250),
    volume DECIMAL(10,2),
    PRIMARY KEY (job_number),
    FOREIGN KEY (job_number) REFERENCES job(job_number)
);
CREATE INDEX PAINT_JOB_NUMBER_INDEX ON paint_job(job_number)

CREATE TABLE fit_job (
    job_number INT,
    PRIMARY KEY (job_number),
    FOREIGN KEY (job_number) REFERENCES job(job_number)
);

CREATE TABLE assigns(
    assembly_id INT,
    process_id INT,
    job_number INT,
    PRIMARY KEY (assembly_id, process_id),
    FOREIGN KEY (assembly_id) REFERENCES assemblies(assembly_id),
    FOREIGN KEY (process_id) REFERENCES process(process_id),
    FOREIGN KEY (job_number) REFERENCES job(job_number),
);
CREATE INDEX Assigns_Assembly_ID ON assigns (assembly_id);

CREATE TABLE manufactures (
    assembly_id INT,
    process_id INT,
    PRIMARY KEY (assembly_id, process_id),
    FOREIGN KEY (assembly_id) REFERENCES assemblies(assembly_id),
    FOREIGN KEY (process_id) REFERENCES process(process_id),
);

CREATE TABLE account(
    account_number INT,
    date_established DATE,
    PRIMARY KEY (account_number),
)

CREATE TABLE assembly_account (
    account_number INT,
    cost_details_1 VARCHAR(250),
    PRIMARY KEY (account_number),
    FOREIGN KEY (account_number) REFERENCES account(account_number)
);
CREATE INDEX Assembly_Account_Acc_Number_INdex ON assembly_account(account_number)

CREATE TABLE department_account (
    account_number INT,
    cost_details_2 VARCHAR(250),
    PRIMARY KEY (account_number),
    FOREIGN KEY (account_number) REFERENCES account(account_number)

);
CREATE INDEX Department_Account_Acc_Number_INdex ON department_account(account_number)

CREATE TABLE process_account (
    account_number INT,
    cost_details_3 VARCHAR(250),
    PRIMARY KEY (account_number),
    FOREIGN KEY (account_number) REFERENCES account(account_number)

);
--CREATE INDEX Process_Account_Acc_Number_INdex ON process_account(account_number)

CREATE TABLE cost_transactions (
    transaction_number INT,
    account_number INT,
    sup_cost DECIMAL(10,2),
    PRIMARY KEY (transaction_number),
    FOREIGN KEY (account_number) REFERENCES account(account_number)
);

CREATE TABLE recorded (
    transaction_number INT,
    job_number INT,
    PRIMARY KEY (transaction_number),
    FOREIGN KEY (transaction_number) REFERENCES cost_transactions(transaction_number),
    FOREIGN KEY (job_number) REFERENCES job(job_number)
);

CREATE TABLE maintains_process (
    process_id INT,
    account_number INT,
    PRIMARY KEY (process_id),
    FOREIGN KEY (account_number) REFERENCES account(account_number),
    FOREIGN KEY (process_id) REFERENCES process(process_id)
);

CREATE TABLE maintains_assembly (
    assembly_id INT,
    account_number INT,
    PRIMARY KEY (assembly_id),
    FOREIGN KEY (assembly_id) REFERENCES assemblies(assembly_id),
    FOREIGN KEY (account_number) REFERENCES account(account_number),

);
CREATE INDEX Maintains_Assembly_AssemblyID_INDEX ON maintains_assembly(assembly_id)

CREATE TABLE maintains_department (
    department_number INT,
    account_number INT,
    PRIMARY KEY (department_number),
    FOREIGN KEY (department_number) REFERENCES departments(department_number),
    FOREIGN KEY (account_number) REFERENCES account(account_number),

);




