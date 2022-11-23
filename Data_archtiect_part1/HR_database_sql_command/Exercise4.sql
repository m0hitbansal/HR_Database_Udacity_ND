/*Q1 Create a view that returns all employee attributes; results should resemble initial Excel file
*/

CREATE VIEW base_table AS SELECT e.employee_id as emp_id,
	e.employee_name as emp_nm,
	e.email,
	e.hire_date as hire_dt,
	j.job_title,
	sal.salary,
	d.dep_name as department_nm,
	(SELECT employee_name from Employee WHERE employee_id = s.manager_id) as manager,
	s.start_date as start_dt,
	s.end_date as end_dt,
	l.location,
	l.address,
	l.city,
	l.state,
	edu.edu_level as education_lvl
FROM employee AS e
JOIN employment AS s
ON e.employee_id = s.employee_id
JOIN salary AS sal
ON s.salary_id = sal.salary_id
JOIN location AS l
ON s.location_id = l.location_id
JOIN job AS j
ON s.job_id= j.job_id
JOIN department AS d
ON d.dep_id=s.dep_id
JOIN education AS edu
ON edu.edu_id = e.edu_id;


/*Create a stored procedure with parameters that returns current and past jobs (include employee name, job title, department, manager name, start and end date for position) when given an employee name.
*/
CREATE Procedure employee_info(name VARCHAR)
AS $BODY$
	select emp.employee_name,j.job_title,d.dep_name,
    (select employee_name from employee where employee_id=e.manager_id) as manager,
    e.start_date,e.end_date
    from Employment as e
    join employee as emp on emp.employee_id=e.employee_id
    join job as j on e.job_id=j.job_id
    join department as d on d.dep_id=e.dep_id
    where emp.employee_name=name;
$BODY$
LANGUAGE SQL;

/* create user and privileges*/
	
CREATE USER NoMgr;
GRANT SELECT ON employee,location,department,employment,education,job TO NoMgr;
revoke SELECT ON salary from NoMgr;
	


