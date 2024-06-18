-- Create the database
DROP DATABASE IF EXISTS company_db;
CREATE DATABASE company_db;	

USE company_db;

CREATE TABLE tbl_regions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(25) NOT NULL
);

CREATE TABLE tbl_countries (
    id CHAR(3) PRIMARY KEY,
    name VARCHAR(40) NOT NULL,
    region INT,
    FOREIGN KEY (region) REFERENCES tbl_regions(id) ON DELETE SET NULL
);

CREATE TABLE tbl_locations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    street_address VARCHAR(40),
    postal_code VARCHAR(12),
    city VARCHAR(30) NOT NULL,
    state_province VARCHAR(25),
    country CHAR(3),
    FOREIGN KEY (country) REFERENCES tbl_countries(id) ON DELETE SET NULL
);

CREATE TABLE tbl_departments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(30) NOT NULL,
    location INT,
    FOREIGN KEY (location) REFERENCES tbl_locations(id) ON DELETE SET NULL
);

CREATE TABLE tbl_jobs (
    id VARCHAR(10) PRIMARY KEY,
    title VARCHAR(35) NOT NULL,
    min_salary INT,
    max_salary INT
);

CREATE TABLE tbl_roles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL
);

CREATE TABLE tbl_permissions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL
);

CREATE TABLE tbl_employees (
    id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(25) NOT NULL,
    last_name VARCHAR(25) NOT NULL,
    gender VARCHAR(10),
    email VARCHAR(50),
    phone VARCHAR(20),
    hire_date DATE,
    salary INT,
    manager INT,
    job VARCHAR(10),
    department INT,
    FOREIGN KEY (manager) REFERENCES tbl_employees(id),
    FOREIGN KEY (job) REFERENCES tbl_jobs(id) ON DELETE SET NULL,
    FOREIGN KEY (department) REFERENCES tbl_departments(id) ON DELETE SET NULL
);

CREATE TABLE tbl_accounts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(25) NOT NULL,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(50),
    otp INT,
    is_expired BIT,
    is_used BIT,
    FOREIGN KEY (id) REFERENCES tbl_employees(id) ON DELETE cascade
);

CREATE TABLE tbl_job_histories (
    employee INT,
    name varchar(255),
    start_date DATE,
    end_date DATE,
    status VARCHAR(10),
    job VARCHAR(10),
    department INT,
    PRIMARY KEY (employee, start_date),
    FOREIGN KEY (job) REFERENCES tbl_jobs(id) ON DELETE SET NULL,
    FOREIGN KEY (department) REFERENCES tbl_departments(id) ON DELETE SET NULL
);

CREATE TABLE tbl_payslip (
    employee INT,
    salary_period DATE,
    overtime INT,
    PRIMARY KEY (employee, salary_period),
    FOREIGN KEY (employee) REFERENCES tbl_employees(id) ON DELETE cascade
);

CREATE TABLE tbl_account_roles (
    id INT AUTO_INCREMENT PRIMARY KEY,
    account INT,
    role INT,
    FOREIGN KEY (account) REFERENCES tbl_accounts(id) ON DELETE CASCADE,
    FOREIGN KEY (role) REFERENCES tbl_roles(id) ON DELETE SET NULL
);

CREATE TABLE tbl_role_permissions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    role INT,
    permission INT,
    FOREIGN KEY (role) REFERENCES tbl_roles(id) ON DELETE CASCADE,
    FOREIGN KEY (permission) REFERENCES tbl_permissions(id) ON DELETE SET NULL
);
DELIMITER //

CREATE FUNCTION func_salary(job_id VARCHAR(10), salary INT)
RETURNS BIT
DETERMINISTIC
BEGIN
    DECLARE result BIT;

    SELECT CASE
        WHEN salary BETWEEN j.min_salary AND j.max_salary THEN 1
        ELSE 0
    END INTO result
    FROM tbl_jobs j
    WHERE j.id = job_id;

    RETURN result;
