--Implementing a Snowflake Roles Hierarchy with Service Roles


-- Analyst -> BI-Engineer -> Data Engineer

create database dev;

create database test;

create database prod;

create schema hr_department;
create or replace table hr_department.dim_employees (
    employee_id integer AUTOINCREMENT PRIMARY KEY,
    first_name varchar(50) NOT NULL,
    last_name varchar(50) NOT NULL,
    email varchar(100) UNIQUE NOT NULL,
    phone_number varchar(20),
    hire_date date NOT NULL,
    job_title varchar(50),
    salary decimal(10,2),
    department varchar(50)
);

INSERT INTO hr_department.dim_employees (first_name, last_name, email, phone_number, hire_date, job_title, salary, department)
VALUES
    ('John', 'Doe', 'john.doe@example.com', '123-456-7890', '2020-06-15', 'Software Engineer', 75000.00, 'IT'),
    ('Jane', 'Smith', 'jane.smith@example.com', '987-654-3210', '2018-09-25', 'HR Manager', 82000.00, 'Human Resources'),
    ('Alice', 'Brown', 'alice.brown@example.com', '555-123-4567', '2019-03-10', 'Marketing Specialist', 68000.00, 'Marketing'),
    ('Bob', 'Johnson', 'bob.johnson@example.com', '444-987-6543', '2021-11-01', 'Data Analyst', 72000.00, 'Analytics'),
    ('Charlie', 'Davis', 'charlie.davis@example.com', '333-222-1111', '2017-07-30', 'Finance Manager', 90000.00, 'Finance'),
    ('Diana', 'Wilson', 'diana.wilson@example.com', '222-333-4444', '2016-12-05', 'Sales Executive', 78000.00, 'Sales'),
    ('Ethan', 'Martinez', 'ethan.martinez@example.com', '666-555-4444', '2022-05-20', 'IT Support', 65000.00, 'IT'),
    ('Fiona', 'Taylor', 'fiona.taylor@example.com', '777-888-9999', '2019-08-15', 'Product Manager', 95000.00, 'Product Development'),
    ('George', 'Harris', 'george.harris@example.com', '111-222-3333', '2023-01-10', 'Business Analyst', 83000.00, 'Business Intelligence'),
    ('Hannah', 'White', 'hannah.white@example.com', '999-888-7777', '2015-10-01', 'Operations Manager', 99000.00, 'Operations');


alter table employees rename to dim_employees;

create schema finance_department;
create or replace table dim_transactions (
    transaction_id integer autoincrement primary key,
    account_id integer not null,
    transaction_date timestamp default current_timestamp(),
    transaction_type varchar(20) not null,
    amount number(15,2) not null,
    currency string(3) not null,
    description varchar 
);

-- sample data 
INSERT INTO prod.finance_department.dim_transactions (account_id, transaction_type, amount, currency, description)
VALUES 
    (101, 'credit', 500.00, 'USD', 'Salary deposit'),
    (102, 'debit', 200.50, 'EUR', 'Grocery shopping'),
    (103, 'credit', 1000.00, 'GBP', 'Freelance payment'),
    (104, 'debit', 75.00, 'USD', 'Electricity bill'),
    (105, 'credit', 250.00, 'EUR', 'Refund from vendor'),
    (106, 'debit', 40.99, 'USD', 'Online subscription'),
    (107, 'credit', 300.75, 'GBP', 'Stock dividend'),
    (108, 'debit', 150.25, 'EUR', 'Dinner at a restaurant');

use role accountadmin;
-- Defining admin roles


CREATE OR ALTER ROLE DATA_ADMIN_DEV;
CREATE OR ALTER ROLE DATA_ADMIN_TEST;
CREATE OR ALTER ROLE DATA_ADMIN_PROD;

grant role data_admin_dev to user olha;
grant role data_admin_test to user olha;
grant role data_admin_prod to user olha;


grant usage on warehouse compute_wh to role data_admin_dev;
grant usage on warehouse compute_wh to role data_admin_test;
grant usage on warehouse compute_wh to role data_admin_prod;

grant create role on account to role data_admin_dev;
grant manage grants on account to role data_admin_dev;

grant usage on database dev to role data_admin_dev;
grant usage on database test to role data_admin_test;
grant usage on database prod to role data_admin_prod;


