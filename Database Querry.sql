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
    email VARCHAR(25),
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
    IN id INT,
    IN name VARCHAR(30),
    IN location INT
)
BEGIN
    UPDATE tbl_departments
    SET name = name,
        location = location
    WHERE id = id;
END //
DELIMITER ;

-- Delete Department
DELIMITER //
CREATE PROCEDURE usp_delete_department(
    IN id INT
)
BEGIN
    DELETE FROM tbl_departments
    WHERE id = id;
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
    IN id INT,
    IN name VARCHAR(25)
)
BEGIN
    UPDATE tbl_regions
    SET name = name
    WHERE id = id;
END //
DELIMITER ;

-- Delete Region
DELIMITER //
CREATE PROCEDURE usp_delete_region(
    IN id INT
)
BEGIN
    DELETE FROM tbl_regions
    WHERE id = id;
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
    IN id INT,
    IN name VARCHAR(50)
)
BEGIN
    UPDATE tbl_roles
    SET name = name
    WHERE id = id;
END //
DELIMITER ;

-- Delete Role
DELIMITER //
CREATE PROCEDURE usp_delete_roles(
    IN id INT
)
BEGIN
    DELETE FROM tbl_roles
    WHERE id = id;
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
    IN id INT,
    IN name VARCHAR(100)
)
BEGIN
    UPDATE tbl_permissions
    SET name = name
    WHERE id = id;
END //
DELIMITER ;

-- Delete Permission
DELIMITER //
CREATE PROCEDURE usp_delete_permission(
    IN id INT
)
BEGIN
    DELETE FROM tbl_permissions
    WHERE id = id;
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
    IN id INT,
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
    WHERE id = id;
END //
DELIMITER ;

-- Delete Location
DELIMITER //
CREATE PROCEDURE usp_delete_location(
    IN id INT
)
BEGIN
    DELETE FROM tbl_locations
    WHERE id = id;
END //
DELIMITER ;

-- Add Country
DELIMITER //
CREATE PROCEDURE usp_add_country(
    IN id CHAR(3),
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
    IN id CHAR(3),
    IN name VARCHAR(40),
    IN region INT
)
BEGIN
    UPDATE tbl_countries
    SET name = name,
        region = region
    WHERE id = id;
END //
DELIMITER ;

-- Delete Country
DELIMITER //
CREATE PROCEDURE usp_delete_country(
    IN id CHAR(3)
)
BEGIN
    DELETE FROM tbl_countries
    WHERE id = id;
END //
DELIMITER ;

-- Add Jobs
DELIMITER //
CREATE PROCEDURE usp_add_jobs(
    IN id VARCHAR(10),
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
    IN id VARCHAR(10),
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
        WHERE id = id;
    ELSE
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'The max salary must be greater than the min salary';
    END IF;
END //
DELIMITER ;

-- Delete Jobs
DELIMITER //
CREATE PROCEDURE usp_delete_jobs(
    IN id VARCHAR(10)
)
BEGIN
    DELETE FROM tbl_jobs
    WHERE id = id;
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
VALUES ('Asia');

-- Insert into tbl_countries
INSERT INTO tbl_countries (id, name, region)
VALUES ('IDN', 'Indonesia', 1);

-- Insert into tbl_locations
INSERT INTO tbl_locations (street_address, postal_code, city, state_province, country)
VALUES ('Jl. Sudirman No. 1', '10220', 'Jakarta', 'DKI Jakarta', 'IDN');

-- Insert into tbl_jobs
INSERT INTO tbl_jobs (id, title, min_salary, max_salary)
VALUES ('J101', 'Software Engineer', 50000, 100000);

INSERT INTO tbl_jobs (id, title, min_salary, max_salary)
VALUES ('J102', 'Softwaree Engineer', 50000, 100000);

-- Insert into tbl_departments
INSERT INTO tbl_departments (name, location)
VALUES ('Engineering', 1);

-- Insert into tbl_employees
INSERT INTO tbl_employees (first_name, last_name, gender, email, phone, hire_date, salary, manager, job, department)
VALUES ('John', 'Doe', 'Male', 'john.doe@example.com', '123-456-7890', '2024-06-01', 60000, NULL, 'J101', 1);
INSERT INTO tbl_employees (first_name, last_name, gender, email, phone, hire_date, salary, manager, job, department)
VALUES ('John', 'Doe', 'Male', 'johndoe@example.com', '123-456-7890', '2024-06-01', 60000, NULL, 'J101', 1);

-- Insert into tbl_permissions
INSERT INTO tbl_permissions (name)
VALUES ('View Reports');

-- Insert into tbl_roles
INSERT INTO tbl_roles (name)
VALUES ('Administrator');

-- Insert into tbl_role_permissions
INSERT INTO tbl_role_permissions (role, permission)
VALUES (1, 1);  -- Assuming the role ID is 1 and the permission ID is 1

-- Insert into tbl_accounts
INSERT INTO tbl_accounts (id,username, password, otp, is_expired, is_used)
VALUES (1,'john', '123', 123456, 0, NULL);

-- Insert into tbl_account_roles
INSERT INTO tbl_account_roles (account, role)
VALUES (1, 1);  -- Assuming the account ID is 1 and the role ID is 1

-- Insert into tbl_payslip
INSERT INTO tbl_payslip (employee, salary_period, overtime)
VALUES (1, '2024-06-01', 10);  -- Assuming the employee ID is 1

