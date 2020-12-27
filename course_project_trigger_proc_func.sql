-- примеры триггеров, функции и процедуры
-- Триггер пересчета среднего балла мероприятия по отзывам при вставке нового отзыва
drop trigger if exists recalc_avg_score;
delimiter //
create trigger recalc_avg_score after insert on reviews
for each row
begin
	-- set @avg_score = select avg(score) from reviews 
	update events set avg_score = (select avg(r2.score) from reviews r1 join ratings r2 where r1.event_id = new.event_id);
end//
delimiter ;  
   

-- Функция допустимости билета для заданных части сцены, ряда и места
drop function if exists is_ticket_possible;
delimiter //
create function is_ticket_possible (check_part_id bigint, check_row int, check_place_num int)
returns boolean deterministic
begin
		-- выбираем сколько мест в это части сцены и в заданном ряду
	declare pc int default 0;
	set pc = (select places_count 	from platform_parts_maps ppm where ppm.part_id = check_part_id and ppm.row_num = check_row);						
	if (pc is null) then return false; -- если в этой части сцены нет такого ряда, то не может быть места в несуществующем ряде
     end if;
	if (check_place_num <= pc) then return true; -- если ряд есть, то место билета не должно быть больше количества мест в ряде
	 else return false; -- иначе нельзя сформировать билет на место с номером больше количсества мест в ряде
	end if;
end//
delimiter ;


-- Триггер контроля допустимости билета на данный ряд и место 
drop trigger if exists insert_ticket;
delimiter //
create trigger insert_ticket before insert on tickets
for each row
begin 
	if !is_ticket_possible(new.platform_part_id, new.row_num, new.place_num) then
		signal sqlstate '45000' set message_text = 'Insert ticket Canceled. There is no that row and place!';
	end if;
end//



-- процедура генерации билетов по заданным параметрам с диалогового экрана администратора системы
-- входные параметры процедуры выбираемые с "морды" администратора системы
-- for_begindate дата начала сеанса мероприятия
-- for_begintime время начала сеанса мероприятия
-- for_city_name город проведения мероприятия
-- for_place_name место проведения мероприятия - площадка
-- for_event_name наименование мероприятия
-- for_platform_name наименование сцены сеанса
-- for_platform_part_name наименование части сцены сеанса
-- for_from_row_num начальый номер ряда генерируемого пакета билетов
-- for_to_row_num конечный номер ряда генерируемого пакета билетов
-- for_place_cnt количество мест в рядах
-- for_price цена генерируемых билетов
drop procedure if exists tickets_generator;
delimiter //
create procedure tickets_generator
(in for_begindate date, for_begintime time, for_city_name varchar(256), for_event_name varchar(256), for_platform_part_name varchar(256), 
for_platform_name varchar(256), for_place_name varchar(256), for_from_row_num int, for_to_row_num int, for_place_cnt int, for_price int)

begin
 	insert into tickets (timetable_id, platform_part_id, price, row_num, place_num) 
	select distinct
	s1.timetable_id, 
	s1.platform_part_id,
	for_price,
	s2.row_num,
	s2.place_num
	from -- используем неповторяющиеся значения декартово произведение постоянных значений вставки и изменяющихся номеров рядов и мест
	(select 
	  t.id 'timetable_id', -- идентификатор сеанса
	  pp3.id 'platform_part_id' -- идентификатор части зала
    from 
      timetables t join events e on t.event_id = e.id -- связываем сеансы и мероприятия
      join places p1 on p1.id = e.place_id -- связываем площадки и мероприятия
      join (place_platforms pp2, cities c) on (pp2.place_id = p1.id and c.id = p1.city_id) -- связываем площадки и города, площадки и сцены
      join platform_parts pp3 on  pp3.platform_id = pp2.id -- связываем сцены и их части
	where (t.begin_date = for_begindate) and (t.begin_time = for_begintime) and (p1.place_name = for_place_name) -- фильтруерм по датам и времени начала, имени площадки
          and pp2.platform_name = for_platform_name -- фильтруем по имени сцены
          and pp3.part_name = for_platform_part_name -- фильтруем по имени части платформ
          and e.event_name = for_event_name
          and c.city_name = for_city_name -- фильтруем по городу
    ) s1,
-- с помощью запросов ниже организуем генерацию номеров рядов и мест на этих рядах в границах заданных входными параметрами	       
   (select a1.r 'row_num', a2.p 'place_num' from  
    (select r.num 'r' from -- номер ряда
       ((select * from
        (select (t3*1000+t2*100+t1*10+t0) num  from
          (select 0 t0 union select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) k0,
          (select 0 t1 union select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) k1,
          (select 0 t2 union select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) k3, 
          (select 0 t3 union select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) k4) m
        where (num >= 1) and (num <= for_place_cnt)) p, 
       (select * from
        (select (t3*1000+t2*100+t1*10+t0) num  from
          (select 0 t0 union select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) k0,
          (select 0 t1 union select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) k1,
          (select 0 t2 union select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) k3, 
          (select 0 t3 union select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) k4) m
        where (num >= for_from_row_num) and (num <= for_to_row_num)) r)) a1,
      
        (select p.num 'p' from -- номер места
       ((select * from
        (select (t3*1000+t2*100+t1*10+t0) num  from
          (select 0 t0 union select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) k0,
          (select 0 t1 union select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) k1,
          (select 0 t2 union select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) k3, 
          (select 0 t3 union select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) k4) m
        where (num >= 1) and (num <= for_place_cnt)) p, 
       (select * from
        (select (t3*1000+t2*100+t1*10+t0) num  from
          (select 0 t0 union select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) k0,
          (select 0 t1 union select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) k1,
          (select 0 t2 union select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) k3, 
          (select 0 t3 union select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) k4) m
        where (num >= for_from_row_num) and (num <= for_to_row_num)) r)) a2) s2;
	
end//
delimiter ;

-- пример вызова процедуры
call  tickets_generator ('2021-01-07', '21:00', 'New Concepcion', 'dolores', 'molestias', 'sint', 'commodi', 100, 101, 5, 500);