END //

DELIMITER ;
DELIMITER //

CREATE FUNCTION func_max_salary(min_salary INT, max_salary INT)
RETURNS BIT
DETERMINISTIC
BEGIN
    DECLARE result BIT;

    IF max_salary > min_salary THEN
        SET result = 1;
    ELSE
        SET result = 0;
    END IF;

    RETURN result;
END //

DELIMITER ;

-- Trigger
DELIMITER //

CREATE TRIGGER tr_insert_employee
AFTER INSERT
ON tbl_employees
FOR EACH ROW
BEGIN
    INSERT INTO tbl_job_histories (employee,name, start_date, end_date,status, job, department)
    VALUES (NEW.id,CONCAT(NEW.first_name, ' ', NEW.last_name), NEW.hire_date,0000-00-00, 'Active', NEW.job, NEW.department);
END;
//

DELIMITER ;
DELIMITER //

CREATE TRIGGER tr_update_employee_job
AFTER UPDATE
ON tbl_employees
FOR EACH ROW
BEGIN
    IF NEW.job <> OLD.job THEN
        INSERT INTO tbl_job_histories (employee, start_date, status, job, department)
        VALUES (NEW.id, NOW(), 'Hand Over', NEW.job, NEW.department);
    END IF;
END;
//

DELIMITER ;
DELIMITER //

CREATE TRIGGER tr_delete_employee
AFTER DELETE
ON tbl_employees
FOR EACH ROW
BEGIN
    INSERT INTO tbl_job_histories (employee, name, end_date, status, job, department)
    VALUES (OLD.id, CONCAT(OLD.first_name, ' ', OLD.last_name), NOW(), 'Resign', OLD.job, OLD.department);
END;
//

DELIMITER ;

-- Add Department
DELIMITER //
CREATE PROCEDURE usp_add_department(
    IN name VARCHAR(30),
    IN location INT
)
BEGIN
    INSERT INTO tbl_departments (name, location)
    VALUES (name, location);
END //
DELIMITER ;

-- Update Department
DELIMITER //
CREATE PROCEDURE usp_update_department(
    IN id1 INT,
    IN name VARCHAR(30),
    IN location INT
)
BEGIN
    UPDATE tbl_departments
    SET name = name,
        location = location
    WHERE id = id1;
END //
DELIMITER ;

-- Delete Department
DELIMITER //
CREATE PROCEDURE usp_delete_department(
    IN id1 INT
)
BEGIN
    DELETE FROM tbl_departments
    WHERE id = id1;
END //
DELIMITER ;

-- Add Region
DELIMITER //
CREATE PROCEDURE usp_add_region(
    IN name VARCHAR(25)
)
BEGIN
    INSERT INTO tbl_regions (name)
    VALUES (name);
END //
DELIMITER ;

-- Update Region
DELIMITER //
CREATE PROCEDURE usp_update_region(
    IN id1 INT,
    IN name VARCHAR(25)
)
BEGIN
    UPDATE tbl_regions
    SET name = name
    WHERE id = id1;
END //
DELIMITER ;

-- Delete Region
DELIMITER //
CREATE PROCEDURE usp_delete_region(
    IN id1 INT
)
BEGIN
    DELETE FROM tbl_regions
    WHERE id = id1;
END //
DELIMITER ;

-- Add Role
DELIMITER //
CREATE PROCEDURE usp_add_roles(
    IN name VARCHAR(50)
)
BEGIN
    INSERT INTO tbl_roles (name)
    VALUES (name);
END //
DELIMITER ;

-- Update Role
DELIMITER //
CREATE PROCEDURE usp_update_roles(
    IN id1 INT,
    IN name VARCHAR(50)
)
BEGIN
    UPDATE tbl_roles
    SET name = name
    WHERE id = id1;
END //
DELIMITER ;

