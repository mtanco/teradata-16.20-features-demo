create table mt_test (
	id int
	,event char(1)
) primary index(id);


insert into mt_test (1,'A');
insert into mt_test (1,'B');
insert into mt_test (1,'C');

insert into mt_test (2,'A');
insert into mt_test (2,'B');
insert into mt_test (2,'C');

select * from mt_test;
--id event 
-- -- ----- 
--  1 A    
--  1 B    
--  1 C    
--  2 A    
--  2 B    
--  2 C    

--expecting overlap to be greedy and return:
-- 1AB,1BC,1C, 2AB,2BC,2C

select 
	id,cast(path as varchar(20)) as path
from nPath(
	on mt_test partition by id order by event
	using
	mode(overlapping)
	pattern('A{1,2}')
	symbols(true as A)
	result(first(id of A) as id, accumulate(event of A) as path)
);

--id path   
-- -- ------ 
--  1 [C]   
--  1 [B, C]
--  1 [A, B]
--  2 [C]   
--  2 [B, C]
--  2 [A, B]

drop table mt_test;