-- ���������������� �������, ������� ����������� �� �������, ���������� ��������� ������������� �/��� ��������� (JOIN ���� �� ���������).

-- ������������ �������� ������������. 
-- ��������� �� ����������� union

-- ���� 
select 
	firstname,
	lastname,
	hometown,
	(select filename from photos where id = u.photo_id) as 'personal_photo',
	(select count(*) from (select initiator_user_id from friend_requests where target_user_id = u.id and status = 'approved'
		union
	select target_user_id from friend_requests where initiator_user_id = u.id and status = 'approved') as fr_list) as 'friends',
	(select count(*) from friend_requests where target_user_id = u.id and status ='requested') as 'followers',
	(select count(*) from photos where user_id = u.id) 'photos'
from users as u 
where id = 21;

-- ����� 
select 
	firstname,
	lastname,
	hometown,
	(select filename from photos where id = u.photo_id) as 'personal_photo',
	(select count(*) from (select * from friend_requests where (target_user_id = u.id or initiator_user_id = u.id) and status = 'approved')as fr) as 'friends',
	(select count(*) from friend_requests where target_user_id = u.id and status ='requested') as 'followers',
	(select count(*) from photos where user_id = u.id) 'photos'
from users as u
where id = 21;


-- ---------------------------------------------------------------------------------------------------------------------------------

-- ������ ������ ������������ 1 � ��������� ���� � ��������. 
-- ������� ���� ����������� case �� ����������� union.

-- ����
select  
	firstname,
	lastname,
	timestampdiff(year, birthday, now()) as age,
	case(gender)
		when 'm' then '�������'
		when 'f' then '�������'
	end as 'gender'
from users where id in (select * from (
select 
	case
		when initiator_user_id = 1 and status = 'approved' then target_user_id
		when target_user_id = 1 and status = 'approved' then initiator_user_id
	end as friend_id
from friend_requests) as fr_list where friend_id is not null);

-- �����
select  
	firstname,
	lastname,
	timestampdiff(year, birthday, now()) as age,
	case(gender)
		when 'm' then '�������'
		when 'f' then '�������'
	end as 'gender'
from users where id in
(select target_user_id from friend_requests where initiator_user_id = 1 and status = 'approved'
union 
select initiator_user_id from friend_requests where target_user_id = 1 and status = 'approved');

-- ---------------------------------------------------------------------------------------------------------------------------------

-- ������ ������������� ���������, ������������ ������������. 
-- ����� ���������

-- ����
select
	(select concat(firstname, ' ', lastname) from users where id = m.from_user_id) from_user,
	message,
	create_at 
from messages m
where to_user_id = 30 and is_read = 0;

-- �����
select
	concat(u.firstname, ' ', u.lastname),
	m.message,
	m.create_at 
from messages m, users u
where m.to_user_id = 30 and m.is_read = 0 and u.id = m.from_user_id;


-- ---------------------------------------------------------------------------------------------------------------------------------

-- ���-�� ������������� ���������, ������������ ������������ �� ������
-- ��������� �� ������ ����������

-- ����
select
	(select concat(firstname, ' ', lastname) from users where id = m.from_user_id) from_user,
	count(*) as total_msg 
from messages m
where 
	from_user_id in (select initiator_user_id from friend_requests where target_user_id = m.to_user_id and status = 'approved'
		union
	select target_user_id from friend_requests where initiator_user_id = m.to_user_id and status = 'approved') 
and
	to_user_id = 30 
and is_read = 0 
group by m.from_user_id order by total_msg desc;

-- �����
select
	concat(u.firstname, ' ', u.lastname) as fi,
	count(*) as total_msg 
from messages m, users u
where 
m.from_user_id in
	(select initiator_user_id from friend_requests where target_user_id = m.to_user_id and status = 'approved'
		union
	select target_user_id from friend_requests where initiator_user_id = m.to_user_id and status = 'approved') 
and	m.to_user_id = 30
and m.is_read = 0 
and u.id = m.from_user_id
group by m.from_user_id order by total_msg desc;



-- ---------------------------------------------------------------------------------------------------------------------------------

-- ������� ���������� ������, �������������� ������ �������������
-- ����������� � ���� �������� �������� �������� ���������� ������, ������������� ������ �������������

-- ����
select avg(total_user_posts) from (select count(*) as total_user_posts  from posts group by user_id) as total_users_posts_tbl;

-- �����
select 
(select count(post) as total_user_posts  from posts group by user_id with rollup order by total_user_posts desc limit 1) / -- ����� ������ ��������������� �� �������������
(select distinct count(user_id) from posts) -- ���������� �������������

