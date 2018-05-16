--Session default location to look for files
set session searchuifdbpath=CHARLES;

SELECT  *
FROM SCRIPT (
	SCRIPT_COMMAND('echo $PATH')
	RETURNS('outStr VARCHAR(60)')
);

/*We get a result from every amp - allows for parallelization*/
--outStr                                        
-- --------------------------------------------- 
-- /usr/local/bin:/bin:/usr/bin:/usr/X11R6/bin:.
-- /usr/local/bin:/bin:/usr/bin:/usr/X11R6/bin:.
-- /usr/local/bin:/bin:/usr/bin:/usr/X11R6/bin:.
-- /usr/local/bin:/bin:/usr/bin:/usr/X11R6/bin:.

/*PYTHON DEMO:
 * RUN 100 TRIALS IN DATABASE TO PREDICT HOW MANY CUSTOMERS
 * WHO COME INTO A BANK WILL GET IMPATIENT AND LEAVE BEFORE
 * IT'S THEIR TURN TO BE SERVED
 * 
 * EACH AMP WILL RUN 25 DEMOS, SEEDS FROM THE DEMO
 * ARE STORED IN DB
 * */

--100 inputs of random seeds that we will use for our trials
select *
from charles.ex2tblshort
order by 1

--ObsID RandSeed     
-- ----- ------------ 
--     1 8.61112618E8
--     2 6.59336932E8
--     3 5.71774957E8
--     4   2.159891E8
--     5 3.31914362E8


--Input parameters:
--INTERVAL_CUSTOMERS : Time interval (minutes) between customer entries
--MIN_PATIENCE       : Minimum time (minutes) customers will wait
--MAX_PATIENCE       : Maximum time (minutes) customers will wait
--TIME_IN_BANK       : Time (minutes) a customer spends being served
--MAX_MINUTES        : Process observation time (minutes)

--Every 4 min a customer comes in 
--They will wait at least 5 min but not more than 10
--It takes 6 min to serve a customer
--We are doing a simulation over an 8 hour work day

SELECT *
FROM SCRIPT(
	ON charles.ex2tblshort
	SCRIPT_COMMAND('python ./CHARLES/ex2p.py 4 5 10 6 480')
	RETURNS ('number_customers INT
			, number_customers_left INT
			, average_wait_time REAL')
);

SELECT 
	min(number_customers),avg(number_customers),max(number_customers)
	,min(number_customers_left),avg(number_customers_left),max(number_customers_left)
	,min(average_wait_time),avg(average_wait_time),max(average_wait_time)

FROM SCRIPT(
	ON charles.ex2tblshort
	SCRIPT_COMMAND('python ./CHARLES/ex2p.py 4 5 10 6 480')
	RETURNS ('number_customers INT
			, number_customers_left INT
			, average_wait_time REAL')
);