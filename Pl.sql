-- 1. Create the employees table
CREATE TABLE employees (
    employee_id INT,
    name VARCHAR(50),
    department VARCHAR(50),
    salary INT,
    hire_date DATE
);

-- 2. Insert sample data with Kinyarwanda names
INSERT INTO employees VALUES 
(1, 'Niyonzima', 'Finance', 800000, TO_DATE('2020-01-15', 'YYYY-MM-DD')),
(2, 'Uwase', 'Finance', 750000, TO_DATE('2021-06-12', 'YYYY-MM-DD')),
(3, 'Habimana', 'Finance', 900000, TO_DATE('2019-03-08', 'YYYY-MM-DD')),
(4, 'Mugisha', 'IT', 950000, TO_DATE('2018-07-22', 'YYYY-MM-DD')),
(5, 'Ingabire', 'IT', 850000, TO_DATE('2021-01-30', 'YYYY-MM-DD')),
(6, 'Tuyishime', 'IT', 800000, TO_DATE('2020-10-10', 'YYYY-MM-DD')),
(7, 'Uwimana', 'HR', 700000, TO_DATE('2020-04-14', 'YYYY-MM-DD')),
(8, 'Ishimwe', 'HR', 720000, TO_DATE('2021-08-01', 'YYYY-MM-DD'));

-- 3. Compare Salaries Using LAG() and LEAD()
SELECT 
    name, department, salary,
    LAG(salary) OVER (ORDER BY salary) AS previous_salary,
    LEAD(salary) OVER (ORDER BY salary) AS next_salary,
    CASE 
        WHEN salary > LAG(salary) OVER (ORDER BY salary) THEN 'HIGHER'
        WHEN salary < LAG(salary) OVER (ORDER BY salary) THEN 'LOWER'
        ELSE 'EQUAL'
    END AS comparison_with_previous
FROM employees;

-- 4. Rank Within Departments Using RANK and DENSE_RANK
SELECT 
    name, department, salary,
    RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS rank_method,
    DENSE_RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS dense_rank_method
FROM employees;

-- 5. Top 3 Paid Employees Per Department
SELECT *
FROM (
    SELECT *, 
           RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS rnk
    FROM employees
)
WHERE rnk <= 3;

-- 6. First 2 Employees Per Department (based on hire_date)
SELECT *
FROM (
    SELECT *, 
           ROW_NUMBER() OVER (PARTITION BY department ORDER BY hire_date ASC) AS row_num
    FROM employees
)
WHERE row_num <= 2;

-- 7. Maximum Salary Per Department and Overall
SELECT 
    name, department, salary,
    MAX(salary) OVER (PARTITION BY department) AS max_per_department,
    MAX(salary) OVER () AS overall_max
FROM employees;
