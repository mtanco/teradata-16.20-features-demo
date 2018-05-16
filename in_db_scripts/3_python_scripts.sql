/* Michelle Tanco - 05/16/2018
 * 3_python_scripts.sql
 * 
 * Run a python simulation in parallel
 * */

--Session default location to look for script files
set session searchuifdbpath=CHARLES;


/*PYTHON DEMO:
 * RUN 100 SIMULATIONS IN DATABASE TO PREDICT HOW MANY CUSTOMERS
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

--number_customers number_customers_left average_wait_time 
-- ---------------- --------------------- ----------------- 
--              118                    50       4.648441712
--              129                    49     4.40215674799
--              108                    50     4.68818384981
--              133                    68     5.12768594729
--              134                    59     4.83224215619

SELECT 
	min(number_customers)		as min_numb_cust
	,avg(number_customers)		as avg_numb_cust
	,max(number_customers)		as max_numb_cust
	,min(number_customers_left)	as min_cust_left
	,avg(number_customers_left)	as avg_cust_left
	,max(number_customers_left)	as max_cust_left
	,min(average_wait_time)		as min_wait_time
	,avg(average_wait_time)		as avg_wait_time
	,max(average_wait_time)		as max_wait_time

FROM SCRIPT(
	ON charles.ex2tblshort
	SCRIPT_COMMAND('python ./CHARLES/ex2p.py 4 5 10 6 480')
	RETURNS ('number_customers INT
			, number_customers_left INT
			, average_wait_time REAL')
);

-- min_numb_cust avg_numb_cust max_numb_cust 
-- ------------- ------------- ------------- 
--           104        121.66           152 

-- min_cust_left avg_cust_left max_cust_left 
-- ------------- ------------- ------------- 
--            32         52.16            74 
--
-- min_wait_time avg_wait_time max_wait_time 
-- ------------- ------------- --------------
-- 3.67321218081 4.71191563726 5.55725097328