grant usage on schema dev.finance_department to role data_admin_dev;
grant usage on schema dev.hr_department to role data_admin_dev;

grant usage on schema test.finance_department to role data_admin_test;
grant usage on schema test.hr_department to role data_admin_test;

grant usage on schema prod.finance_department to role data_admin_prod;
grant usage on schema prod.hr_department to role data_admin_prod;

grant select on all tables in schema dev.finance_department to role data_admin_dev;
grant select on all tables in schema dev.hr_department to role data_admin_dev;

grant select on all tables in schema test.finance_department to role data_admin_test;
grant select on all tables in schema test.hr_department to role data_admin_test;

grant select on all tables in schema prod.finance_department to role data_admin_prod;
grant select on all tables in schema prod.hr_department to role data_admin_prod;

grant role data_admin_dev to role sysadmin;
grant role data_admin_test to role sysadmin;
grant role data_admin_prod to role sysadmin;


-- define business roles

--  DATA_ANALYST
create role data_analyst;
show grants to role data_analyst;
grant role data_analyst to user olha;

grant usage on database prod to role data_analyst;
grant usage on warehouse compute_wh to role data_analyst;

grant usage on schema prod.finance_department to role data_analyst;
grant usage on schema prod.hr_department to role data_analyst;

grant select on all tables in schema prod.finance_department to role data_analyst;
grant select on all tables in schema prod.hr_department to role data_analyst;

grant role data_analyst to role data_admin_prod;
use role data_analyst;
select * from dim_transactions;
--  ENGINEER
create or alter role data_engineer;
show grants to role data_engineer;
grant role data_engineer to user olha;
grant usage on warehouse compute_wh to role data_engineer;
grant usage on warehouse intl_wh to role data_engineer;

grant usage on database dev to role data_engineer;
grant usage on database test to role data_engineer;
grant usage on database prod to role data_engineer;


grant usage on schema dev.finance_department to role data_engineer;
grant usage on schema dev.hr_department to role data_engineer;

grant usage on schema test.finance_department to role data_engineer;
grant usage on schema test.hr_department to role data_engineer;

grant usage on schema prod.finance_department to role data_engineer;
grant usage on schema prod.hr_department to role data_engineer;

grant select on all tables in schema dev.finance_department to role data_engineer;
grant select on all tables in schema dev.hr_department to role data_engineer;

grant select on all tables in schema test.finance_department to role data_engineer;
grant select on all tables in schema test.hr_department to role data_engineer;

grant select on all tables in schema prod.finance_department to role data_engineer;
grant select on all tables in schema prod.hr_department to role data_engineer;
GRANT INSERT,DELETE,update ON FUTURE TABLES IN SCHEMA dev.finance_department to role data_engineer;
GRANT INSERT,DELETE,update ON FUTURE TABLES IN SCHEMA dev.hr_department to role data_engineer;

GRANT INSERT,DELETE, update ON all TABLES IN SCHEMA dev.finance_department to role data_engineer;
GRANT INSERT,DELETE, update ON all TABLES IN SCHEMA dev.hr_department to role data_engineer;

GRANT INSERT,DELETE, update ON FUTURE VIEWS IN SCHEMA dev.finance_department to role data_engineer;
GRANT INSERT,DELETE, update ON FUTURE VIEWS IN SCHEMA dev.hr_department to role data_engineer;

GRANT INSERT,DELETE ON all VIEWS IN SCHEMA dev.finance_department to role data_engineer;
GRANT INSERT,DELETE ON all VIEWS IN SCHEMA dev.hr_department to role data_engineer;

GRANT CREATE MATERIALIZED VIEW ON SCHEMA dev.finance_department to role data_engineer;
GRANT CREATE MATERIALIZED VIEW ON SCHEMA dev.hr_department to role data_engineer;


GRANT ALL PRIVILEGES ON ALL STAGES IN DATABASE dev TO ROLE data_engineer;
GRANT ALL PRIVILEGES ON FUTURE STAGES IN DATABASE dev TO ROLE data_engineer;


grant role data_engineer to role data_admin_dev; 
grant role data_engineer to role data_admin_test; 


use role data_admin;
--  BI_DEVELOPER
create or alter role bi_developer;
show grants to role bi_developer;
grant role bi_developer to user olha;
grant usage on warehouse compute_wh to role bi_developer;

grant usage on database dev to role bi_developer;
grant usage on database test to role bi_developer;
grant usage on database prod to role bi_developer;

