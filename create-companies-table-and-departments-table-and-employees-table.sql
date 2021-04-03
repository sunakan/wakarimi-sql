-- 会社
create table companies (
  id   integer      primary key
, name varchar(255) not null unique
);

-- 部署
create table departments (
  id         integer      primary key
, name       varchar(255) not null unique
, company_id integer not null references companies(id)
);

-- 社員
create table employees (
  id      integer      primary key
, name    varchar(255) not null unique
, dept_id integer      not null references departments(id)
)
