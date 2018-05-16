/* Michelle Tanco - 05/16/2018
 * 2_R_commands.sql
 * 
 * Run some basic R commands to generate data
 * */

--Get pi
--use the -e arguement to exectue the code following it
--use -f with a file name to execute a file
SELECT DISTINCT piVal 
FROM SCRIPT (
	SCRIPT_COMMAND('R --vanilla -e "write(pi, stdout())"')              
	RETURNS('piVal VARCHAR(10000)') 
)

--piVal                                                         
-- ------------------------------------------------------------- 
-- Type 'demo()' for some demos, 'help()' for on-line help, or  
-- Type 'contributors()' for more information and               
-- Type 'q()' to quit R.                                        
-- null                                                         
-- Platform: x86_64-unknown-linux-gnu (64-bit)                  
-- 'help.start()' for an HTML browser interface to help.        
-- You are welcome to redistribute it under certain conditions. 
-- R is a collaborative project with many contributors.         
-- 3.141593                                                     
-- R version 3.2.1 (2015-06-18) -- "World-Famous Astronaut"     
-- Copyright (C) 2015 The R Foundation for Statistical Computing
-- >                                                            
-- > write(pi, stdout())                                        
-- 'citation()' on how to cite R or R packages in publications. 
-- Type 'license()' or 'licence()' for distribution details.    
-- R is free software and comes with ABSOLUTELY NO WARRANTY.    

--use the "salve" command to just get the results we want
--	not al the messages from R
SELECT DISTINCT piVal 
FROM SCRIPT (
	SCRIPT_COMMAND('R --vanilla --slave -e "pi"')              
	RETURNS('piVal VARCHAR(10000)') 
)

-- piVal        
-- ------------ 
-- [1] 3.141593

SELECT DISTINCT piVal 
FROM SCRIPT (
	SCRIPT_COMMAND('R --vanilla --slave -e "cat(pi);cat(\"\n\")"')              
	RETURNS('piVal real') 
)
 piVal    
 -------- 
 3.141593


--Get 20 numbers from a normal distribution
--n = 5 (this will run on every amp so we get 20 total)
--mean = 3
--sd = 0.25
SELECT  *
FROM SCRIPT (
	SCRIPT_COMMAND('R --vanilla --slave -e "write(for(i in rnorm(5,3,0.25)) {cat(i);cat(\"\n\")}, stdout())"')              
	RETURNS('n real') 
)
where n is not null;

--n        
-- -------- 
-- 3.125528
-- 2.830924
-- 3.009341
-- 3.025285
-- 3.072622
-- 3.125304
-- 3.103336
-- 3.077031
-- 3.120489
-- 3.230796
-- 3.120528
-- 3.419677
-- 2.873045
-- 3.158412
-- 3.162281
-- 3.071744
-- 2.970102
-- 3.321152
-- 3.556785
-- 3.103596


