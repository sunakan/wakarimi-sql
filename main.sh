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
psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c 'drop table members;' || echo 'ok'
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

# group by
psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "select gender, to_char(avg(height), '999.99') from members group by gender;"


# '5.11 1'
echo '====[ 5.11 1 ]'
readonly query5_11_1="select gender, count(id), to_char(avg(height), '999.99') from members group by gender;"
psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "${query5_11_1}"
# 5.11 2
echo '====[ 5.11 2 ]'
readonly query5_11_2="select gender, max(height), min(height), max(height)-min(height) from members group by gender order by gender desc;"
psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "${query5_11_2}"
# 5.11 3
echo '====[ 5.11 3 ]'
readonly query5_11_3_1="select count(gender) from members group by gender having gender = 'M';"
readonly query5_11_3_2="select count(gender) from members where gender = 'M';"
psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "${query5_11_3_1}"
psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "${query5_11_3_2}"
echo 'group byとhaving byを使った場合、男女両方を集計している（女子は集計不要なのに）'
echo 'なので、パフォーマンス的にはwhereを使ったほうが高速'
# 5.11 4
echo '====[ 5.11 4 ]'

# drop table
psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c 'drop table members;'
