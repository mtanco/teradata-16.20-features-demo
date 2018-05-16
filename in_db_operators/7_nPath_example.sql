select * 
from retail_base
where customerid = 540529
order by tstamp


SELECT 
	last_item
	,no_item
	,cast(page_path as VARCHAR(1000))
FROM nPath ( 
	ON (
		select * 
		from retail_base
		where customerid = 540529
	) AS "input1"
		PARTITION BY customerid,sessionid 
		ORDER BY tstamp
	USING  
		Mode (NONOVERLAPPING) 
		Pattern ('A*.I.NI') 
		Symbols ( 
			cart is not null as I
			,cart is null as NI
			,TRUE as A
		) 
		Result (
			first(page of I) as last_item
			,first(page of NI) as no_item
			,accumulate(page of any(I,NI,A)) as page_path
		) 
) AS np;


SELECT 
	,cast(page_path as VARCHAR(1000))
	,count(*)
FROM nPath ( 
	ON retail_base AS "input1"
		PARTITION BY customerid,sessionid 
		ORDER BY tstamp
	USING  
		Mode (NONOVERLAPPING) 
		Pattern ('A*.I.NI') 
		Symbols ( 
			cart is not null as I
			,cart is null as NI
			,TRUE as A
		) 
		Result (
			first(page of I) as last_item
			,first(page of NI) as no_item
			,accumulate(page of any(I,NI,A)) as page_path
		) 
) AS np
group by 1




