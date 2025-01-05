Use hr;

-- 1. Write a query to display the names (first_name, last_name) using alias name “First Name", "Last
-- Name"
Select first_name As "First Name",last_name AS "Last Name" from employees;

-- 2. Write a query to get unique department ID from employee table
Select Distinct(department_id) AS "Department ID" from employees
where department_id is not null ;

-- 3. Write a query to get all employee details from the employee table order by first name, descending
Select * from employees 
where employee_id is not null
order by first_name desc;

-- 4. Write a query to get the names (first_name, last_name), salary, PF of all the employees (PF is
-- calculated as 15% of salary)
Select Concat(first_name," ",last_name) AS Name , Salary, Round((Salary*0.15),1) As PF from employees;


-- 5. Write a query to get the employee ID, names (first_name, last_name), salary in ascending order of
-- salary
Select employee_id, Concat(first_name," ",last_name) AS Name,salary from employees 
order by salary;

-- 6. Write a query to get the total salaries payable to employees
select Sum(salary) As Salary from employees;

-- 7. Write a query to get the maximum and minimum salary from employees table
Select max(salary) As "Maximum Salary", min(Salary) As "Minimum Salary" from employees;

-- 8. Write a query to get the average salary and number of employees in the employees table
Select count(employee_id) As employees, Round(AVG(Salary),2) As "AVG Salary" from employees;

-- 9. Write a query to get the number of employees working with the company
Select count(*) from employees;

-- 10. Write a query to get the number of jobs available in the employees table
Select count(Distinct(job_id)) from employees;

-- 11. Write a query get all first name from employees table in upper case
Select Upper(first_name) As 'First Name' from Employees;

-- 12. Write a query to get the first 3 characters of first name from employees table
Select substr(first_name,1,3) As 'Firstname' from employees;

-- 13. Write a query to get first name from employees table after removing white spaces from both side
Select Trim(first_name) from employees;

-- 14. Write a query to get the length of the employee names (first_name, last_name) from employees table
Select Length(Concat(first_name,"",last_name)) As NamesLen from employees;


-- 15. Write a query to check if the first_name fields of the employees table contains numbers
Select * from employees where first_name regexp(0-9);

-- 16. Write a query to display the name (first_name, last_name) and salary for all employees whose salary is
-- not in the range $10,000 through $15,000
Select concat(first_name,"",last_name) As NAME ,salary from employees where salary not between 10000 and 15000;

-- 17. Write a query to display the name (first_name, last_name) and department ID of all employees in
-- departments 30 or 100 in ascending order
Select concat(first_name,"",last_name) As NAME,department_id from employees 
where department_id in (30,100) 
order by Name;

-- 18. Write a query to display the name (first_name, last_name) and salary for all employees whose salary is
-- not in the range $10,000 through $15,000 and are in department 30 or 100
Select concat(first_name,"",last_name) As NAME ,salary from employees 
where salary not between 10000 and 15000  and 
department_id in(30,100);

-- 19. Write a query to display the name (first_name, last_name) and hire date for all employees who were
-- hired in 1987
Select concat(first_name,"",last_name) As NAME ,hire_date from employees
 where Year(hire_date)=1987;

-- 20. Write a query to display the first_name of all employees who have both "b" and "c" in their first name
Select first_name from employees
where first_name like '%b%' and first_name like '%c%';

-- 21. Write a query to display the last name, job, and salary for all employees whose job is that of a
-- Programmer or a Shipping Clerk, and whose salary is not equal to $4,500, $10,000, or $15,000
Select e.last_name,j.job_title as job,e.salary as salary from employees e 
Join jobs j 
on e.job_id=j.job_id
where job_title in('Programmer','Shipping Clerk')  and  salary not in('4500','10000','15000');

-- 22. Write a query to display the last name of employees whose names have exactly 6 characters
Select last_name from employees where last_name like "______";

-- 23. Write a query to display the last name of employees having 'e' as the third character
Select last_name from employees where last_name like "__e%";

-- 24. Write a query to get the job_id and related employee's id
-- Partial output of the query :
-- job_id Employees ID
-- AC_ACCOUNT206
-- AC_MGR 205
-- AD_ASST 200
-- AD_PRES 100
-- AD_VP 101 ,102
-- FI_ACCOUNT 110 ,113 ,111 ,109 ,112

select job_id,group_concat(employee_id) as employee_id  from employees
group by job_id;


-- 25. Write a query to update the portion of the phone_number in the employees table, within the phone
-- number the substring '124' will be replaced by '999'
Select replace(phone_number,'124','999') As Phone_number from employees 
where phone_number like '%124%';

Select phone_number As Phone_number from employees 
where phone_number like '%124%';

-- 26. Write a query to get the details of the employees where the length of the first name greater than or
-- equal to 8
Select first_name from employees where length(first_name)>=8;

-- 27. Write a query to append '@example.com' to email field
Select concat(email,'@example.com') as email from employees;

-- 28. Write a query to extract the last 4 character of phone numbers
select substr(phone_number,-4) as Phonenumber from employees; 

-- 29. Write a query to get the last word of the street address
select substr(street_address,length(street_address)) from locations;

-- 30. Write a query to get the locations that have minimum street length
select street_address from locations
where length(street_address)= (Select  min(length(street_address)) from locations);


-- 31. Write a query to display the first word from those job titles which contains more than one 
SELECT first_name,count(job_id)
FROM employees
WHERE job_id IN (
    SELECT job_id
    FROM employees
    GROUP BY job_id
    HAVING COUNT(job_id) > 1
)GROUP BY job_id
;

Select SUBSTR(job_title, 1, INSTR(job_title, ' ') - 1) AS Title,job_title from jobs;




-- 32. Write a query to display the length of first name for employees where last name contain character 'c'
-- after 2nd position
Select length(first_name) as First_name,last_name from employees where last_name like'__%c%';

-- 33. Write a query that displays the first name and the length of the first name for all employees whose
-- name starts with the letters 'A', 'J' or 'M'. Give each column an appropriate label. Sort the results by the
-- employees' first names

Select first_name, length(first_name) "length" from employees 
where
first_name REGEXP '^[AJM]'
order by first_name;

-- 34. Write a query to display the first name and salary for all employees. Format the salary to be 10
-- characters long, left-padded with the $ symbol. Label the column SALARY

Select first_name,lpad(salary,10,"$") As SALARY from employees; 


-- 35. Write a query to display the first eight characters of the employees' first names and indicates the
-- amounts of their salaries with '$' sign. Each '$' sign signifies a thousand dollars. Sort the data in
-- descending order of salary
select substr(first_name,1,8),REPEAT('$', FLOOR(salary / 1000)) AS 'salary$' from employees
order by salary desc;


-- 36. Write a query to display the employees with their code, first name, last name and hire date who hired
-- either on seventh day of any month or seventh month in any year
Select employee_id,first_name,last_name,hire_date from employees
where day(hire_date)=7 or month(hire_date)=7 ;
