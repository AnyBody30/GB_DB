-- lesson_9
-- В базе данных shop и sample присутствуют одни и те же таблицы, учебной базы данных. Переместите запись id = 1 из таблицы shop.users в таблицу sample.users. Используйте транзакции.

select @id := id, @firstname:=firstname, @lastname:=lastname, @email:=email, @phone:=phone, @birthday:=birthday, @hometown:=hometown, 
@gender:=gender, @photo_id:=photo_id, @created_at:=created_at, @pass:=pass
from vk.users u
where id=1;

start transaction;
	-- delete from users u where id=1;
	SET foreign_key_checks = 0;
	delete from vk_teacher.users where id=1;
	insert into vk_teacher.users (id, firstname, lastname, email, phone, birthday, hometown, gender, photo_id, create_at, pass)
				values (@id, @firstname, @lastname, @email, @phone, @birthday, @hometown, @gender, @photo_id, @created_at, @pass);
	delete from vk.users where id=1;
	SET foreign_key_checks = 1;
commit;


-- Создайте представление, которое выводит название name товарной позиции из таблицы products и соответствующее название каталога name 
-- из таблицы catalogs.
create view prod (p_name, c_name) as select p.name, c.name from products p join catalogs c on p.catalog_id = c.id; 


-- (по желанию) Пусть имеется любая таблица с календарным полем created_at. Создайте запрос, который удаляет устаревшие записи из таблицы, оставляя только 5 самых свежих записей.
delete from posts where created_at not in (select * from (select created_at from posts order by created_at limit 5) as tmp);


-- Создайте двух пользователей которые имеют доступ к базе данных shop. Первому пользователю shop_read должны быть доступны только запросы на чтение данных, 
-- второму пользователю shop — любые операции в пределах базы данных shop.
create user shop_read@localhost, shop@localhost;
grant all on shop.* to shop@localhost;
grant select on shop.* to shop_read@localhost;
select * from mysql.`user` u;
show grants for shop@localhost;
show grants for shop_read@localhost;


-- Создайте хранимую функцию hello(), которая будет возвращать приветствие, в зависимости от текущего времени суток. 
-- С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", 
-- с 12:00 до 18:00 функция должна возвращать фразу "Добрый день", с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 — "Доброй ночи".
drop function if exists hello;
delimiter //
create function hello()
returns varchar(32) reads sql data
begin
	set @cur_hour := hour(now());
	if ((@cur_hour>=6) and (@cur_hour<=11)) then return 'Доброе утро';
			elseif ((@cur_hour>=12) and (@cur_hour<=17)) then return 'Добрый день';
			elseif ((@cur_hour>=18) and (@cur_hour<=23)) then return 'Добрый вечер';
			else return 'Доброй ночи';
	end if;
end//
delimiter ;

-- В таблице products есть два текстовых поля: name с названием товара и description с его описанием. 
-- Допустимо присутствие обоих полей или одно из них. 
-- Ситуация, когда оба поля принимают неопределенное значение NULL неприемлема. 
-- Используя триггеры, добейтесь того, чтобы одно из этих полей или оба поля были заполнены. 
-- При попытке присвоить полям NULL-значение необходимо отменить операцию.

drop trigger if exists not_double_null_upd;
delimiter //
create trigger not_double_null_upd before update on products
for each row
begin 
if ((new.name is null) and (new.description is null))  then
		signal sqlstate '45000'	set message_text = "Error updating! Name and description is null!";
	end if;
end//
delimiter ;


drop trigger if exists not_double_null_insrt;
delimiter //
create trigger not_double_null_upd_insrt before insert on products
for each row
begin 
if ((new.name is null) and (new.description is null))  then
		signal sqlstate '45000'	set message_text = "Error updating! Name and description is null!";
	end if;
end//
delimiter ;