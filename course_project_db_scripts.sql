-- курсовой проект
drop database if exists ticketland_db;
create database ticketland_db;
use ticketland_db;

DROP TABLE IF EXISTS cities;
CREATE TABLE cities (
  id serial primary key,
  city_name varchar(256) unique not null comment 'Название города'
) comment 'Справочник городов/населеных пунктов, при расширении системы на сёла надо будет ввести еще уровень областей, пока только уровень уникальных областных/республиканских  центров';



DROP TABLE IF EXISTS images;
CREATE TABLE images (
  id serial primary key,
  image_name varchar(256) comment 'Название изображения',
  image_file_name varchar(256) comment 'Место хранения графического файла изображения'
) comment 'Справочник изображний';

DROP TABLE IF EXISTS adresses;
CREATE TABLE adresses (
  id serial primary key,
  city_id bigint unsigned not null comment 'Идентификатор города',
  streename varchar (256) not null comment 'Имя улицы с дообавлением типа - если проезд/переулок и т.п.',
  building int unsigned not null comment 'Номер дома',
  korpus varchar(8) comment 'Номер корпуса, строения и т.п.',
  post_index bigint unsigned not null comment 'Почтовый индекс',
  geotag varchar (128) not null comment 'Геотэг. Окончательный формат хранения определить при интеграции с ГИС',
  index (city_id, streename) comment 'В городе не может быть одинаковых улиц',
  foreign key (city_id) references cities (id)
) comment 'Справочник адресов будем импортировать из федеральной информационной адресной системы в соответствии со структурой информации этой системы,т.е. структура этого справичника будет доработана при интеграции с ФИАС';


DROP TABLE IF EXISTS place_types;
CREATE TABLE place_types (
  id serial primary key,
  place_type_name varchar(256) unique not null comment 'Название типа мест/площадок: театры, цирки и т.п.'
) comment 'Справочник типов мест проведения мероприятий (театры, цирки, концертные залы и т.п.)';


DROP TABLE IF EXISTS places;
CREATE TABLE places (
 id serial primary key,
 place_name varchar(256) not null comment 'Название места/площадки',
 place_adress_id bigint unsigned not null comment 'Идентификатор адреса площадки',
 metro_station_name varchar (128) comment 'Название ближайшего метро. Возмможно изменение привязки к метро при интеграци с ГИС',
 logo_image_id bigint unsigned comment 'Идентификатор логотипа площадки',
 city_id bigint unsigned not null comment 'Дополнительно храним город, чтобы при фильтрации по городам не обращаться все время к большому справочнику адресов',
 place_type_id bigint unsigned not null comment 'Идентификатор типа площадки',
 unique (place_name, city_id) comment 'В городе не может быть площадок с одинаковыми назаниями',
 foreign key (city_id) references cities (id),
 foreign key (place_type_id) references place_types (id),
 foreign key (logo_image_id) references images (id),
 foreign key (place_adress_id) references adresses (id)
) comment 'Места/площадки проведения мероприятий';


DROP TABLE IF EXISTS place_platforms;
CREATE TABLE place_platforms (
 id serial primary key,
 platform_name varchar(256) unique not null comment 'Название сцены площадки',
 place_id bigint unsigned not null comment 'Идентификатор площадки',
 unique (platform_name, place_id) comment 'На площадке не может быть сцен с одинаковыми назаниями', 
 foreign key (place_id) references places (id)
) comment 'Сцены мест проведения мероприятий, например, центральный зал, малый зал и т.п.';

DROP TABLE IF EXISTS platform_parts;
CREATE TABLE platform_parts (
 id serial primary key,
 part_name varchar(256) not null comment 'Название части сцены',
 platform_id bigint unsigned not null comment 'Идентификатор сцены',
 unique (part_name, platform_id) comment 'На сцене не может быть частей с одинаковыми названиями', 
 foreign key (platform_id) references place_platforms (id)
) comment 'Части сцены, партер, балкон и т.п.';

DROP TABLE IF EXISTS platform_parts_maps;
CREATE TABLE platform_parts_maps (
 id serial primary key,
 part_id bigint unsigned not null comment 'Идентификатор части сцены площадки',
 row_num int unsigned not null comment 'Номер ряда',
 places_count int unsigned not null comment 'Количество мест в ряду',
 foreign key (part_id) references platform_parts (id)
) comment 'Карты частей сцены, задающие количество мест для каждого ряда';



DROP TABLE IF EXISTS event_types;
CREATE TABLE event_types (
  id serial primary key,
  event_name varchar(256) comment 'Название типа мероприятия концерты, спектакли, цирковые представления и т.п.'
  ) comment 'Справочник типов мероприятий: концерты, спектакли, цирковые представления и т.п.';
 
 
DROP TABLE IF EXISTS genres;
CREATE TABLE genres (
  id serial primary key,
  genre_name varchar(256) comment 'Название жанра типа мероприятия концерты, спектакли, цирковые представления и т.п.',
  event_type_id bigint unsigned not null comment 'Идентификатор типа мероприятия',
  foreign key (event_type_id) references event_types (id)
  ) comment 'Справочник жанров типов мероприятий: трагедия, поп-музыка, футбол и т.п.';

 
DROP TABLE IF EXISTS professions;
CREATE TABLE professions (
  id serial primary key,
  profession_name varchar(256) comment 'Название профессии/роли участника в мероприятии'
  ) comment 'Справочник профессий, ролей в мероприятии участников мероприятий';
 
 
 
 DROP TABLE IF EXISTS actors;
 CREATE TABLE actors (
  id serial primary key,
  actor_name varchar(64) comment 'Имя/фамилия актера/актрисы/участника мероприятия',
  photo_image_id bigint unsigned comment 'Идентификатор изображения фото актера/актрисы/участника мероприятия',
  actor_description text  comment 'Описание актера/актрисы/участника мероприятия',
  foreign key (photo_image_id) references images (id)
  ) comment 'Справочник типов мероприятий: концерты, спектакли, цирковые представления и т.п.';
 
 
DROP TABLE IF EXISTS age_permissions;
CREATE TABLE age_permissions (
  id serial primary key,
  age_permissions_name varchar(256)  comment 'Текстовое значение возрастного рзрешения, например 12+ и т.п.'
  ) comment 'Справочник возрастных разрешений для мероприятий';
 
 
DROP TABLE IF EXISTS events;
CREATE TABLE events (
 id serial primary key,
 event_name varchar(256) not null  comment 'Название мероприятия (название спектакля, концерта и т.д. т.п.)',
 place_id bigint unsigned not null comment 'Идентификатор места/площадки мероприятия',
 logo_image_id bigint unsigned not null comment 'Идентификатор изображения логотипа мероприятия',
 age_permissions_id bigint unsigned not null comment 'Идентификатор возрастного разрешения мероприятия',
 in_repertoire boolean comment 'Мероприятие еще в репертуаре?',
 event_description text comment 'Описание мероприятия',
 event_duration int unsigned not null comment 'Продолжительность мероприятия в минутах',
 avg_score float unsigned default 0 comment 'Средний рейтинг мероприятия пересчитывается при каждой вставке отзыва с баллом рейтинга',
 unique (event_name, place_id) comment 'На площадке не может быть больше одного мероприятия с одинаковым названием',
 foreign key (place_id) references places (id),
 foreign key (age_permissions_id) references age_permissions (id),
 foreign key (logo_image_id) references images (id)
) comment 'Перечень мероприятий (спектаклей, концертов и т.д. т.п.)';

 
DROP TABLE IF EXISTS timetables;
CREATE TABLE timetables (
  id serial primary key,
  event_id bigint unsigned not null comment 'Идентификатор мероприятия',
  begin_date date not null comment 'Дата начала сеанса мероприятия',
  begin_time time not null comment 'Время начала сеанса мероприятия',
  min_price bigint unsigned comment 'Текущая минимальная цена непроданных билето, инициализируется при генерации билетов, обновляется при каждой продаже билетов',
  max_price bigint unsigned comment 'Текущая максимальная цена непроданных билето, инициализируется при генерации билетов, обновляется при каждой продаже билетов',
  book_duration int unsigned comment 'Максимальное время брони билетов для этого сеанса в минутах',
  unique (event_id, begin_date, begin_time) comment 'Мероприятие может быть только одно в один момент начинаться, остальной контроль по времени начала и продолжительности мероприятия в триггере вставки сеанса', 
  index (begin_date) comment 'Для ускорения фильтров по дате сеансов',
  foreign key (event_id) references events (id)
  ) comment 'Таблица расписаний мероприятий (сеансов)';
 


DROP TABLE IF EXISTS event_to_types;
CREATE TABLE event_to_types (
  event_type_id bigint unsigned not null,
  event_id bigint unsigned not null,
  primary key (event_type_id, event_id),
  foreign key (event_type_id) references event_types (id),
  foreign key (event_id) references events (id)
  ) comment 'Одно мероприятие может быть классифицировано несколькими типами, поэтому формируем таблицу, реализующую связь много ко многим';
 


DROP TABLE IF EXISTS events_actors_events;
CREATE TABLE events_actors_events (
  event_id bigint unsigned not null,
  actor_id bigint unsigned not null,
  profession_id bigint unsigned not null,
  primary key (event_id, actor_id, profession_id),
  foreign key (profession_id) references professions (id),
  foreign key (event_id) references events (id),
  foreign key (actor_id) references actors (id)
  ) comment 'Таблица, реализующая связь много ко многим для связи мероприятия, участников мероприятия и профессий/ролей актеров в этом мерпориятии';
 
 
 
DROP TABLE IF EXISTS subscribers;
CREATE TABLE subscribers (
  id serial primary key,
  email varchar(120) unique not null comment 'Почта пользователя/подписчика сервиса',
  pass char(40) not null comment 'Пароль пользователя/подписчика сервиса',
  phone varchar(20) unique comment 'Телефон пользователя/подписчика сервиса',
  firstname varchar (50) not null comment 'Имя пользователя/подписчика сервиса',
  lastname varchar(50) not null comment 'Фамилия пользователя/подписчика сервиса',
  gender char(1) not null comment 'Пол пользователя/подписчика сервиса'
  ) comment 'Таблица пользователей/подписчиков сервиса';
 
 
 
DROP TABLE IF EXISTS ratings;
CREATE TABLE ratings (
  id serial primary key,
  rating_name varchar (64) unique comment 'Имя рейтинга, великолепно, отлично, хорошо и т.п.',
  score int unsigned not null comment 'Бальная оценка рейтинга для подсчета средней оцеки мероприятию',
  logo_rating_id bigint unsigned not null comment 'Изображение пиктограммы рейтинга', 
  foreign key (logo_rating_id) references images (id)
  ) comment 'Справочник рейтингов мероприятий, выставляемых в отзывах пользователей/подписчиков';
 
 
DROP TABLE IF EXISTS reviews;
CREATE TABLE reviews (
  id serial primary key,
  create_at datetime default now() comment 'Момент создания отзыва',
  subscriber_id bigint unsigned not null comment 'Иднтификатор того кто оставил отзыв',
  event_id bigint unsigned not null comment 'Идентификатор мероприятия на который дан отзыв',
  review_text text comment 'Текст отзыва',
  rating_id bigint unsigned not null comment 'Идентификатор проставленного рейтинга',
  foreign key (subscriber_id) references subscribers (id),
  foreign key (event_id) references events (id),
  foreign key (rating_id) references ratings (id)
    ) comment 'Таблица отзывов на мероприятия';
 

DROP TABLE IF EXISTS tickets;
CREATE TABLE tickets (
  id serial primary key,
  timetable_id bigint unsigned not null comment 'Идентификатор сеанса',
  platform_part_id bigint unsigned not null comment 'Идентификатор части зала',
  row_num int unsigned not null comment 'Номер ряда',
  place_num int unsigned not null comment 'Номер места',
  price int unsigned not null comment 'Цена билета',
  is_sold boolean not null default false comment 'Билет продан?',
  sale_datetime datetime comment 'Дата и время продажи билета',
  is_booked boolean not null default false comment 'Билет забронирован?',
  book_datetime datetime comment 'Дата и время начала брони билета',
  unique (timetable_id, platform_part_id, row_num, place_num) comment 'На одно место сеанса может быть только один билет',
  foreign key (timetable_id) references timetables (id),
  foreign key (platform_part_id) references platform_parts (id)
    ) comment 'Таблица билетов';