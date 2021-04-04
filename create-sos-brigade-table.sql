create table sos_brigade (
  id      integer      primary key
, name    varchar(255) not null
, memo    varchar(255) not null
, boss_id integer      references sos_brigade(id)
);
