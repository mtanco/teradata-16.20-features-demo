--Replace non-alpha numeric and space with a squiggle
--Input: 123!!dogHI!
--Expected Output: 123~~dogHI~
                                 
SELECT REGEXP_REPLACE(
	'123!!dogHI!'
	, '[^A-Za-z0-9\s]*'
	,'~'
	, 1 --start at begining of string
	, 0 --find all matches
);
--Output:  ~1~2~3~~d~o~g~H~I~~ 

-- The zero parameter means find all matches
--, so let's remove the star

SELECT REGEXP_REPLACE(
	'123!!dogHI!'
	, '[^A-Za-z0-9\s]'
	,'~'
	, 1 --start at begining of string
	, 0 --find all matches
);
--Output: 123~~dogHI~    