-- ���������� ����� ���������� ������, ������� �������� 10 ����� ������� �������������.


-- � ������� ��������� ���� ������� ������ �������������, ������� ��������� � ���������� ��������:
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


select count(*) -- ������� ����� ���������� ��������� ������ ������������
from users_response ur -- ������� �� ������� ������ �������������
where ur.response_user_id_to in -- ��������� ������ ��� ���� ��������� ����� �� ������ id ����� ������� �������������
								(	select yang_list.uid -- �������� id 10 ����� �������
									from 
											-- ������� 10 ����� ������� ����� ���������� �� ����������� �������� � ���� � ����������� ������ ������ 10 �����
											(select u.id as uid, timestampdiff(day, u.birthday, now()) as age_in_days
												from users u
												order by age_in_days
												limit 10) as yang_list
								);