select 
 	customerid
from nPath(
	on (
		select *
		from retail_to_sessionize 
	) 
		partition by customerid
		order by tstamp
	using
		mode(overlapping)
		pattern('A.A')
		symbols(
			TRUE as A
		)
		result(
			first(customerid of A) as customerid
			,first(tstamp of A) as t1
			,last(tstamp of A) as t2
		)
) as np
where ((t2 - t1) DAY > 1) ;


