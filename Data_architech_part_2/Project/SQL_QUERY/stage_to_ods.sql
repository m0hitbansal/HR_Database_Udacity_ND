/*CREATION OF TABLE IN ODS AND TRANSFORM/TRANSFER THE RAW DATA FROM STAGING TO ODS*/
USE DATABASE "yelp_db";
USE SCHEMA "YELP_DB"."ODS";


/* 2. Business table ODS */

CREATE TABLE business (
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
	hours VARIANT);
	
INSERT INTO business(business_id,name, address, city, state, postal_code, latitude,longitude,stars, review_count, is_open, attribute, categories, hours)
SELECT parse_json($1):business_id,
			parse_json($1):name,
			parse_json($1):address,
			parse_json($1):city,
			parse_json($1):state,
			parse_json($1):postal_code,
			parse_json($1):latitude,
			parse_json($1):longitude,
			parse_json($1):stars,
			parse_json($1):review_count,
			parse_json($1):is_open,
			parse_json($1):attribute,
			parse_json($1):categories,
			parse_json($1):hours
	FROM "YELP_DB"."STAGING".business_stg;


/* 3. User table ODS */

CREATE TABLE user (
	user_id VARCHAR PRIMARY KEY,
	average_stars FLOAT,
	compliment_cool NUMBER,
	compliment_cute NUMBER,
	compliment_funny NUMBER,
	compliment_hot NUMBER,
	compliment_list NUMBER,
	compliment_more NUMBER,
	compliment_note NUMBER,
	compliment_photos NUMBER,
	compliment_plain NUMBER,
	compliment_profile NUMBER,
	compliment_writer NUMBER,
	cool NUMBER,
	elite STRING,
	fans NUMBER,
	friends VARIANT,
	funny NUMBER,
	name VARCHAR,
	review_count NUMBER,
	useful NUMBER,
	yelping_since STRING);
	

INSERT INTO user(average_stars,compliment_cool,compliment_cute,compliment_funny,compliment_hot,compliment_list,compliment_more,
compliment_note,compliment_photos,compliment_plain,compliment_profile,compliment_writer,cool,elite, fans,friends, funny,name, review_count, useful,user_id,yelping_since)
SELECT parse_json($1):average_stars,
	parse_json($1):compliment_cool,
	parse_json($1):compliment_cute,
	parse_json($1):compliment_funny,
	parse_json($1):compliment_hot,
	parse_json($1):compliment_list,
	parse_json($1):compliment_more,
	parse_json($1):compliment_note,
	parse_json($1):compliment_photos,
	parse_json($1):compliment_plain,
	parse_json($1):compliment_profile,
	parse_json($1):compliment_writer,
	parse_json($1):cool,
	parse_json($1):elite, 
	parse_json($1):fans,
	parse_json($1):friends, 
	parse_json($1):funny,
	parse_json($1):name, 
	parse_json($1):review_count, 
	parse_json($1):useful,
	parse_json($1):user_id,
	parse_json($1):yelping_since
	FROM "YELP_DB"."STAGING".user_stg;
	

/* 1. tip table ODS */

CREATE TABLE tip (
	business_id STRING,
	compliment_count INTEGER,
	date STRING,
	text STRING,
	user_id STRING,
	CONSTRAINT FK_US_ID FOREIGN KEY(user_id)        REFERENCES  user(user_id),
	CONSTRAINT FK_BU_ID FOREIGN KEY(business_id)    REFERENCES  business(business_id),
	);
	
INSERT INTO tip(business_id, compliment_count, date, text, user_id) 
SELECT parse_json($1):business_id,
			parse_json($1):compliment_count,
			parse_json($1):date,
			parse_json($1):text,
			parse_json($1):user_id
	FROM "YELP_DB"."STAGING".tip_stg;

/* 4.Review table ODS */

