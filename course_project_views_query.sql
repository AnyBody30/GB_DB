-- типовой запрос для формирования раздела "Популярное" стартовой страницы  https://www.ticketland.ru/
-- показать первые 10 по популярности мероприятия с начаом сеанса за период времени
SET lc_time_names = 'ru_RU';
 select e.event_name 'Название', -- название мероприятия
 		img.image_file_name, -- место хранения изображения лого мероприятия
 		date_format(t.begin_date, '%d %M %Y %W') 'День сеанса',-- день мероприятия
 		date_format(t.begin_time, '%H:%i') 'Время сеанса', -- время мероприятия
 		e.avg_score 'Рейтинг', -- усредненный рейтинг мероприятия
 		p1.place_name 'Место', -- место мероприятия
 		t.min_price 'Цена от' -- минимальная цена билета
  from 
      timetables t join events e on t.event_id = e.id -- связываем сеансы и мероприятия
      join (places p1, images img) on (p1.id = e.place_id and img.id = e.logo_image_id)-- связываем площадки и мероприятия, изображения и мероприятия
      join (place_platforms pp2, cities c) on (pp2.place_id = p1.id and c.id = p1.city_id) -- связываем площадки и города, площадки и сцены
      join platform_parts pp3 on  pp3.platform_id = pp2.id -- связываем сцены и их части        
  where t.begin_date > '2015-05-05' and t.begin_date < '2020-05-05'
  order by e.avg_score desc
  limit 10;
         
-- примеры представлений
 -- создаем представление сеансы всех мероприятий в репертуаре 
 drop view if exists sessions;
 create view sessions
 as select e.event_name 'Название мероприятия', -- название мероприятия
 		date_format(t.begin_date, '%d %M %Y %W') 'День сеанса',-- день мероприятия
 		date_format(t.begin_time, '%H:%i') 'Время сеанса', -- время мероприятия
 		p1.place_name 'Место проведения' -- место мероприятия
  from 
 	  timetables t join events e on t.event_id = e.id -- связываем сеансы и мероприятия
      join places p1 on p1.id = e.place_id -- связываем площадки и мероприятия
  where e.in_repertoire = true;
 
 -- создаем представление общее количество мероприятий в репертуаре по местам проведения
 drop view if exists sessions_in_places;  
 create view sessions_in_places
  as select 
 		p1.place_name 'Место проведения', -- место мероприятия
 		count(e.id)
  from 
 	  timetables t join events e on t.event_id = e.id -- связываем сеансы и мероприятия
      join places p1 on p1.id = e.place_id -- связываем площадки и мероприятия
      where e.in_repertoire = true
	group by e.id
  
-- создаем представление количество свободных билетов на представление
 drop view if exists available_tickets;  
 create view available_tickets
  as select e.id, e.event_name, count(e.id) 
  from 
      events e join timetables t on t.event_id = e.id -- связываем сеансы и мероприятия
      join tickets t2 on t.id = t2.timetable_id 
  where t2.is_sold != true and t2.is_booked != true 
  group by e.id