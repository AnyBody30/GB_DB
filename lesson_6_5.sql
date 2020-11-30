-- ����� 10 �������������, ������� ��������� ���������� ���������� � ������������� ���������� ����.

select act.uid as uid, u.firstname, u.lastname, sum(cnt) as sum_activity
from -- ��������� ����������� all ������� ���������� - ���������� � ������������ �� user id
(
-- ������� ��� �������� ������ ������������� � ����� 1
select response_user_id_from as uid, count(*) as cnt from users_response ur group by response_user_id_from
union all
-- � �������� ����������� ��� ��������� � ����� 2
select user_id, count(*)*2 from users_communities uc group by user_id -- 
union all 
-- ������� ��� �������� ������ ������ � ����� 3
select response_user_id_from, count(*)*3 from posts_response pr group by response_user_id_from
union all
-- ������� ��� ����������� ������ � ����� 4
select user_id, count(*)*4 from posts group by user_id
union all
-- ������� ��� ������� ��������� ������������� � ����� 5
select from_user_id, count(*)*5 from messages group by from_user_id
union all
-- ������� ��� �������� �������� �� ������ � ����� 6
select initiator_user_id, count(*)*6 from friend_requests fr group by initiator_user_id
union all
-- ������� ��� ������� ������������ � ����� 7
select user_id, count(*)*7 from comments group by user_id) as act,
users u
where u.id = act.uid -- ��������� ������� ������������� � ������������ ���������� ��� ������� ����� � �������
group by act.uid -- ���������� �� ������������� ����������� ����������
order by sum_activity -- ��������� �� ����������� ����� ����������� �������������
limit 10 -- ������� 10 ������ ������� � ����������� ��������� �����������