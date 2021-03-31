#!/bin/sh
set -eu

readonly DB_HOST=db
readonly DB_USER=user1
readonly DB_PASS=pass1
readonly DB_NAME=testdb1

# create user
psql -h ${DB_HOST} -U postgres -d postgres -c "create user ${DB_USER} with password '${DB_PASS}'" \
  || echo "${DB_USER}は作成済み"
# show user list
psql -h ${DB_HOST} -U postgres -d postgres -c "\du"

# create db
createdb -h ${DB_HOST} -U postgres -O ${DB_USER} -E UTF8 --locale=C -T template0 testdb1 \
  || echo "${DB_NAME}は作成済み"
# show db list
psql -h ${DB_HOST} -U postgres -l

# create members table
psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -f ./create-members-table.sql
# insert test data
psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "insert into members(id, name, height, gender) values (101, 'エレン',   170, 'M');"
psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "insert into members(id, name, height, gender) values (102, 'ミカサ',   170, 'F');"
psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "insert into members(id, name, height, gender) values (103, 'アルミン', 163, 'M');"
psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "insert into members(id, name, height, gender) values (104, 'ジャン',   175, 'M');"
psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "insert into members(id, name, height, gender) values (105, 'サシャ',   168, 'F');"
psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "insert into members(id, name, height, gender) values (106, 'コニー',   158, 'M');"
# select
psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "select * from members order by id"



# drop table
psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c 'drop table members;'
