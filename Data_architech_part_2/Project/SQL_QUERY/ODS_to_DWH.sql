USE DATABASE "yelp_db";
USE SCHEMA "YELP_DB"."DWH";

/*SQL queries code to move data from ODS to DWH*/

CREATE TABLE dim_user CLONE "YELP_DB"."ODS".user ;


/*create dim_review table*/

CREATE TABLE dim_review (
	review_id VARIANT PRIMARY KEY,
	cool NUMBER,
	funny NUMBER,
	text STRING,
	useful NUMBER,
)

INSERT INTO dim_review (review_id,cool,funny,text,useful)
SELECT r.review_id,r.cool,r.funny,r.text,r.useful 
FROM "YELP_DB"."ODS".review;

/* create climate table*/
Create table dim_climate(
	climate_date string PRIMARY KEY,
	min_t INT,
	max_t INT,
	normal_min FLOAT,
	normal_max FLOAT,
	precipitation FLOAT,
	precipitation_normal FLOAT
);

Insert into dim_climate(climate_date,min_t,max_t,normal_max,normal_min,precipitation,precipitation_normal)
select p.climate_date,min_t,max_t,normal_max,normal_min,precipitation,precipitation_normal from 
"YELP_DB"."ODS".precipitation as p
join "YELP_DB"."ODS".temperature as t on p.date_t=p.date_t;

/* create dim_business table*/

CREATE TABLE dim_business (
	business_id VARCHAR(200) PRIMARY KEY,
	name TEXT,
	address TEXT,
	city TEXT,
	state TEXT,
	postal_code VARCHAR(20),
	latitude FLOAT,
	longitude FLOAT,
	stars FLOAT,
	review_count NUMBER(38,0),
	is_open NUMBER(38,0),
	attribute OBJECT,
	categories TEXT,
	hours VARIANT,
	checkin_date    TEXT,
    covid_highlights  TEXT,
	covid_delivery_or_takeout  TEXT,
    covid_grubhub_enabled   TEXT,
    covid_call_to_action_enabled    TEXT,
    covid_request_a_quote_enabled   TEXT,
    covid_banner                    TEXT,
    covid_temporary_closed_until    TEXT,
    covid_virtual_services_offered  TEXT
	);
INSERT INTO dim_business(business_id,
	name ,
	address ,
	city 
	state ,
	postal_code ,
	latitude ,
	longitude ,
	stars ,
	review_count ,
	is_open ,
	attribute ,
	categories ,
	hours VARIANT,
	checkin_date    ,
    covid_highlights  ,
	covid_delivery_or_takeout  ,
    covid_grubhub_enabled   ,
    covid_call_to_action_enabled    ,
    covid_request_a_quote_enabled   ,
    covid_banner                    ,
    covid_temporary_closed_until    ,
    covid_virtual_services_offered) 
	select b.* , ch.date,
        co.highlights,
        co.delivery_or_takeout,
        co.grubhub_enabled,
        co.call_to_action_enabled,
        co.request_a_quote_enabled,
        co.covid_banner,
        co.temporary_closed_until,
        co.virtual_services_offered from 
		FROM "YELP_DB"."ODS".business AS b
		LEFT JOIN "YELP_DB"."ODS".checkin AS ch ON b.business_id=ch.business_id
		LEFT JOIN "YELP_DB"."ODS".covid AS co ON b.business_id=co.business_id;


/* create fact table */
CREATE TABLE fact_info(
  business_id VARIANT ,
  review_id VARIANT,
  user_id VARIANT,
  climate_date String,
  stars FLOAT,
  CONSTRAINT FK_US_ID FOREIGN KEY(user_id)        REFERENCES  dim_user(user_id),
  CONSTRAINT FK_BU_ID FOREIGN KEY(business_id)    REFERENCES  dim_business(business_id),
  CONSTRAINT FK_CL_ID FOREIGN KEY(climate_date)        REFERENCES  dim_climate(climate_date)
  );

Insert into fact_info (business_id, review_id, user_id,climate_date,stars) SELECT b.business_id, r.review_id, u.user_id, cli.climate_date,r.stars
	FROM dim_review AS r 
	JOIN dim_climate AS cli
	ON cli.climate_date = r.date
	JOIN dim_business AS b
	ON b.business_id = r.business_id
    JOIN dim_user AS u
    ON u.user_id = r.user_id;