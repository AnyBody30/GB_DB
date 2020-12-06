-- lesson_7

-- Составьте список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине.
select distinct u.name 
from orders o
join users u
on o.user_id = u.id

-- Выведите список товаров products и разделов catalogs, который соответствует товару.
select c.name, p.name, p.description, p.price 
from products p 
left join catalogs c 
on p.catalog_id = c.id 

-- (по желанию) Пусть имеется таблица рейсов flights (id, from, to) и таблица городов cities (label, name). Поля from, to и label содержат английские названия городов, поле name — русское. Выведите список рейсов flights с русскими названиями городов.
select f.id as 'Номер рейса', c1.name as 'Вылет из', c2.name as 'Прилёт в'
from flights f
join cicties c1
on f.`from` = c1.label
join cicties c2
on f.`to` = c2.label 