-- Определить кто больше поставил лайков (всего) - мужчины или женщины?
select u.gender, count(*)
from users u, users_response ur -- выборка из таблицы пользователей и таблицы лайков пользователям
where u.id=ur.response_user_id_from -- связываем таблицы
group by u.gender -- группируем по гендеру.