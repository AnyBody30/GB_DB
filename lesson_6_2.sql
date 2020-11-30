-- Пусть задан некоторый пользователь. 
-- Из всех друзей этого пользователя найдите человека, который больше всех общался с нашим пользователем.


set @user_id = 32; -- задаем пользователя
select  fr_list.initiator_user_id as uid, 
		u.firstname as 'Имя друга', 
		u.lastname 'Фамилия друга', 
		count(fr_list.initiator_user_id) as cnt 
from 
-- делаем выборку друзей
	(select initiator_user_id from friend_requests where target_user_id = @user_id and status = 'approved'
	union
	select target_user_id from friend_requests where initiator_user_id=@user_id and status = 'approved') as fr_list,
	messages m,
	users u
where 
	(((fr_list.initiator_user_id = m.from_user_id) and m.to_user_id= @user_id)or -- фильтруем сообщения друзей где сообщение от друга пользователю
	((fr_list.initiator_user_id = m.to_user_id)  and m.from_user_id= @user_id)) -- или от пользовтеля другу
	and m.is_read = 1 -- общение считается только если сообщение прочитано
	and u.id = fr_list.initiator_user_id -- связываем, чтобы вывести имя и фамилию друга
group by fr_list.initiator_user_id -- группируем по друзьям
order by cnt desc -- сортируем по убыванию количества
limit 1; -- выводим только первую строку с максимальным числом