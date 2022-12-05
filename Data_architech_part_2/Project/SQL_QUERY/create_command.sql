/* create Database*/
CREATE DATABASE yelp_db;

/* create staging schema*/
CREATE SCHEMA "YELP_DB"."STAGING";

/* create ODS schema*/
CREATE SCHEMA "YELP_DB"."ODS";

/* create DWH schema*/
CREATE SCHEMA "YELP_DB"."DWH";

/* create json file formate */
CREATE FILE FORMAT "YELP_DB"."PUBLIC".json_file
 TYPE = 'JSON' ;

/* create stage */
create OR REPLACE STAGE "YELP_DB"."STAGING"."YELP_DATA";