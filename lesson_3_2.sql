-- моя работа lessons_3_2
-- таблица типов лайков
drop table if exists response_types; 
create table response_types( 
	id serial primary key,
	response_name varchar(200) not null, -- имя лайка
	description text,-- описание лайка
	response_icon_filename varchar(200) not null -- имя файла иконки типа лайка
);

-- таблица лайков пользователям
drop table if exists users_response; 
create table users_response( 
	response_user_id_to bigint unsigned not null, -- кому лайк
	response_user_id_from bigint unsigned not null, -- от кого лайк
	response_type_id  bigint unsigned not null, -- тип лайка
	primary key (response_user_id_to, response_user_id_from), -- может быть не более одного лайка любого типа от пользователя пользователю 
	foreign key (response_user_id_to) references users (id),
	foreign key (response_user_id_from) references users (id),
	foreign key (response_type_id) references response_types (id)	
);


-- таблица лайков постам
drop table if exists posts_response; 
create table posts_response( 
	response_post_id_to bigint unsigned not null, -- какому посту лайк
	response_user_id_from bigint unsigned not null, -- от кого лайк
	response_type_id  bigint unsigned not null, -- тип лайка
	primary key (response_post_id_to, response_user_id_from), -- может быть не более одного лайка любого типа от пользователя конкретному посту 
	foreign key (response_post_id_to) references posts (id),
	foreign key (response_user_id_from) references users (id),
	foreign key (response_type_id) references response_types (id)	
);

-- таблица лайков фотографиям
drop table if exists photos_response; 
create table photos_response( 
	response_photo_id_to bigint unsigned not null, -- какоq фото лайк
	response_user_id_from bigint unsigned not null, -- от кого лайк
	response_type_id  bigint unsigned not null, -- тип лайка
	primary key (response_photo_id_to, response_user_id_from), -- может быть не более одного лайка любого типа от пользователя конкретному фото 
	foreign key (response_photo_id_to) references photos (id),
	foreign key (response_user_id_from) references users (id),
	foreign key (response_type_id) references response_types (id)	
);