/* Michelle Tanco - 05/16/2018
 * 2_nPath_examples.sql
 * 
 * looking at some paths and patterns in the data
 * */

--for each customer, get their full page path
select *
from nPath (
	on retail_sessions
		partition by customerid, sessionid
		order by tstamp
	using
		mode(nonoverlapping)
		pattern('EVRY*')
		symbols(TRUE as EVRY)
		result(
			first(customerid of EVRY) as customerid
			,first(sessionid of EVRY) as sessionid			
			,accumulate(page of EVRY) as page_path
		)
);
--
--customerid sessionid page_path                                        
-- ---------- --------- ------------------------------------------------ 
--     350578         0 Snippet:[VIEW PRODUCT, ADD TO CART, REVIEW CA...
--     350109         0 Snippet:[VIEW PRODUCT, ADD TO CART, VIEW PROD...
--     350904         0 Snippet:[VIEW PRODUCT, ADD TO CART, VIEW PROD...
--     350904         1 Snippet:[VIEW PRODUCT, VIEW PRODUCT, SEARCH, ...
--     352515         1 Snippet:[VIEW PRODUCT, VIEW PRODUCT, SEARCH, ...
--     352189         0 Snippet:[VIEW PRODUCT, ADD TO CART, VIEW PROD...


select page, count(*)
from retail_sessions
group by 1
--page                          Count(*) 
-- ----------------------------- -------- 
-- ADD TO CART                        176
-- CONFIRM ORDER                       10
-- DELAYED SHIPPING NOTIFICATION        2
-- ENTER PAYMENT INFORMATION           14
-- ENTER SHIPPING INFORMATION          26
-- HOME PAGE                           86
-- PURCHASE COMPLETE                    6
-- RETURN POLICY                        5
-- REVIEW CART                         86
-- SEARCH                            1866
-- SERVER ERROR                         3
-- SHIPPING FAQ                        14
-- VIEW PRODUCT                      2055

--confirm order happens more than purchase complete, let's invesigate
select 
	page
	, count(*) as cnt
	, count(*)  * 1.0 /sum(count(*)) over(partition by 1) as pct
from nPath (
	on retail_sessions
		partition by customerid, sessionid
		order by tstamp
	using
		mode(overlapping)
		pattern('CO.EVRY')
		symbols(
			page = 'CONFIRM ORDER' as CO
			,TRUE as EVRY
		)
		result(		
			first(page of EVRY) as page
		)
) as np
group by 1;

-- page              cnt pct 
-- ----------------- --- --- 
-- PURCHASE COMPLETE   6 0.7
-- SEARCH              2 0.2
-- VIEW PRODUCT        1 0.1
