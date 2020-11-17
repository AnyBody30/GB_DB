-- ��� ������ lessons_3_2
-- ������� ����� ������
drop table if exists response_types; 
create table response_types( 
	id serial primary key,
	response_name varchar(200) not null, -- ��� �����
	description text,-- �������� �����
	response_icon_filename varchar(200) not null -- ��� ����� ������ ���� �����
);

-- ������� ������ �������������
drop table if exists users_response; 
create table users_response( 
	response_user_id_to bigint unsigned not null, -- ���� ����
	response_user_id_from bigint unsigned not null, -- �� ���� ����
	response_type_id  bigint unsigned not null, -- ��� �����
	primary key (response_user_id_to, response_user_id_from), -- ����� ���� �� ����� ������ ����� ������ ���� �� ������������ ������������ 
	foreign key (response_user_id_to) references users (id),
	foreign key (response_user_id_from) references users (id),
	foreign key (response_type_id) references response_types (id)	
);


-- ������� ������ ������
drop table if exists posts_response; 
create table posts_response( 
	response_post_id_to bigint unsigned not null, -- ������ ����� ����
	response_user_id_from bigint unsigned not null, -- �� ���� ����
	response_type_id  bigint unsigned not null, -- ��� �����
	primary key (response_post_id_to, response_user_id_from), -- ����� ���� �� ����� ������ ����� ������ ���� �� ������������ ����������� ����� 
	foreign key (response_post_id_to) references posts (id),
	foreign key (response_user_id_from) references users (id),
	foreign key (response_type_id) references response_types (id)	
);

-- ������� ������ �����������
drop table if exists photos_response; 
create table photos_response( 
	response_photo_id_to bigint unsigned not null, -- ����q ���� ����
	response_user_id_from bigint unsigned not null, -- �� ���� ����
	response_type_id  bigint unsigned not null, -- ��� �����
	primary key (response_photo_id_to, response_user_id_from), -- ����� ���� �� ����� ������ ����� ������ ���� �� ������������ ����������� ���� 
	foreign key (response_photo_id_to) references photos (id),
	foreign key (response_user_id_from) references users (id),
	foreign key (response_type_id) references response_types (id)	
);