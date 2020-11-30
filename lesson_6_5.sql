-- Найти 10 пользователей, которые проявляют наименьшую активность в использовании социальной сети.

select act.uid as uid, u.firstname, u.lastname, sum(cnt) as sum_activity
from -- формируем объединение all выборки активности - количество с группировкой по user id
(
-- сколько кто поставил лайков пользователям с весом 1
select response_user_id_from as uid, count(*) as cnt from users_response ur group by response_user_id_from
union all
-- в скольких сообществах кто участвует с весом 2
select user_id, count(*)*2 from users_communities uc group by user_id -- 
union all 
-- сколько кто поставил лайков постам с весом 3
select response_user_id_from, count(*)*3 from posts_response pr group by response_user_id_from
union all
-- сколько кто опубликовал постов с весом 4
select user_id, count(*)*4 from posts group by user_id
union all
-- сколько кто написал сообщений пользователям с весом 5
select from_user_id, count(*)*5 from messages group by from_user_id
union all
-- сколько кто отправил запросов на дружбу с весом 6
select initiator_user_id, count(*)*6 from friend_requests fr group by initiator_user_id
union all
-- сколько кто оставил комментариев с весом 7
select user_id, count(*)*7 from comments group by user_id) as act,
users u
where u.id = act.uid -- связываем таблицу пользователей с объединением активности для выборки имени и фамилии
group by act.uid -- группируем по пользователям объединения активности
order by sum_activity -- сортируем по возрастанию суммы активностей пользователей
limit 10 -- выводим 10 первых записей с минимальной суммарной активностью