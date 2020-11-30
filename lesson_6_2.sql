-- ����� ����� ��������� ������������. 
-- �� ���� ������ ����� ������������ ������� ��������, ������� ������ ���� ������� � ����� �������������.


set @user_id = 32; -- ������ ������������
select  fr_list.initiator_user_id as uid, 
		u.firstname as '��� �����', 
		u.lastname '������� �����', 
		count(fr_list.initiator_user_id) as cnt 
from 
-- ������ ������� ������
	(select initiator_user_id from friend_requests where target_user_id = @user_id and status = 'approved'
	union
	select target_user_id from friend_requests where initiator_user_id=@user_id and status = 'approved') as fr_list,
	messages m,
	users u
where 
	(((fr_list.initiator_user_id = m.from_user_id) and m.to_user_id= @user_id)or -- ��������� ��������� ������ ��� ��������� �� ����� ������������
	((fr_list.initiator_user_id = m.to_user_id)  and m.from_user_id= @user_id)) -- ��� �� ����������� �����
	and m.is_read = 1 -- ������� ��������� ������ ���� ��������� ���������
	and u.id = fr_list.initiator_user_id -- ���������, ����� ������� ��� � ������� �����
group by fr_list.initiator_user_id -- ���������� �� �������
order by cnt desc -- ��������� �� �������� ����������
limit 1; -- ������� ������ ������ ������ � ������������ ������