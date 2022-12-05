/*CREATE TABLES INTO STAGING AREA*/
USE DATABASE "yelp_db";
USE SCHEMA "YELP_DB"."STAGING";

CREATE TABLE covid_stg(covid_info VARIANT);

CREATE TABLE tip_stg(tip_info VARIANT);

CREATE TABLE user_stg(user_info VARIANT);

CREATE TABLE review_stg(review_info VARIANT);

CREATE TABLE business_stg(busines_info VARIANT);

CREATE TABLE checkin_stg(checkin_info VARIANT);

CREATE TABLE precipitation_stg (
	date_tmp STRING,
	precipitation_tmp STRING,
	precipitation_normal STRING);
	
CREATE TABLE temperature_stg (
	period_tmp STRING,
	min_value_tmp STRING,
	max_value_tmp STRING,
	normal_min_tmp STRING,
	normal_max_tmp STRING);


/* upload file on stage */
PUT file:////Users/mohit.bansal/Downloads/yelp_dataset/user.json @yelp_data;
PUT file:////Users/mohit.bansal/Downloads/yelp_dataset/review.json @yelp_data;
PUT file:////Users/mohit.bansal/Downloads/yelp_dataset/business.json @yelp_data;
PUT file:////Users/mohit.bansal/Downloads/yelp_dataset/checkin.json @yelp_data;
PUT file:////Users/mohit.bansal/Downloads/yelp_dataset/covid_features.json @yelp_data;
PUT file:////Users/mohit.bansal/Downloads/yelp_dataset/tip.json @yelp_data;

/*COPY FILES INTO TEMPORARY TABLES FROM @YELP_DATA */
COPY INTO user_stg FROM @YELP_DATA/user.json file_format=(type=JSON);

COPY INTO review_stg FROM @YELP_DATA/review.json file_format=(type=JSON);

COPY INTO covid_stg FROM @YELP_DATA/covid_features.json file_format=(type=JSON);

COPY INTO tip_stg FROM @YELP_DATA/tip.json file_format=(type=JSON);

COPY INTO business_stg FROM @YELP_DATA/business.json file_format=(type=JSON);

COPY INTO checkin_stg FROM @YELP_DATA/checkin.json file_format=(type=JSON);

UPDATE PRECIPITATION_stg SET precipitation_tmp = 8888 WHERE precipitation_tmp = 'T';