-- Delete Role
DELIMITER //
CREATE PROCEDURE usp_delete_roles(
    IN id1 INT
)
BEGIN
    DELETE FROM tbl_roles
    WHERE id = id1;
END //
DELIMITER ;

-- Add Permission
DELIMITER //
CREATE PROCEDURE usp_add_permission(
    IN name VARCHAR(100)
)
BEGIN
    INSERT INTO tbl_permissions (name)
    VALUES (name);
END //
DELIMITER ;

-- Update Permission
DELIMITER //
CREATE PROCEDURE usp_update_permission(
    IN id1 INT,
    IN name VARCHAR(100)
)
BEGIN
    UPDATE tbl_permissions
    SET name = name
    WHERE id = id1;
END //
DELIMITER ;

-- Delete Permission
DELIMITER //
CREATE PROCEDURE usp_delete_permission(
    IN id1 INT
)
BEGIN
    DELETE FROM tbl_permissions
    WHERE id = id1;
END //
DELIMITER ;

-- Add Location
DELIMITER //
CREATE PROCEDURE usp_add_location(
    IN street_address VARCHAR(40),
    IN postal_code VARCHAR(12),
    IN city VARCHAR(30),
    IN state_province VARCHAR(25),
    IN country CHAR(3)
)
BEGIN
    INSERT INTO tbl_locations (street_address, postal_code, city, state_province, country)
    VALUES (street_address, postal_code, city, state_province, country);
END //
DELIMITER ;

-- Update Location
DELIMITER //
CREATE PROCEDURE usp_update_location(
    IN id1 INT,
    IN street_address VARCHAR(40),
    IN postal_code VARCHAR(12),
    IN city VARCHAR(30),
    IN state_province VARCHAR(25),
    IN country CHAR(3)
)
BEGIN
    UPDATE tbl_locations
    SET street_address = street_address,
        postal_code = postal_code,
        city = city,
        state_province = state_province,
        country = country
    WHERE id = id1;
END //
DELIMITER ;

-- Delete Location
DELIMITER //
CREATE PROCEDURE usp_delete_location(
    IN id1 INT
)
BEGIN
    DELETE FROM tbl_locations
    WHERE id = id1;
END //
DELIMITER ;

-- Add Country
DELIMITER //
CREATE PROCEDURE usp_add_country(
    IN id1 CHAR(3),
    IN name VARCHAR(40),
    IN region INT
)
BEGIN
    INSERT INTO tbl_countries (id, name, region)
    VALUES (id, name, region);
END //
DELIMITER ;

-- Update Country
DELIMITER //
CREATE PROCEDURE usp_update_country(
    IN id1 CHAR(3),
    IN name VARCHAR(40),
    IN region INT
)
BEGIN
    UPDATE tbl_countries
    set name = name,
        region = region
    WHERE id = id1;
END //
DELIMITER ;

-- Delete Country
DELIMITER //
CREATE PROCEDURE usp_delete_country(
    IN id1 CHAR(3)
)
BEGIN
    DELETE FROM tbl_countries
    WHERE id = id1;
END //
DELIMITER ;

-- Add Jobs
DELIMITER //
CREATE PROCEDURE usp_add_jobs(
    IN id1 VARCHAR(10),
    IN title VARCHAR(35),
    IN min_salary INT,
    IN max_salary INT
)
BEGIN
    DECLARE result BIT;
    
    SET result = func_max_salary(min_salary, max_salary);
    
    IF result = 1 THEN
        INSERT INTO tbl_jobs (id, title, min_salary, max_salary)
        VALUES (id, title, min_salary, max_salary);
    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'The max salary must be greater than the min salary';
    END IF;
END //
DELIMITER ;

-- Update Jobs
DELIMITER //
CREATE PROCEDURE usp_update_jobs(
    IN id1 VARCHAR(10),
    IN title VARCHAR(35),
    IN min_salary INT,
    IN max_salary INT
)
BEGIN
    DECLARE result BIT;
    
    SET result = func_max_salary(min_salary, max_salary);
    
    IF result = 1 THEN
        UPDATE tbl_jobs
        SET title = title,
            min_salary = min_salary,
            max_salary = max_salary
        WHERE id = id1;
    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'The max salary must be greater than the min salary';
    END IF;
