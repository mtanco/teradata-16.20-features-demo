/* Michelle Tanco - 05/16/2018
 * 1_linux_cmd.sql
 * 
 * Run basic commands on each amp and return results
 * */

--Get the working directory from each amp
SELECT  *
FROM SCRIPT (
	SCRIPT_COMMAND('pwd')
	RETURNS('working_dir VARCHAR(60)')
);

-- working_dir                                                     
-- ---------------------------------------------------------- 
-- /var/opt/teradata/tdtemp/uiftemp/0_18-May-16_12-34-36_4372
-- /var/opt/teradata/tdtemp/uiftemp/1_18-May-16_12-34-36_3297
-- /var/opt/teradata/tdtemp/uiftemp/2_18-May-16_12-34-36_5586
-- /var/opt/teradata/tdtemp/uiftemp/3_18-May-16_12-34-36_4372

--Move up one folder and print all files
--Duplicates because this command is running on every amp
--	and each amp has the same parent directory
SELECT  *
FROM SCRIPT (
	SCRIPT_COMMAND('cd ..; ls')
	RETURNS('files_and_folders VARCHAR(60)')
);

-- files_and_folders                     
-- ------------------------- 
-- 0_18-May-16_12-36-33_2694
-- 0_18-May-16_12-36-33_2694
-- 0_18-May-16_12-36-33_2694
-- 0_18-May-16_12-36-33_2694
-- 1_18-May-16_12-36-33_6471
-- 1_18-May-16_12-36-33_6471
-- 1_18-May-16_12-36-33_6471
-- 1_18-May-16_12-36-33_6471
-- 2_18-May-16_12-36-33_7729
-- 2_18-May-16_12-36-33_7729
-- 2_18-May-16_12-36-33_7729
-- 2_18-May-16_12-36-33_7729
-- 3_18-May-16_12-36-33_2694
-- 3_18-May-16_12-36-33_2694
-- 3_18-May-16_12-36-33_2694

--Remove duplicates
SELECT  distinct files_and_folders
FROM SCRIPT (
	SCRIPT_COMMAND('cd ..; ls')
	RETURNS('files_and_folders VARCHAR(60)')
);

-- files_and_folders         
-- ------------------------- 
-- 2_18-May-16_12-38-37_7472
-- 3_18-May-16_12-38-37_7843
-- 1_18-May-16_12-38-37_5777
-- 0_18-May-16_12-38-37_7843


