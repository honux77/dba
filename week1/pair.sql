drop table if exists people; create table people(name varchar(8));
load data local infile '1ban.txt' into table people
	fields terminated by ','
	ignore 1 lines;

drop procedure if exists sp_pair;
delimiter $$
create procedure sp_pair()
begin
	declare str1, str2 varchar(8);
	declare done int default false;
	declare i int default 0;
	declare cur1 cursor for select * FROM people ORDER BY RAND(); 
	declare continue handler for not found set done = true;

	drop table if exists result;
	create table result(no int, str varchar(20)) engine = memory;
	open cur1;
	while not done do
		set i = i + 1;
		fetch cur1 into str1;
		fetch cur1 into str2;
		if not done then
			insert into result
				select i , concat(str1, " : ", str2);
		else
			insert into result
				select i, concat(str1, " : solo");
		end if;
	end while;
	select * from result;
end $$
delimiter ;

call sp_pair();
