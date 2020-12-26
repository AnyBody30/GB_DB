-- �������� ������
drop database if exists ticketland_db;
create database ticketland_db;
use ticketland_db;

DROP TABLE IF EXISTS cities;
CREATE TABLE cities (
  id serial primary key,
  city_name varchar(256) unique not null comment '�������� ������'
) comment '���������� �������/��������� �������, ��� ���������� ������� �� ��� ���� ����� ������ ��� ������� ��������, ���� ������ ������� ���������� ���������/���������������  �������';



DROP TABLE IF EXISTS images;
CREATE TABLE images (
  id serial primary key,
  image_name varchar(256) comment '�������� �����������',
  image_file_name varchar(256) comment '����� �������� ������������ ����� �����������'
) comment '���������� ����������';

DROP TABLE IF EXISTS adresses;
CREATE TABLE adresses (
  id serial primary key,
  city_id bigint unsigned not null comment '������������� ������',
  streename varchar (256) not null comment '��� ����� � ������������ ���� - ���� ������/�������� � �.�.',
  building int unsigned not null comment '����� ����',
  korpus varchar(8) comment '����� �������, �������� � �.�.',
  post_index bigint unsigned not null comment '�������� ������',
  geotag varchar (128) not null comment '������. ������������� ������ �������� ���������� ��� ���������� � ���',
  index (city_id, streename) comment '� ������ �� ����� ���� ���������� ����',
  foreign key (city_id) references cities (id)
) comment '���������� ������� ����� ������������� �� ����������� �������������� �������� ������� � ������������ �� ���������� ���������� ���� �������,�.�. ��������� ����� ����������� ����� ���������� ��� ���������� � ����';


DROP TABLE IF EXISTS place_types;
CREATE TABLE place_types (
  id serial primary key,
  place_type_name varchar(256) unique not null comment '�������� ���� ����/��������: ������, ����� � �.�.'
) comment '���������� ����� ���� ���������� ����������� (������, �����, ���������� ���� � �.�.)';


DROP TABLE IF EXISTS places;
CREATE TABLE places (
 id serial primary key,
 place_name varchar(256) not null comment '�������� �����/��������',
 place_adress_id bigint unsigned not null comment '������������� ������ ��������',
 metro_station_name varchar (128) comment '�������� ���������� �����. ��������� ��������� �������� � ����� ��� ��������� � ���',
 logo_image_id bigint unsigned comment '������������� �������� ��������',
 city_id bigint unsigned not null comment '������������� ������ �����, ����� ��� ���������� �� ������� �� ���������� ��� ����� � �������� ����������� �������',
 place_type_id bigint unsigned not null comment '������������� ���� ��������',
 unique (place_name, city_id) comment '� ������ �� ����� ���� �������� � ����������� ���������',
 foreign key (city_id) references cities (id),
 foreign key (place_type_id) references place_types (id),
 foreign key (logo_image_id) references images (id),
 foreign key (place_adress_id) references adresses (id)
) comment '�����/�������� ���������� �����������';


DROP TABLE IF EXISTS place_platforms;
CREATE TABLE place_platforms (
 id serial primary key,
 platform_name varchar(256) unique not null comment '�������� ����� ��������',
 place_id bigint unsigned not null comment '������������� ��������',
 unique (platform_name, place_id) comment '�� �������� �� ����� ���� ���� � ����������� ���������', 
 foreign key (place_id) references places (id)
) comment '����� ���� ���������� �����������, ��������, ����������� ���, ����� ��� � �.�.';

DROP TABLE IF EXISTS platform_parts;
CREATE TABLE platform_parts (
 id serial primary key,
 part_name varchar(256) not null comment '�������� ����� �����',
 platform_id bigint unsigned not null comment '������������� �����',
 unique (part_name, platform_id) comment '�� ����� �� ����� ���� ������ � ����������� ����������', 
 foreign key (platform_id) references place_platforms (id)
) comment '����� �����, ������, ������ � �.�.';

