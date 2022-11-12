/* Question 1: Return a list of employees with Job Titles and Department Names */

select emp.employee_name,j.job_title,d.dep_name 
from Employment as e
join employee as emp on e.employee_id=emp.employee_id
join job as j on e.job_id=j.job_id
join department as d on e.dep_id=d.dep_id;

    
/* Question 2: Insert Web Programmer as a new job title */

insert into Job (job_title)
    values ('Web Programmer');
    
    
/* Question 3: Correct the job title from web programmer to web developer */

update job
    SET job_title = 'Web Developer'
    WHERE job_title = 'Web Programmer';
    
    
/* Question 4: Delete the job title Web Developer from the database */

delete from job
    WHERE job_title = 'Web Developer';
    
    
/* Question 5: How many employees are in each department? */

select d.dep_name, count(employee_id)
from Employment as e
join Department as d on e.dep_id=d.dep_id
group by d.dep_name;
        
/* Question 6: Write a query that returns current and past jobs (include 
   employee name, job title, department, manager name, start and end date 
   for position) for employee Toni Lembeck. */
   
select emp.employee_name,j.job_title,d.dep_name,
    (select employee_name from employee where employee_id=e.manager_id),
    e.start_date,e.end_date
from Employment as e
join employee as emp on emp.employee_id=e.employee_id
join job as j on e.job_id=j.job_id
join department as d on d.dep_id=e.dep_id
where emp.employee_name='Toni Lembeck';