CREATE TABLE review(
  business_id VARIANT ,
  cool NUMBER,
  date STRING,
  funny NUMBER,
  review_id VARIANT PRIMARY KEY,
  stars NUMBER,
  text STRING,
  useful NUMBER,
  user_id VARIANT,
  CONSTRAINT FK_US_ID FOREIGN KEY(user_id)        REFERENCES  user(user_id),
  CONSTRAINT FK_BU_ID FOREIGN KEY(business_id)    REFERENCES  business(business_id),
  CONSTRAINT FK_TEMP_ID FOREIGN KEY(date)    REFERENCES  temperature(date_t),
  CONSTRAINT FK_PREC_ID FOREIGN KEY(date)    REFERENCES  precipitation (date_t),
  );
  
    
INSERT INTO review(business_id, cool, date, funny, review_id, stars, text, useful, user_id) 
SELECT parse_json($1):business_id, 
	parse_json($1):cool, 
	parse_json($1):date, 
	parse_json($1):funny, 
	parse_json($1):review_id, 
	parse_json($1):stars, 
	parse_json($1):text, 
	parse_json($1):useful, 
	parse_json($1):user_id FROM "YELP_DB"."STAGING".review_stg;
	
	
/* 5. Checkin table ODS */

CREATE TABLE checkin(
	business_id VARIANT,
	date STRING,
    CONSTRAINT FK_BU_ID FOREIGN KEY(business_id)    REFERENCES  business(business_id)	
	);
	
INSERT INTO checkin(business_id, date)
SELECT parse_json($1):business_id,
		parse_json($1):date 
		FROM "YELP_DB"."STAGING".checkin_stg;
		
		
/* 6. Covid table ODS */
CREATE TABLE covid (
	Call_To_Action_enabled VARIANT,
	Covid_Banner VARIANT,
	Grubhub_enabled	VARIANT,
	Request_a_Quote_Enabled VARIANT,
	Temporary_Closed_Until	VARIANT,
	Virtual_Services_Offered VARIANT,
	business_id VARIANT,
	delivery_or_takeout VARIANT,
	highlights VARIANT,
	CONSTRAINT FK_BU_ID         FOREIGN KEY(business_id)    REFERENCES  business(business_id)
	);

INSERT INTO covid(Call_To_Action_enabled,Covid_Banner,Grubhub_enabled,Request_a_Quote_Enabled, Temporary_Closed_Until,
Virtual_Services_Offered,business_id,delivery_or_takeout,highlights)
SELECT 
	parse_json($1):"Call To Action enabled",
	parse_json($1):"Covid Banner",
	parse_json($1):"Grubhub enabled",
	parse_json($1):"Request a Quote Enabled",
	parse_json($1):"Temporary Closed Until",
	parse_json($1):"Virtual Services Offered",
	parse_json($1):"business_id",
	parse_json($1):"delivery or takeout",
	parse_json($1):"highlights" FROM "YELP_DB"."STAGING".covid_stg;

/* 7. precipitation table ODS */
CREATE TABLE precipitation (
	date_t string PRIMARY KEY,
	precipitation FLOAT,
	precipitation_normal FLOAT);
	
	
INSERT INTO precipitation(date_t, precipitation, precipitation_normal)
SELECT date_tmp, 
CAST(precipitation_tmp AS FLOAT), 
CAST(precipitation_normal AS FLOAT) FROM "YELP_DB"."STAGING".precipitation_stg;


/* 8. Temperature table ODS */
CREATE TABLE temperature (
	date_t string PRIMARY KEY,
	min_t INT,
	max_t INT,
	normal_min FLOAT,
	normal_max FLOAT);
	
INSERT INTO temperature(date_t, min_t, max_t, normal_min, normal_max)
SELECT period_tmp,
CAST(min_value_tmp AS INT),
CAST(max_value_tmp AS INT),
CAST(normal_min_tmp AS FLOAT),
CAST(normal_max_tmp AS FLOAT) FROM "YELP_DB"."STAGING".temperature_stg;
	