/* insert Education table */

insert into Education(edu_level)
    select DISTINCT education_lvl
    from proj_stg;


/* Populating Employee table */

insert into Employee(employee_id, employee_name, email, hire_date, edu_id)
    select DISTINCT s.Emp_ID, s.Emp_NM, s.Email, s.hire_dt, ed.edu_id
    from proj_stg as s
    join Education as ed
    on s.education_lvl = ed.edu_level;
    
    
/* Populating Job table */    
    
insert into Job(job_title)
    select DISTINCT job_title
    from proj_stg;
    
    
/* Populating Department table */
    
insert into Department(dep_name)
    select DISTINCT department_nm
    from proj_stg;
    

/* Populating Location table */

insert into Location(location,city,state,address)
    select DISTINCT location,city,state,address
    from proj_stg;
    
    
    
/* Populating Salary table */

insert into Salary(salary)
    select DISTINCT salary
    from proj_stg;
    
    
/* Populating Employment table */
    
insert into Employment(employee_id, job_id, dep_id, manager_id, start_date, end_date, location_id, salary_id)
    select emp.employee_id, job.job_id, dep.dep_id, 
           (SELECT employee_id from Employee WHERE employee_name = s.manager),
           s.start_dt, s.end_dt,l.location_id,sal.salary_id
    from proj_stg as s
    join Employee as emp
    on s.Emp_ID = emp.employee_id
    join Job as job
    on s.job_title = job.job_title
    join Department as dep
    on s.Department_nm = dep.dep_name
    join Location as l
    on s.location = l.location and s.state=l.state and s.city=l.city and s.address=l.address
    join Salary as sal
    on s.salary = sal.salary;
    
