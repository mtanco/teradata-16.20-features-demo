/* Michelle Tanco - 05/16/2018
 * 1_sessionize.sql
 * 
 * split up customers into sessions as too much time past could mean 
 * 	new behavior
 * */

select *
from retail_to_sessionize 
where customerid = 492098
order by tstamp

--customerid tstamp                     page                       cart   
-- ---------- -------------------------- -------------------------- ------ 
--     492098 2017-01-29 17:30:41.000000 VIEW PRODUCT               null  
--     492098 2017-01-29 17:30:56.000000 ADD TO CART                SWITCH
--     492098 2017-01-29 17:31:18.000000 REVIEW CART                SWITCH
--     492098 2017-01-29 17:33:44.000000 ENTER SHIPPING INFORMATION SWITCH
--     492098 2017-01-31 20:41:29.000000 HOME PAGE                  SWITCH
--     492098 2017-01-31 20:41:52.000000 VIEW PRODUCT               null  
--     492098 2017-01-31 20:42:49.000000 SEARCH                     null  
--     492098 2017-01-31 20:43:35.000000 SEARCH                     null  
--     492098 2017-01-31 20:44:49.000000 VIEW PRODUCT               null  
--     492098 2017-01-31 20:46:53.000000 SEARCH                     null  
--     492098 2017-01-31 20:49:17.000000 SEARCH                     null  
--     492098 2017-01-31 20:50:56.000000 SEARCH                     null  
--     492098 2017-01-31 20:53:55.000000 VIEW PRODUCT               null  
--     492098 2017-01-31 20:55:05.000000 VIEW PRODUCT               null  
--     492098 2017-01-31 20:56:02.000000 SEARCH                     null  
--     492098 2017-01-31 20:58:15.000000 SEARCH                     null  
--     492098 2017-01-31 21:00:54.000000 VIEW PRODUCT               null  
--     492098 2017-01-31 21:03:16.000000 VIEW PRODUCT               null  
--     492098 2017-01-31 21:05:25.000000 SEARCH                     null  
--     492098 2017-01-31 21:08:11.000000 SEARCH                     null  
--     492098 2017-01-31 21:10:00.000000 VIEW PRODUCT               null  
--     492098 2017-01-31 21:11:53.000000 SEARCH                     null  
--     492098 2017-01-31 21:12:12.000000 VIEW PRODUCT               null  
--     492098 2017-01-31 21:12:59.000000 VIEW PRODUCT               null  
--     492098 2017-01-31 21:15:45.000000 VIEW PRODUCT               null  
--     492098 2017-01-31 21:16:45.000000 SEARCH                     null  
--     492098 2017-02-16 00:57:54.000000 VIEW PRODUCT               null  
--     492098 2017-02-16 00:58:09.000000 ADD TO CART                SWITCH
--     492098 2017-02-16 01:00:57.000000 REVIEW CART                SWITCH

--Google analtyics "industry standard"
--	30 minutes of inactively means a new session
SELECT * 
FROM Sessionize (
	ON (
		select *
		from retail_to_sessionize 
		where customerid = 492098
	)
		PARTITION BY customerid
		ORDER BY tstamp
	USING
		TimeColumn ('tstamp')
		TimeOut (3600.0) --number of seconds
) AS sess;

--customerid tstamp                     page                       cart   SESSIONID 
-- ---------- -------------------------- -------------------------- ------ --------- 
--     492098 2017-01-29 17:30:41.000000 VIEW PRODUCT               null           0
--     492098 2017-01-29 17:30:56.000000 ADD TO CART                SWITCH         0
--     492098 2017-01-29 17:31:18.000000 REVIEW CART                SWITCH         0
--     492098 2017-01-29 17:33:44.000000 ENTER SHIPPING INFORMATION SWITCH         0
--     492098 2017-01-31 20:41:29.000000 HOME PAGE                  SWITCH         1
--     492098 2017-01-31 20:41:52.000000 VIEW PRODUCT               null           1
--     492098 2017-01-31 20:42:49.000000 SEARCH                     null           1
--     492098 2017-01-31 20:43:35.000000 SEARCH                     null           1
--     492098 2017-01-31 20:44:49.000000 VIEW PRODUCT               null           1
--     492098 2017-01-31 20:46:53.000000 SEARCH                     null           1
--     492098 2017-01-31 20:49:17.000000 SEARCH                     null           1
--     492098 2017-01-31 20:50:56.000000 SEARCH                     null           1
--     492098 2017-01-31 20:53:55.000000 VIEW PRODUCT               null           1
--     492098 2017-01-31 20:55:05.000000 VIEW PRODUCT               null           1
--     492098 2017-01-31 20:56:02.000000 SEARCH                     null           1
--     492098 2017-01-31 20:58:15.000000 SEARCH                     null           1
--     492098 2017-01-31 21:00:54.000000 VIEW PRODUCT               null           1
--     492098 2017-01-31 21:03:16.000000 VIEW PRODUCT               null           1
--     492098 2017-01-31 21:05:25.000000 SEARCH                     null           1
--     492098 2017-01-31 21:08:11.000000 SEARCH                     null           1
--     492098 2017-01-31 21:10:00.000000 VIEW PRODUCT               null           1
--     492098 2017-01-31 21:11:53.000000 SEARCH                     null           1
--     492098 2017-01-31 21:12:12.000000 VIEW PRODUCT               null           1
--     492098 2017-01-31 21:12:59.000000 VIEW PRODUCT               null           1
--     492098 2017-01-31 21:15:45.000000 VIEW PRODUCT               null           1
--     492098 2017-01-31 21:16:45.000000 SEARCH                     null           1
--     492098 2017-02-16 00:57:54.000000 VIEW PRODUCT               null           2
--     492098 2017-02-16 00:58:09.000000 ADD TO CART                SWITCH         2
--     492098 2017-02-16 01:00:57.000000 REVIEW CART                SWITCH         2

DROP TABLE retail_sessions;
CREATE TABLE retail_sessions AS (
	SELECT * 
	FROM Sessionize (
		ON (
			select *
			from retail_to_sessionize 
		)
			PARTITION BY customerid
			ORDER BY tstamp
		USING
			TimeColumn ('tstamp')
			TimeOut (3600.0) --number of seconds
	) AS sess
) WITH DATA;


select 
	count(distinct customerid) as numb_cust
	,count(distinct customerid || '_' || sessionid) as numb_sess
from retail_sessions

--numb_cust numb_sess 
-- --------- --------- 
--       270       300
