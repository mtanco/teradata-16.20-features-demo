/* Michelle Tanco - 05/16/2018
 * 0_build_sample_dataset.sql
 * 
 * unsessionzie the data for playing with sessionize function
 * */

drop table retail_to_sessionize;
create table retail_to_sessionize as (
	select 
		customerid,tstamp,page,cart
	from retail_base 
	where page not in ('ENTER','EXIT')
) with data;