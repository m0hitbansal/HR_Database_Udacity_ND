/* SWBAT integrate climate and Yelp data sets by identifying a common data field.*/

SELECT * 
	FROM precipitation AS p
	JOIN review AS r 
	ON r.date= p.date_t
	JOIN temperature AS t
	ON t.date_t = r.date
	JOIN business AS b
	ON b.business_id = r.business_id
    JOIN covid AS c
	ON b.business_id = c.business_id
	JOIN checkin AS ch
	ON b.business_id = ch.business_id
	JOIN tip AS x
	ON b.business_id = x.business_id and x.user_id=u.user_id
    JOIN user AS u
    ON u.user_id = r.user_id;