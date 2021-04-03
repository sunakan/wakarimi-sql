-- 映画
create table movies (
  movie_id integer primary key
, title    text    not null unique
);

-- キャラクター
create table characters (
  id       integer primary key
, movie_id integer references movies(movie_id)
, name     text    not null
, gender   char(1) not null
);
