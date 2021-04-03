-- 本
create table books (
  id    integer      primary key
, title varchar(255) not null
);
-- 著者
create table authors (
  id   integer      primary key
, name varchar(255) not null
);
-- 執筆
create table writings (
  book_id   integer references books(id)
, author_id integer references authors(id)
, role varchar(255)
, primary key (book_id, author_id)
);
create index writings_author_id_idx on writings(author_id);