DROP TABLE IF EXISTS platform_parts_maps;
CREATE TABLE platform_parts_maps (
 id serial primary key,
 part_id bigint unsigned not null comment '������������� ����� ����� ��������',
 row_num int unsigned not null comment '����� ����',
 places_count int unsigned not null comment '���������� ���� � ����',
 foreign key (part_id) references platform_parts (id)
) comment '����� ������ �����, �������� ���������� ���� ��� ������� ����';



DROP TABLE IF EXISTS event_types;
CREATE TABLE event_types (
  id serial primary key,
  event_name varchar(256) comment '�������� ���� ����������� ��������, ���������, �������� ������������� � �.�.'
  ) comment '���������� ����� �����������: ��������, ���������, �������� ������������� � �.�.';
 
 
DROP TABLE IF EXISTS genres;
CREATE TABLE genres (
  id serial primary key,
  genre_name varchar(256) comment '�������� ����� ���� ����������� ��������, ���������, �������� ������������� � �.�.',
  event_type_id bigint unsigned not null comment '������������� ���� �����������',
  foreign key (event_type_id) references event_types (id)
  ) comment '���������� ������ ����� �����������: ��������, ���-������, ������ � �.�.';

 
DROP TABLE IF EXISTS professions;
CREATE TABLE professions (
  id serial primary key,
  profession_name varchar(256) comment '�������� ���������/���� ��������� � �����������'
  ) comment '���������� ���������, ����� � ����������� ���������� �����������';
 
 
 
 DROP TABLE IF EXISTS actors;
 CREATE TABLE actors (
  id serial primary key,
  actor_name varchar(64) comment '���/������� ������/�������/��������� �����������',
  photo_image_id bigint unsigned comment '������������� ����������� ���� ������/�������/��������� �����������',
  actor_description text  comment '�������� ������/�������/��������� �����������',
  foreign key (photo_image_id) references images (id)
  ) comment '���������� ����� �����������: ��������, ���������, �������� ������������� � �.�.';
 
 
DROP TABLE IF EXISTS age_permissions;
CREATE TABLE age_permissions (
  id serial primary key,
  age_permissions_name varchar(256)  comment '��������� �������� ����������� ���������, �������� 12+ � �.�.'
  ) comment '���������� ���������� ���������� ��� �����������';
 
 
DROP TABLE IF EXISTS events;
CREATE TABLE events (
 id serial primary key,
 event_name varchar(256) not null  comment '�������� ����������� (�������� ���������, �������� � �.�. �.�.)',
 place_id bigint unsigned not null comment '������������� �����/�������� �����������',
 logo_image_id bigint unsigned not null comment '������������� ����������� �������� �����������',
 age_permissions_id bigint unsigned not null comment '������������� ����������� ���������� �����������',
 in_repertoire boolean comment '����������� ��� � ����������?',
 event_description text comment '�������� �����������',
 event_duration int unsigned not null comment '����������������� ����������� � �������',
 avg_score float unsigned default 0 comment '������� ������� ����������� ��������������� ��� ������ ������� ������ � ������ ��������',
 unique (event_name, place_id) comment '�� �������� �� ����� ���� ������ ������ ����������� � ���������� ���������',
 foreign key (place_id) references places (id),
 foreign key (age_permissions_id) references age_permissions (id),
 foreign key (logo_image_id) references images (id)
) comment '�������� ����������� (����������, ��������� � �.�. �.�.)';

 
DROP TABLE IF EXISTS timetables;
CREATE TABLE timetables (
  id serial primary key,
  event_id bigint unsigned not null comment '������������� �����������',
  begin_date date not null comment '���� ������ ������ �����������',
  begin_time time not null comment '����� ������ ������ �����������',
  min_price bigint unsigned comment '������� ����������� ���� ����������� ������, ���������������� ��� ��������� �������, ����������� ��� ������ ������� �������',
  max_price bigint unsigned comment '������� ������������ ���� ����������� ������, ���������������� ��� ��������� �������, ����������� ��� ������ ������� �������',
  book_duration int unsigned comment '������������ ����� ����� ������� ��� ����� ������ � �������',
  unique (event_id, begin_date, begin_time) comment '����������� ����� ���� ������ ���� � ���� ������ ����������, ��������� �������� �� ������� ������ � ����������������� ����������� � �������� ������� ������', 
  index (begin_date) comment '��� ��������� �������� �� ���� �������',
  foreign key (event_id) references events (id)
  ) comment '������� ���������� ����������� (�������)';
 


