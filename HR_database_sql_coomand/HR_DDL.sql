/* Following DDL SQL commands will help  to create HR database */

/* Creating Education table (primary key - edu_id) */

CREATE table Education(
    edu_id SERIAL primary key,
    edu_level varchar(50)
);

/* Creating Employee table (primary key - employee_id and Forigen_key - edu_id) */

CREATE table Employee(
    employee_id varchar(8) primary key,
    employee_name varchar(50),
    email varchar(50),
    hire_date date,
    edu_id int references Education(edu_id)
);


/* Creating Job table (primary key - job_id) */

CREATE table Job(
    job_id serial primary key,
    job_title varchar(50)
);


/* Creating Department table (primary key - dep_id) */

CREATE table Department(
    dep_id serial primary key,
    dep_name varchar(50)
);


/* Creating Location table (primary key - location_id) */

CREATE table Location(
    location_id serial primary key,
    location varchar(50),
    city VARCHAR(50),
    state VARCHAR(50),
    address VARCHAR(100)
);


/* Creating Salary table (primary key - salary id) */
   
CREATE table Salary(
    salary_id serial primary key,
    salary int
);


/* Creating Employment table as there is 
   many to many relationship across emp_id and 
   job_id. So this table acts as pivot point */
   
CREATE table Employment(
    employee_id varchar(8) references Employee(employee_id),
    job_id int references Job(job_id),
    dep_id int references Department(dep_id),
    manager_id varchar(8) references Employee(employee_id),
    location_id int references Location(location_id),
    start_date date,
    end_date date,
    salary_id int references Salary(salary_id),
    primary key(employee_id, job_id)
);
