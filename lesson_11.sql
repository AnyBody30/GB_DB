-- lesson_11
-- Создайте таблицу logs типа Archive. Пусть при каждом создании записи в таблицах users, 
-- catalogs и products в таблицу logs помещается время и дата создания записи, название таблицы, 
-- идентификатор первичного ключа и содержимое поля name.

DROP TABLE IF EXISTS logs;
CREATE TABLE logs (
  table_name varchar(64),
  create_record_datetime datetime,
  pri_key_id bigint unsigned not null,
  name varchar(255)
) ENGINE=ARCHIVE;


drop trigger if exists users_fills_logs;
delimiter //
create trigger users_fills_logs after insert on users
for each row
begin 
insert into logs values('users', now(), new.id, new.name);
end//
delimiter ;

drop trigger if exists catalogs_fills_logs;
delimiter //
create trigger catalogs_fills_logs after insert on catalogs
for each row
begin 
insert into logs values('catalogs', now(), new.id, new.name);
end//
delimiter ;

drop trigger if exists products_fills_logs;
delimiter //
create trigger products_fills_logs after insert on products
for each row
begin 
insert into logs values('products', now(), new.id, new.name);
end//
delimiter ;




-- (по желанию) Создайте SQL-запрос, который помещает в таблицу users миллион записей.
 insert into users (name, birthday_at, created_at, updated_at)
 select concat(t0, t1, t2, t3, t4, t5), now(), now(), now() from
 (select 'a0' t0 union select 'a1' union select 'a2' union select 'a3' union select 'a4' union select 'a5' union select 'a6' union select 'a7' union select 'a8' union select 'a9') k0,
 (select 'a0' t1 union select 'a1' union select 'a2' union select 'a3' union select 'a4' union select 'a5' union select 'a6' union select 'a7' union select 'a8' union select 'a9') k1,
 (select 'a0' t2 union select 'a1' union select 'a2' union select 'a3' union select 'a4' union select 'a5' union select 'a6' union select 'a7' union select 'a8' union select 'a9') k2,
 (select 'a0' t3 union select 'a1' union select 'a2' union select 'a3' union select 'a4' union select 'a5' union select 'a6' union select 'a7' union select 'a8' union select 'a9') k3, 
 (select 'a0' t4 union select 'a1' union select 'a2' union select 'a3' union select 'a4' union select 'a5' union select 'a6' union select 'a7' union select 'a8' union select 'a9') k4, 
 (select 'a0' t5 union select 'a1' union select 'a2' union select 'a3' union select 'a4' union select 'a5' union select 'a6' union select 'a7' union select 'a8' union select 'a9') k5 


 