END //
DELIMITER ;

-- Delete Jobs
DELIMITER //
CREATE PROCEDURE usp_delete_jobs(
    IN id1 VARCHAR(10)
)
BEGIN
    DELETE FROM tbl_jobs
    WHERE id = id1;
END //
DELIMITER ;

-- Login
DELIMITER //
DELIMITER //

CREATE PROCEDURE usp_login(
    IN p_username VARCHAR(25),
    IN p_password VARCHAR(255)
)
BEGIN
    DECLARE storedPassword VARCHAR(255);
    
    -- Fetch the stored password for the provided username
    SELECT password INTO storedPassword
    FROM tbl_accounts
    WHERE username = p_username;
    
    IF storedPassword IS NULL THEN
        -- Username not found
        SELECT 'Login failed: Username not found' AS message;
    ELSEIF storedPassword = p_password THEN
        -- Successful login
        SELECT 'Login successful' AS message;
    ELSE
        -- Incorrect password
        SELECT 'Login failed: Incorrect password' AS message;
    END IF;
END //

DELIMITER ;

DELIMITER ;

-- Change Password
DELIMITER //
CREATE PROCEDURE usp_change_password(
    IN username VARCHAR(25),
    IN oldPassword VARCHAR(255),
    IN newPassword VARCHAR(255)
)
BEGIN
    DECLARE passwordMatch BIT;
    
    -- Check if the old password matches the stored password
    SET passwordMatch = fn_check_password(username, oldPassword);
    
    IF passwordMatch = 1 THEN
        -- Correct old password, update to new password
        UPDATE tbl_accounts
        SET password = newPassword
        WHERE username = username;
        
        SELECT 'Password change successful' AS message;
    ELSEIF passwordMatch = 0 THEN
        -- Incorrect old password
        SELECT 'Password change failed: Incorrect old password' AS message;
    ELSE
        -- Username not found
        SELECT 'Password change failed: Username not found' AS message;
    END IF;
END //
DELIMITER ;
-- Insert into tbl_regions
INSERT INTO tbl_regions (name)
VALUES 
    ('Asia'),
    ('Europe'),
    ('North America'),
    ('South America'),
    ('Africa');

-- Insert into tbl_countries
INSERT INTO tbl_countries (id, name, region)
VALUES 
    ('IDN', 'Indonesia', 1),
    ('USA', 'United States', 3),
    ('GER', 'Germany', 2),
    ('BRA', 'Brazil', 4),
    ('NGA', 'Nigeria', 5),
    ('JPN', 'Japan', 1),
    ('FRA', 'France', 2),
    ('CAN', 'Canada', 3),
    ('AUS', 'Australia', 1),
    ('CHN', 'China', 1);

-- Insert into tbl_locations
INSERT INTO tbl_locations (street_address, postal_code, city, state_province, country)
VALUES 
    ('Jl. Sudirman No. 1', '10220', 'Jakarta', 'DKI Jakarta', 'IDN'),
    ('1600 Amphitheatre Parkway', '94043', 'Mountain View', 'CA', 'USA'),
    ('Unter den Linden 77', '10117', 'Berlin', NULL, 'GER'),
    ('Av. Paulista, 1000', '01310-100', 'São Paulo', 'SP', 'BRA'),
    ('Lagos Island', '100001', 'Lagos', 'Lagos', 'NGA');

-- Insert into tbl_jobs
INSERT INTO tbl_jobs (id, title, min_salary, max_salary)
VALUES 
    ('J101', 'Software Engineer', 50000, 100000),
    ('J102', 'Data Scientist', 60000, 110000),
    ('J103', 'Product Manager', 70000, 120000),
    ('J104', 'UX/UI Designer', 55000, 105000),
    ('J105', 'DevOps Engineer', 58000, 108000);

