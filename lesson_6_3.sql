-- Подсчитать общее количество лайков, которые получили 10 самых молодых пользователей.


-- В выборке использую свою таблицу лайков пользователям, которую определил в предыдущих заданиях:
/*CREATE TABLE `users_response` (
  `response_user_id_to` bigint unsigned NOT NULL,
  `response_user_id_from` bigint unsigned NOT NULL,
  `response_type_id` bigint unsigned NOT NULL,
  PRIMARY KEY (`response_user_id_to`,`response_user_id_from`),
  KEY `response_user_id_from` (`response_user_id_from`),
  KEY `response_type_id` (`response_type_id`),
  CONSTRAINT `users_response_ibfk_1` FOREIGN KEY (`response_user_id_to`) REFERENCES `users` (`id`),
  CONSTRAINT `users_response_ibfk_2` FOREIGN KEY (`response_user_id_from`) REFERENCES `users` (`id`),
  CONSTRAINT `users_response_ibfk_3` FOREIGN KEY (`response_type_id`) REFERENCES `response_types` (`id`)
*/


select count(*) -- считаем общее количество выбранных лайков пользоватлям
from users_response ur -- выборка из таблицы лайков пользователям
where ur.response_user_id_to in -- фильтруем только тех кому поставили лайки из списка id самых молодых пользователей
								(	select yang_list.uid -- выбираем id 10 самых мододых
									from 
											-- выводим 10 самых малодых путем сортировки по возрастанию возраста в днях и ограничнием вывода первых 10 строк
											(select u.id as uid, timestampdiff(day, u.birthday, now()) as age_in_days
												from users u
												order by age_in_days
												limit 10) as yang_list
								);