-- grant insert delete so on 
grant usage on schema dev.finance_department to role bi_developer;
grant usage on schema dev.hr_department to role bi_developer;

grant usage on schema test.finance_department to role bi_developer;
grant usage on schema test.hr_department to role bi_developer;

grant usage on schema prod.finance_department to role bi_developer;
grant usage on schema prod.hr_department to role bi_developer;

grant select on all tables in schema test.finance_department to role bi_developer;
grant select on all tables in schema test.hr_department to role bi_developer;
-- some manipulations can be possible 

GRANT CREATE MATERIALIZED VIEW ON SCHEMA dev.finance_department to role bi_developer;
GRANT CREATE MATERIALIZED VIEW ON SCHEMA dev.hr_department to role bi_developer;
-- Does bi_developer need to have access to prod db? haven't ran this yet
-- better to ask
grant select on all tables in schema prod.finance_department to role bi_developer;
grant select on all tables in schema prod.hr_department to role bi_developer;

grant select on all tables in schema dev.finance_department to role bi_developer;
grant select on all tables in schema dev.hr_department to role bi_developer;

grant select on all tables in schema TEST.finance_department to role bi_developer;
grant select on all tables in schema test.hr_department to role bi_developer;

GRANT INSERT,DELETE ON FUTURE TABLES IN SCHEMA dev.finance_department to role bi_developer;
GRANT INSERT,DELETE ON FUTURE TABLES IN SCHEMA dev.hr_department to role bi_developer;

GRANT INSERT,DELETE ON all TABLES IN SCHEMA dev.finance_department to role bi_developer;
GRANT INSERT,DELETE ON all TABLES IN SCHEMA dev.hr_department to role bi_developer;

grant role bi_developer to role data_admin_dev; 
grant role bi_developer to role data_admin_test; 

--  HR_ANALYST
create role hr_analyst;
show grants to role hr_analyst;
grant role hr_analyst to user olha;

grant usage on database prod to role hr_analyst;
grant usage on warehouse compute_wh to role hr_analyst;

grant usage on schema prod.hr_department to role hr_analyst;

grant select on all tables in schema prod.hr_department to role hr_analyst;

grant role hr_analyst to role data_admin_prod;
use role hr_analyst;
--  FINANCE_ANALYST

create role finance_anayst;
show grants to role finance_anayst;
grant role finance_anayst to user olha;

grant usage on database prod to role finance_anayst;
grant usage on warehouse compute_wh to role finance_anayst;

grant usage on schema prod.finance_department to role finance_anayst;

grant select on all tables in schema prod.finance_department to role finance_anayst;

grant role finance_anayst to role data_admin_prod;
use role finance_anayst;

-- · SECURITY_ADMIN: Manages users, roles, and grants permissions.

grant manage grants on account to role securityadmin;
show grants to role securityadmin;
GRANT CREATE USER ON ACCOUNT TO ROLE SECURITYADMIN;
GRANT CREATE ROLE ON ACCOUNT TO ROLE SECURITYADMIN;
grant usage on warehouse compute_wh to role securityadmin;

-- · SYSADMIN: Manages warehouses, databases, and non-business resources.
show grants to role sysadmin;

-- 3. Define Service Roles:

-- · OBJECT_OWNER: Role will be used to maitain all objects in database
create  role object_owner;
GRANT USAGE, CREATE SCHEMA ON DATABASE dev TO ROLE object_owner;


GRANT SELECT, INSERT, UPDATE, DELETE, TRUNCATE, REFERENCES ON ALL TABLES IN DATABASE dev TO ROLE object_owner;
GRANT SELECT, INSERT, UPDATE, DELETE, TRUNCATE, REFERENCES ON FUTURE TABLES IN DATABASE dev TO ROLE object_owner;

GRANT USAGE, CREATE TABLE, CREATE VIEW, CREATE STAGE ON ALL SCHEMAS IN DATABASE dev TO ROLE object_owner;
GRANT USAGE, CREATE TABLE, CREATE VIEW, CREATE STAGE ON FUTURE SCHEMAS IN DATABASE dev TO ROLE object_owner;

GRANT USAGE, CREATE SCHEMA ON DATABASE test TO ROLE object_owner;