-- Insert into tbl_departments
INSERT INTO tbl_departments (name, location)
VALUES 
    ('Engineering', 1),
    ('Sales', 2),
    ('Marketing', 3),
    ('Human Resources', 4),
    ('Finance', 5);

-- Insert into tbl_permissions
INSERT INTO tbl_permissions (name)
VALUES 
    ('View Reports'),
    ('Manage Users'),
    ('Approve Expenses');

-- Insert into tbl_roles
INSERT INTO tbl_roles (name)
VALUES 
    ('Administrator'),
    ('Manager'),
    ('Employee');

    
-- Insert into tbl_employees
INSERT INTO tbl_employees (first_name, last_name, gender, email, phone, hire_date, salary, manager, job, department)
VALUES 
    ('John', 'Doe', 'Male', 'john.doe@example.com', '123-456-7890', '2024-06-01', 60000, NULL, 'J101', 1),
    ('Jane', 'Smith', 'Female', 'jane.smith@example.com', '234-567-8901', '2024-06-01', 65000, 1, 'J102', 2),
    ('Michael', 'Brown', 'Male', 'michael.brown@example.com', '345-678-9012', '2024-06-01', 62000, 1, 'J103', 3),
    ('Emma', 'Johnson', 'Female', 'emma.johnson@example.com', '456-789-0123', '2024-06-01', 63000, 2, 'J104', 4),
    ('David', 'Williams', 'Male', 'david.williams@example.com', '567-890-1234', '2024-06-01', 61000, 2, 'J105', 5),
    ('Olivia', 'Miller', 'Female', 'olivia.miller@example.com', '678-901-2345', '2024-06-01', 64000, 3, 'J101', 1),
    ('Sophia', 'Davis', 'Female', 'sophia.davis@example.com', '789-012-3456', '2024-06-01', 63000, 3, 'J102', 2),
    ('Daniel', 'Martinez', 'Male', 'daniel.martinez@example.com', '890-123-4567', '2024-06-01', 62000, 4, 'J103', 3),
    ('Ethan', 'Garcia', 'Male', 'ethan.garcia@example.com', '901-234-5678', '2024-06-01', 61000, 4, 'J104', 4),
    ('Ava', 'Lopez', 'Female', 'ava.lopez@example.com', '012-345-6789', '2024-06-01', 65000, 5, 'J105', 5),
    ('Sophie', 'Moore', 'Female', 'sophie.moore@example.com', '123-456-7890', '2024-06-01', 62000, 5, 'J101', 1),
    ('William', 'Taylor', 'Male', 'william.taylor@example.com', '234-567-8901', '2024-06-01', 63000, 6, 'J102', 2),
    ('Chloe', 'Anderson', 'Female', 'chloe.anderson@example.com', '345-678-9012', '2024-06-01', 64000, 7, 'J103', 3),
    ('James', 'Thomas', 'Male', 'james.thomas@example.com', '456-789-0123', '2024-06-01', 65000, 8, 'J104', 4),
    ('Isabella', 'Wilson', 'Female', 'isabella.wilson@example.com', '567-890-1234', '2024-06-01', 66000, 9, 'J105', 5),
    ('Benjamin', 'Harris', 'Male', 'benjamin.harris@example.com', '678-901-2345', '2024-06-01', 67000, 10, 'J101', 1),
    ('Mia', 'Martin', 'Female', 'mia.martin@example.com', '789-012-3456', '2024-06-01', 68000, 1, 'J102', 2),
    ('Elijah', 'Thompson', 'Male', 'elijah.thompson@example.com', '890-123-4567', '2024-06-01', 69000, 2, 'J103', 3),
    ('Charlotte', 'Garcia', 'Female', 'charlotte.garcia@example.com', '901-234-5678', '2024-06-01', 70000, 3, 'J104', 4),
    ('Daniel', 'Martinez', 'Male', 'daniel.martinez@example.com', '012-345-6789', '2024-06-01', 71000, 4, 'J105', 5),
    ('Alexander', 'Robinson', 'Male', 'alexander.robinson@example.com', '123-456-7890', '2024-06-01', 72000, 5, 'J101', 1),
    ('Grace', 'Clark', 'Female', 'grace.clark@example.com', '234-567-8901', '2024-06-01', 73000, 6, 'J102', 2),
    ('Michael', 'Lewis', 'Male', 'michael.lewis@example.com', '345-678-9012', '2024-06-01', 74000, 7, 'J103', 3),
    ('Ava', 'Walker', 'Female', 'ava.walker@example.com', '456-789-0123', '2024-06-01', 75000, 8, 'J104', 4),
    ('Henry', 'Young', 'Male', 'henry.young@example.com', '567-890-1234', '2024-06-01', 76000, 9, 'J105', 5),
    ('Sofia', 'Allen', 'Female', 'sofia.allen@example.com', '678-901-2345', '2024-06-01', 77000, 10, 'J101', 1),
    ('Jack', 'Scott', 'Male', 'jack.scott@example.com', '789-012-3456', '2024-06-01', 78000, 1, 'J102', 2),
    ('Lily', 'Green', 'Female', 'lily.green@example.com', '890-123-4567', '2024-06-01', 79000, 2, 'J103', 3),
    ('Luke', 'Baker', 'Male', 'luke.baker@example.com', '901-234-5678', '2024-06-01', 80000, 3, 'J104', 4),
    ('Madison', 'Hill', 'Female', 'madison.hill@example.com', '012-345-6789', '2024-06-01', 81000, 4, 'J105', 5);
    
