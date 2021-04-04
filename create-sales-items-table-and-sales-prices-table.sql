create table sales_items (
   id   serial       primary key
,  name varchar(255) not null unique
);

create table sales_prices (
  item_id    integer not null references sales_items(id)
, start_date date    not null
, price      integer not null
, primary key (item_id, start_date)
);
