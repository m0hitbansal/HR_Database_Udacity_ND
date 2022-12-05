/*SQL queries code that report business name, temperature, precipitation, ratings*/

SELECT distinct b.name as business_name, min_t, max_t, normal_min, normal_max, precipitation, precipitation_normal, tot.stars
FROM dim_business AS b
JOIN fact_info AS tot 
ON b.business_id = tot.business_id
JOIN dim_climate AS cli
ON cli.climate_date = tot.climate_date
JOIN dim_review AS r
ON r.review_id = tot.review_id;