-- Insert into tbl_accounts
INSERT INTO tbl_accounts (id, username, password,email, otp, is_expired, is_used)
VALUES 
    (1, 'john', '123','john.doe@example.com', 123456, 0, NULL),
    (2, 'jane', '456','jane.smith@example.com', 789012, 0, NULL),
	(3, 'michael', 'jkl','michael.brown@example.com', 678901, 0, NULL);

    
-- Insert into tbl_account_roles
INSERT INTO tbl_account_roles (account, role)
VALUES 
    (1, 1), (2, 2);
-- Insert into tbl_payslip
INSERT INTO tbl_payslip (employee, salary_period, overtime)
VALUES 
    (1, '2024-06-01', 10),
    (2, '2024-06-01', 15),
    (3, '2024-06-01', 12),
    (4, '2024-06-01', 18),
    (5, '2024-06-01', 20),
    (6, '2024-06-01', 13),
    (7, '2024-06-01', 11),
    (8, '2024-06-01', 17),
    (9, '2024-06-01', 14),
    (10, '2024-06-01', 16),
     (11, '2024-06-01', 12),
    (12, '2024-06-01', 14),
    (13, '2024-06-01', 16),
    (14, '2024-06-01', 18),
    (15, '2024-06-01', 20),
    (16, '2024-06-01', 22),
    (17, '2024-06-01', 24),
    (18, '2024-06-01', 26),
    (19, '2024-06-01', 28),
    (20, '2024-06-01', 30);


CREATE VIEW vw_employee_salary AS
SELECT
    e.id AS id,
    p.salary_period AS salary_period,
    CONCAT(e.first_name, ' ', e.last_name) AS full_name,
    p.overtime AS total_overtime,
    e.salary AS base_salary,
    (0.015 * e.salary * p.overtime) AS overtime_salary,
    (e.salary * 0.1) AS pph,
    (e.salary + (0.015 * e.salary * p.overtime) - (e.salary * 0.1)) AS total_salary
FROM 
    tbl_employees e
JOIN 
    tbl_payslip p ON e.id = p.employee;

SELECT * FROM vw_employee_salary;
