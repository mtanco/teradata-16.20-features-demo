create table retail_to_sessionize as (
	select 
		customerid,tstamp,page
	from retail_base 
	where page not in ('ENTER','EXIT')
) with data;

select *
from retail_to_sessionize 
where customerid = 350109
order by tstamp

--customerid tstamp                     page         
-- ---------- -------------------------- ------------     
--     357491 2017-04-29 06:04:55.000000 HOME PAGE   
--     357491 2017-04-29 06:05:28.000000 VIEW PRODUCT
--     357491 2017-04-29 06:07:19.000000 VIEW PRODUCT
--     357491 2017-04-29 06:08:45.000000 VIEW PRODUCT
--     357491 2017-04-29 06:10:50.000000 SEARCH      
--     357491 2017-04-29 06:13:28.000000 VIEW PRODUCT
--     357491 2017-04-29 06:15:22.000000 SEARCH      
--     357491 2017-04-29 06:17:31.000000 VIEW PRODUCT
--     357491 2017-04-29 06:17:56.000000 SEARCH      
--     357491 2017-04-29 06:19:00.000000 SEARCH      
--     357491 2017-04-29 06:21:22.000000 SEARCH      
--     357491 2017-04-29 06:23:19.000000 VIEW PRODUCT
--     357491 2017-04-29 06:25:20.000000 SEARCH      
   

--after sixty seconds it's a new session
SELECT * 
FROM Sessionize (
	ON (
		select *
		from retail_to_sessionize 
		where customerid = 350109
	)
		PARTITION BY customerid
		ORDER BY tstamp
	USING
		TimeColumn ('tstamp')
		TimeOut (120.0)
) AS sess;