GRANT SELECT, INSERT, UPDATE, REFERENCES ON ALL TABLES IN DATABASE test TO ROLE object_owner;
GRANT SELECT, INSERT, UPDATE, REFERENCES ON FUTURE TABLES IN DATABASE test TO ROLE object_owner;

GRANT USAGE, CREATE TABLE, CREATE VIEW, CREATE STAGE ON ALL SCHEMAS IN DATABASE test TO ROLE object_owner;
GRANT USAGE, CREATE TABLE, CREATE VIEW, CREATE STAGE ON FUTURE SCHEMAS IN DATABASE test TO ROLE object_owner;


GRANT SELECT ON ALL TABLES IN DATABASE prod TO ROLE object_owner;
GRANT SELECT ON FUTURE TABLES IN DATABASE prod TO ROLE object_owner;

GRANT USAGE ON ALL SCHEMAS IN DATABASE prod TO ROLE object_owner;
GRANT USAGE ON FUTURE SCHEMAS IN DATABASE prod TO ROLE object_owner;
grant role object_owner to role sysadmin;

show objects;
-- · ETL_SERVICE: Minimal access

DROP ROLE ETL_SERVICE;
create role etl_service;
grant role etl_service to user olha;
grant usage on warehouse compute_wh to role etl_service;



GRANT USAGE ON DATABASE dev TO ROLE etl_service;
GRANT USAGE ON DATABASE TEST TO ROLE etl_service;
GRANT USAGE ON DATABASE prod TO ROLE etl_service;


-- GRANT USAGE, CREATE SCHEMA ON DATABASE dev TO ROLE etl_service;
GRANT USAGE, CREATE TABLE, CREATE VIEW, CREATE STAGE ON SCHEMA dev.STAGING TO ROLE etl_service;
GRANT USAGE, CREATE TABLE, CREATE VIEW, CREATE STAGE ON SCHEMA test.STAGING TO ROLE etl_service;
GRANT USAGE ON SCHEMA prod.STAGING TO ROLE etl_service;


GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA dev.STAGING TO ROLE etl_service;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA test.STAGING TO ROLE etl_service;
GRANT SELECT ON ALL TABLES IN SCHEMA dev.STAGING TO ROLE etl_service;


GRANT SELECT, INSERT, UPDATE, DELETE ON FUTURE TABLES IN SCHEMA dev.STAGING TO ROLE etl_service;
GRANT SELECT, INSERT, UPDATE, DELETE ON FUTURE TABLES IN SCHEMA test.STAGING TO ROLE etl_service;
GRANT SELECT ON FUTURE TABLES IN SCHEMA prod.STAGING TO ROLE etl_service;


-- · REPORTING_SERVICE: Read-only access for BI dashboards.
create role reporting_service;

grant role reporting_service to user olha;
grant usage on warehouse compute_wh to role reporting_service;

grant usage on database prod to role reporting_service;

grant usage on schema prod.hr_department to role reporting_service;

grant select on all tables in schema prod.hr_department to role reporting_service;


grant usage on database prod to role reporting_service;

grant usage on schema prod.finance_department to role reporting_service;

grant select on all tables in schema prod.finance_department to role reporting_service;

GRANT SELECT on FUTURE TABLES IN DATABASE prod TO ROLE reporting_service;
GRANT usage on FUTURE schemas IN DATABASE prod TO ROLE reporting_service;

-- Create masking policy for roles

-- Dynamic Data Masking

CREATE MASKING POLICY employee_ssn_mask AS (val NUMBER(10,2)) RETURNS NUMBER(10,2) ->
  CASE
    WHEN CURRENT_ROLE() IN ('DATA_ENGINEER') THEN val
    
    ELSE null
  END;


CREATE MASKING POLICY test_employee_ssn_mask AS (val NUMBER(10,2)) RETURNS NUMBER(10,2) ->
  CASE
    WHEN CURRENT_ROLE() IN ('DATA_ENGINEER') THEN val
    when current_role() in ('BI_DEVELOPER') THEN val
    ELSE null
  END;
  
  drop masking policy test_employee_ssn_mask;
alter table dim_employees modify column salary set masking policy test_employee_ssn_mask;

alter table dim_employees modify column salary unset masking policy;


select * from prod.hr_department.dim_employees;



CREATE MASKING POLICY prod_email_phone_mask AS (val STRING) 
RETURNS STRING ->
  CASE
    WHEN CURRENT_ROLE() IN ('HR_ANALYST', 'FINANCE_ANALYST') THEN val
    ELSE '******'
  END;