DROP TABLE IF EXISTS event_to_types;
CREATE TABLE event_to_types (
  event_type_id bigint unsigned not null,
  event_id bigint unsigned not null,
  primary key (event_type_id, event_id),
  foreign key (event_type_id) references event_types (id),
  foreign key (event_id) references events (id)
  ) comment '���� ����������� ����� ���� ���������������� ����������� ������, ������� ��������� �������, ����������� ����� ����� �� ������';
 


DROP TABLE IF EXISTS events_actors_events;
CREATE TABLE events_actors_events (
  event_id bigint unsigned not null,
  actor_id bigint unsigned not null,
  profession_id bigint unsigned not null,
  primary key (event_id, actor_id, profession_id),
  foreign key (profession_id) references professions (id),
  foreign key (event_id) references events (id),
  foreign key (actor_id) references actors (id)
  ) comment '�������, ����������� ����� ����� �� ������ ��� ����� �����������, ���������� ����������� � ���������/����� ������� � ���� �����������';
 
 
 
DROP TABLE IF EXISTS subscribers;
CREATE TABLE subscribers (
  id serial primary key,
  email varchar(120) unique not null comment '����� ������������/���������� �������',
  pass char(40) not null comment '������ ������������/���������� �������',
  phone varchar(20) unique comment '������� ������������/���������� �������',
  firstname varchar (50) not null comment '��� ������������/���������� �������',
  lastname varchar(50) not null comment '������� ������������/���������� �������',
  gender char(1) not null comment '��� ������������/���������� �������'
  ) comment '������� �������������/����������� �������';
 
 
 
DROP TABLE IF EXISTS ratings;
CREATE TABLE ratings (
  id serial primary key,
  rating_name varchar (64) unique comment '��� ��������, �����������, �������, ������ � �.�.',
  score int unsigned not null comment '������� ������ �������� ��� �������� ������� ����� �����������',
  logo_rating_id bigint unsigned not null comment '����������� ����������� ��������', 
  foreign key (logo_rating_id) references images (id)
  ) comment '���������� ��������� �����������, ������������ � ������� �������������/�����������';
 
 
DROP TABLE IF EXISTS reviews;
CREATE TABLE reviews (
  id serial primary key,
  create_at datetime default now() comment '������ �������� ������',
  subscriber_id bigint unsigned not null comment '������������ ���� ��� ������� �����',
  event_id bigint unsigned not null comment '������������� ����������� �� ������� ��� �����',
  review_text text comment '����� ������',
  rating_id bigint unsigned not null comment '������������� �������������� ��������',
  foreign key (subscriber_id) references subscribers (id),
  foreign key (event_id) references events (id),
  foreign key (rating_id) references ratings (id)
    ) comment '������� ������� �� �����������';
 

DROP TABLE IF EXISTS tickets;
CREATE TABLE tickets (
  id serial primary key,
  timetable_id bigint unsigned not null comment '������������� ������',
  platform_part_id bigint unsigned not null comment '������������� ����� ����',
  row_num int unsigned not null comment '����� ����',
  place_num int unsigned not null comment '����� �����',
  price int unsigned not null comment '���� ������',
  is_sold boolean not null default false comment '����� ������?',
  sale_datetime datetime comment '���� � ����� ������� ������',
  is_booked boolean not null default false comment '����� ������������?',
  book_datetime datetime comment '���� � ����� ������ ����� ������',
  unique (timetable_id, platform_part_id, row_num, place_num) comment '�� ���� ����� ������ ����� ���� ������ ���� �����',
  foreign key (timetable_id) references timetables (id),
  foreign key (platform_part_id) references platform_parts (id)
    ) comment '������� �������';