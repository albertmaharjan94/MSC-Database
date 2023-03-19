-- Part B : SQL programming
--- PENSION SCHEME TABLE
CREATE TABLE pension_schemes 
( 
    scheme_id VARCHAR2(10) CONSTRAINT pension_scheme_scheme_pk PRIMARY KEY, 
    name VARCHAR2(100) CONSTRAINT pension_scheme_not_null NOT NULL, 
    rate NUMBER(2, 1)
);

INSERT ALL
    INTO pension_schemes VALUES ('S110', 'AXA', 0.5)
    INTO pension_schemes VALUES ('S121', 'Premier', 0.6)
    INTO pension_schemes VALUES ('S124', 'Stakeholder', 0.4)
    INTO pension_schemes VALUES ('S116', 'Standard', 0.4)
SELECT 1 from dual;

SELECT * from pension_schemes;

--- SALARY GRADES TABLE
CREATE TABLE salary_grades 
( 
    salary_code VARCHAR2(10) CONSTRAINT salary_grade_pk PRIMARY KEY, 
    start_salary NUMBER(10), 
    finish_salary NUMBER(10) 
);

INSERT ALL
    INTO salary_grades VALUES ('S1', 15000, 18000)
    INTO salary_grades VALUES ('S2', 18001, 22000)
    INTO salary_grades VALUES ('S3', 22001, 25000)
    INTO salary_grades VALUES ('S4', 25001, 29000)
    INTO salary_grades VALUES ('S5', 29001, 38000)
SELECT 1 from dual;

SELECT * from salary_grades;

--- DEPARTMENT TABLE
CREATE TABLE departments 
( 
    dept_id VARCHAR2(10) CONSTRAINT department_dept_pk PRIMARY KEY, 
    name VARCHAR2(100)
);

INSERT ALL
    INTO departments VALUES ('D10', 'Administration')
    INTO departments VALUES ('D20', 'Finance')
    INTO departments VALUES ('D30', 'Sales')
    INTO departments VALUES ('D40', 'Maintenance')
    INTO departments VALUES ('D50', 'IT Support')
SELECT 1 from dual;

SELECT * from departments;

--- EMPLOYEE TABLE
CREATE TABLE employees 
(
    emp_id VARCHAR2(10) CONSTRAINT employee_pk PRIMARY KEY, 
    name VARCHAR2(100),
    address VARCHAR2(100),
    dob DATE CONSTRAINT employee_dob_nn NOT NULL, 
    job VARCHAR2(100),
    salary_code VARCHAR2(10),
    dept_id VARCHAR2(10),
    manager VARCHAR2(10) NULL, 
    scheme_id VARCHAR2(10),
    CONSTRAINT employee_salary_fk FOREIGN KEY (salary_code) REFERENCES salary_grades, 
    CONSTRAINT employee_dept_fk FOREIGN KEY (dept_id) REFERENCES departments,
    CONSTRAINT employee_scheme_fk FOREIGN KEY (scheme_id) REFERENCES pension_schemes,
    CONSTRAINT employee_tree_fk FOREIGN KEY (manager) REFERENCES employees DEFERRABLE INITIALLY DEFERRED
);

INSERT ALL
    INTO employees VALUES ('E101', 'Young, S.', '199 London Road', TO_DATE('05/03/76', 'DD/MM/YY'), 'Clerk', 'S1', 'D10', 'E110', 'S116')
    INTO employees VALUES ('E301', 'April, H.', '20 Glade close', TO_DATE('10/03/79', 'DD/MM/YY'), 'Sales Person', 'S2', 'D30', 'E310', 'S124')
    INTO employees VALUES ('E310', 'Newgate, E.', '10 Heap street', TO_DATE('28/11/80', 'DD/MM/YY'), 'Manager', 'S5', 'D30', null, 'S121')
    INTO employees VALUES ('E501', 'Teach, E.', '22 railway road', TO_DATE('12/02/72', 'DD/MM/YY'), 'Analyst', 'S5', 'D50', null, 'S121')
    INTO employees VALUES ('E102', 'Hawkings, M.', '3 High Street', TO_DATE('13/07/74', 'DD/MM/YY'), 'Clerk', 'S1', 'D10', 'E110', 'S116')
    INTO employees VALUES ('E110', 'Watkins, j.', '11 crescent road', TO_DATE('25/06/69', 'DD/MM/YY'), 'Manager', 'S5', 'D10', null, 'S121')
    INTO employees VALUES ('E505', 'Martin, R.', '14 Harrington road', TO_DATE('11/11/74', 'DD/MM/YY'), 'Vice President', 'S5', 'D10', null, 'S124')
