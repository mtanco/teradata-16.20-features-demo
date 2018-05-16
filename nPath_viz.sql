/* Michelle Tanco - 05/16/2018
 * 3_nPath_to_visualize.sql
 * 
 * visualize the most common paths
 * */

--for each customer, get their full page path
select 
	path, count(*) as cnt
from nPath (
	on retail_sessions
		partition by customerid, sessionid
		order by tstamp
	using
		mode(overlapping)
		pattern('EVRY{2,5}')
		symbols(TRUE as EVRY)
		result(		
			accumulate(page of EVRY) as path
		)
)
group by 1
order by 2 desc;

--
--  path                                            cnt 
-- ------------------------------------------------ --- 
-- Snippet:[VIEW PRODUCT, SEARCH]                   124
-- Snippet:[VIEW PRODUCT, VIEW PRODUCT, VIEW PRO... 123
-- Snippet:[VIEW PRODUCT, SEARCH, VIEW PRODUCT, ... 121
-- Snippet:[SEARCH, VIEW PRODUCT, VIEW PRODUCT, ... 105
-- Snippet:[VIEW PRODUCT, VIEW PRODUCT, SEARCH, ... 105
-- Snippet:[VIEW PRODUCT, VIEW PRODUCT, VIEW PRO... 103
-- Snippet:[SEARCH, SEARCH]                         101