ALTER TABLE hr_department.dim_employees 
  MODIFY COLUMN email SET MASKING POLICY prod_email_phone_mask;

ALTER TABLE hr_department.dim_employees 
  MODIFY COLUMN phone_number SET MASKING POLICY prod_email_phone_mask;

ALTER TABLE prod.hr_department.dim_employees 
MODIFY COLUMN email SET MASKING POLICY prod_email_phone_mask;

ALTER TABLE prod.hr_department.dim_employees 
MODIFY COLUMN phone_number SET MASKING POLICY prod_email_phone_mask;

ALTER TABLE prod.hr_department.dim_employees 
MODIFY COLUMN salary SET MASKING POLICY prod_etl_mask;

ALTER TABLE test.hr_department.dim_employees 
MODIFY COLUMN email SET MASKING POLICY prod_email_phone_mask;

ALTER TABLE test.hr_department.dim_employees 
MODIFY COLUMN phone_number SET MASKING POLICY prod_email_phone_mask;

SELECT * FROM prod.hr_department.dim_employees;

SELECT * FROM test.hr_department.dim_employees;

SELECT * FROM dev.hr_department.dim_employees;


-- row based policy
CREATE ROW ACCESS POLICY department_access_policy
AS (department STRING) RETURNS BOOLEAN ->
  CASE 
    WHEN CURRENT_ROLE() = 'HR_ANALYST' AND department = 'Human Resources' THEN TRUE
    WHEN CURRENT_ROLE() = 'FINANCE_ANALYST' AND department = 'Finance' THEN TRUE
    ELSE FALSE
  END;

ALTER ROW ACCESS POLICY department_access_policy 
SET BODY ->
  CASE 
    WHEN CURRENT_ROLE() IN ('HR_ANALYST') AND department = 'Human Resources' THEN TRUE
    WHEN CURRENT_ROLE() IN ('FINANCE_ANALYST') AND department = 'Finance' THEN TRUE
    WHEN CURRENT_ROLE() IN ('DATA_ANALYST') THEN TRUE  
    WHEN CURRENT_ROLE() IN ('BI_DEVELOPER') THEN TRUE
    WHEN CURRENT_ROLE() IN ('OBJECT_OWNER') THEN TRUE
    WHEN CURRENT_ROLE() IN ('reporting_service') THEN TRUE
    when current_role() in ('ETL_SERVICE') then true
    when current_role() in ('DATA_ENGINEER') THEN TRUE
    ELSE FALSE
  END;

show roles;


ALTER TABLE hr_department.dim_employees 
  ADD ROW ACCESS POLICY department_access_policy ON (department);



ALTER TABLE hr_department.dim_employees 
  MODIFY COLUMN phone_number SET MASKING POLICY prod_email_phone_mask;

SHOW MASKING POLICIES IN SCHEMA TEST.HR_DEPARTMENT;
SHOW ROW ACCESS POLICIES IN SCHEMA TEST.HR_DEPARTMENT;

DROP MASKING POLICY prod_email_phone_mask;

SELECT *, ROW_NUMBER() OVER(PARTITION BY FIRST_NAME, LAST_NAME, EMAIL, PHONE_NUMBER ORDER BY EMPLOYEE_ID) rn
FROM dim_employees qualify rn >= 1;

SELECT * FROM prod.hr_department.dim_employees;

SELECT * FROM test.hr_department.dim_employees;

SELECT * FROM dev.hr_department.dim_employees;

-- ADD SCHEMAS 
CREATE SCHEMA STAGING;

show masking  policies;
show row access policies;

drop row access policy DEPARTMENT_ACCESS_POLICY;


DESCRIBE row access POLICY DEPARTMENT_ACCESS_POLICY;

SHOW GRANTS ON SCHEMA test.hr_department;

GRANT SELECT ON ALL TABLES IN SCHEMA test.hr_department TO ROLE bi_developer;
GRANT SELECT ON ALL TABLES IN SCHEMA test.hr_department TO ROLE data_engineer;

GRANT SELECT ON FUTURE TABLES IN SCHEMA test.hr_department TO ROLE bi_developer;
GRANT SELECT ON FUTURE TABLES IN SCHEMA test.hr_department TO ROLE data_engineer;
