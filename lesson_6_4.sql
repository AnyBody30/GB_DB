-- ���������� ��� ������ �������� ������ (�����) - ������� ��� �������?
select u.gender, count(*)
from users u, users_response ur -- ������� �� ������� ������������� � ������� ������ �������������
where u.id=ur.response_user_id_from -- ��������� �������
group by u.gender -- ���������� �� �������.