SELECT 1 from dual;

SELECT * from employees;

--- B-2-a
--- The name (in ascending order), the starting salary and department id of each employee within a 
--- descending order of department ids.
SELECT  emp.dept_id , emp.name, sg.start_salary
FROM employees  emp
JOIN salary_grades sg USING (salary_code)
ORDER BY dept_id DESC, name ASC;

--- B-2-b
--- Give the number of employees for each of the pension schemes offered by the company. Result
--- listing should include the name of each scheme and its corresponding number of employees
--- who join the scheme.
SELECT ps.name, COUNT(emp.scheme_id) as num_of_employees
FROM employees emp
RIGHT JOIN pension_schemes ps ON ps.scheme_id = emp.scheme_id
GROUP BY ps.Name;

--- B-2-c
--- Give the total number of employees who are not managers but currently receive an annual
--- salary of over �35,000.
SELECT COUNT(*) as num_of_employees
FROM employees emp
JOIN salary_grades sg USING (salary_code)
WHERE emp.job != 'Manager' AND sg.finish_salary > 35000;


--- B-2-d
-- List the id and name of each employee along with his/her manager�s name.
SELECT emp.emp_id, emp.name, mng.name as manager_name
FROM employees emp
LEFT JOIN employees mng ON emp.manager = mng.emp_id;


-- Part C : Sequential and distributed processing
CREATE TABLE order_items (
    order_item_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    order_no NUMBER(5),
    product_no NUMBER(10),
    price NUMBER(10,2),
    quantity NUMBER(5),
    sales NUMBER(10,2),
    qtr_id NUMBER(1),
    month_id NUMBER(2),
    year_id NUMBER(4)
);

INSERT INTO order_items (order_no, product_no, price, quantity, sales, qtr_id, month_id, year_id) VALUES (10107, 2, 85.7, 30, 2587, 1, 2, 2003);
INSERT INTO order_items (order_no, product_no, price, quantity, sales, qtr_id, month_id, year_id) VALUES (10107, 5, 95.8, 39, 3879.49, 1, 2, 2003);
INSERT INTO order_items (order_no, product_no, price, quantity, sales, qtr_id, month_id, year_id) VALUES (10121, 5, 71.5, 34, 2700, 1, 2, 2003);
INSERT INTO order_items (order_no, product_no, price, quantity, sales, qtr_id, month_id, year_id) VALUES (10134, 2, 94.74, 41, 3884.34, 3, 7, 2004);
INSERT INTO order_items (order_no, product_no, price, quantity, sales, qtr_id, month_id, year_id) VALUES (10134, 5, 100, 27, 3307.77, 3, 7, 2004);
INSERT INTO order_items (order_no, product_no, price, quantity, sales, qtr_id, month_id, year_id) VALUES (10159, 14, 100, 49, 5205.27, 4, 10, 2005);
INSERT INTO order_items (order_no, product_no, price, quantity, sales, qtr_id, month_id, year_id) VALUES (10168, 1, 96.66, 36, 3479.66, 4, 10, 2006);
INSERT INTO order_items (order_no, product_no, price, quantity, sales, qtr_id, month_id, year_id) VALUES (10180, 12, 100, 42, 4695.6, 4, 11, 2006);

SELECT * from order_items;

--- C-1
-- Assuming that the data is stored in a relational database produce, with justification, the SQL code to
-- determine, for each product, the number of products which were sold in each month of each year.
SELECT product_no, month_id, year_id, SUM(quantity) AS total_product_sales
FROM order_items
GROUP BY product_no, year_id, month_id
ORDER BY month_id ASC, year_id ASC;
