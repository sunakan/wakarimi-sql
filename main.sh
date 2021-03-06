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
psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c 'drop table characters;' || echo 'ok'
psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c 'drop table movies;' || echo 'ok'
psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -f ./create-members-table.sql
## insert test data
psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "insert into members(id, name, height, gender) values (101, 'エレン',   170, 'M');"
psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "insert into members(id, name, height, gender) values (102, 'ミカサ',   170, 'F');"
psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "insert into members(id, name, height, gender) values (103, 'アルミン', 163, 'M');"
psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "insert into members(id, name, height, gender) values (104, 'ジャン',   175, 'M');"
psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "insert into members(id, name, height, gender) values (105, 'サシャ',   168, 'F');"
psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "insert into members(id, name, height, gender) values (106, 'コニー',   158, 'M');"
## select
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "select * from members order by id"
## group by
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "select gender, to_char(avg(height), '999.99') from members group by gender;"
## create charcters table
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -f ./create-movies-table-and-characters-table.sql
## insert test data
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "insert into movies (movie_id, title) values (93, '風の谷のナウシカ');"
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "insert into movies (movie_id, title) values (94, '天空の城ラピュタ');"
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "insert into movies (movie_id, title) values (95, 'となりのトトロ');"
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "insert into movies (movie_id, title) values (96, '崖の上のポニョ');"
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "insert into characters (id, movie_id, name, gender) values (401, 93,   'ナウシカ', 'F');"
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "insert into characters (id, movie_id, name, gender) values (402, 94,   'パズー',   'M');"
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "insert into characters (id, movie_id, name, gender) values (403, 94,   'シータ',   'F');"
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "insert into characters (id, movie_id, name, gender) values (404, 94,   'ムスカ',   'M');"
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "insert into characters (id, movie_id, name, gender) values (405, 95,   'さつき',   'F');"
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "insert into characters (id, movie_id, name, gender) values (406, 95,   'メイ',     'F');"
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "insert into characters (id, movie_id, name, gender) values (407, null, 'クラリス', 'F');"
#
#
## '5.11 1'
#echo '====[ 5.11 1 ]'
#readonly query5_11_1="select gender, count(id), to_char(avg(height), '999.99') from members group by gender;"
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "${query5_11_1}"
## 5.11 2
#echo '====[ 5.11 2 ]'
#readonly query5_11_2="select gender, max(height), min(height), max(height)-min(height) from members group by gender order by gender desc;"
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "${query5_11_2}"
## 5.11 3
#echo '====[ 5.11 3 ]'
#readonly query5_11_3_1="select count(gender) from members group by gender having gender = 'M';"
#readonly query5_11_3_2="select count(gender) from members where gender = 'M';"
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "${query5_11_3_1}"
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "${query5_11_3_2}"
#echo 'group byとhaving byを使った場合、男女両方を集計している（女子は集計不要なのに）'
#echo 'なので、パフォーマンス的にはwhereを使ったほうが高速'
## 5.11 4
#echo '====[ 5.11 4 ]'
#echo '集約関数を使うにはgroup by句によるグループ化が必要'
#echo 'where句はグループ化の前に実行されるから'
#
## 6.8 1
#echo '====[ 6.8 1 ]'
#readonly query6_8_1="select id, name || 'さん' as name, height || 'cm' from members where gender = 'F' order by id;"
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "${query6_8_1}"
## 6.8 2
#echo '====[ 6.8 2 ]'
#readonly query6_8_2="select * from members where name in ('エレン', 'ミカサ', 'アルミン') order by id;"
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "${query6_8_2}"
## 6.8 3
#echo '====[ 6.8 3 ]'
#readonly query6_8_3="select name, height from members where height >= 170 and height <= 180 order by id;"
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "${query6_8_3}"
## 6.8 4
#echo '====[ 6.8 4 ]'
#readonly query6_8_4="select name from members where name like '%ン%' order by name;"
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "${query6_8_4}"
## 6.8 5
#echo '====[ 6.8 5 ]'
#readonly query6_8_5="select name from members where name like '____' order by name;"
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "${query6_8_5}"
## 6.8 6
#echo '====[ 6.8 6 ]'
#readonly query6_8_6_1="select * from characters where movie_id is null order by id;"
#readonly query6_8_6_2="select * from characters where movie_id is not null order by id;"
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "${query6_8_6_1}"
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "${query6_8_6_2}"
## 6.8 7
#echo '====[ 6.8 7 ]'
#readonly query6_8_7="select id, coalesce(movie_id || '', '未登録') as movie_id, name, gender from characters order by id;"
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "${query6_8_7}"
#
## 7
#echo '7は練習問題なし'
## 8
#echo '8は練習問題なし'
#
## 9.10.1
#echo '====[ 9.10.1 ]'
#readonly query9_10_1="select movies.movie_id, movies.title from movies left outer join characters on movies.movie_id = characters.movie_id where characters.id is null order by movies.movie_id;"
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "${query9_10_1}"
## 9.10.2
#echo '====[ 9.10.2 ]'
#readonly query9_10_2="select id, name, gender from characters where movie_id is null;"
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "${query9_10_2}"
## 9.10.3
#echo '====[ 9.10.3 ]'
#readonly query9_10_3="select movies.movie_id, movies.title, count(characters.id) from movies left outer join characters on movies.movie_id = characters.movie_id group by movies.movie_id order by movies.movie_id;"
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "${query9_10_3}"
#
#
## 10.6.1
#echo '====[ 10.6.1 ]'
#echo 'ある列にNULLを禁止する制約'
#echo 'データが入っていることを保障するとき'
## 10.6.2
#echo '====[ 10.6.2 ]'
#echo 'ある列の値が重複するのを禁止する制約'
#echo '重複すると困る場合に使う'
## 10.6.3
#echo '====[ 10.6.3 ]'
#echo 'あるテーブルに置いて行を特定するための列'
#echo '必要な特徴：一意である'
#echo '必要な特徴：NOT NULLである'
#echo '必要な特徴：値が変わらないこと'
## 10.6.4
#echo '====[ 10.6.4 ]'
#echo 'ほかのテーブルの主キーを参照するための列'
#echo 'どのような制約が生まれるか：参照先にある値しか入れられない'
#echo 'どのような制約が生まれるか：値は変更できない'
#
#
## 11.8.1
#echo '====[ 11.8.1 ]'
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c 'drop table employees;' || echo 'ok'
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c 'drop table departments;' || echo 'ok'
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c 'drop table companies;' || echo 'ok'
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -f ./create-companies-table-and-departments-table-and-employees-table.sql
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "insert into companies (id, name) values (301, '〇〇会社');"
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "insert into departments (id, name, company_id) values (2001, '開発部', 301);"
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "insert into departments (id, name, company_id) values (2002, '人事部', 301);"
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "insert into employees (id, name, dept_id) values (10001, '社員1', 2001);"
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "insert into employees (id, name, dept_id) values (10002, '社員2', 2001);"
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "insert into employees (id, name, dept_id) values (10003, '社員3', 2001);"
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "insert into employees (id, name, dept_id) values (10004, '社員4', 2002);"
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "insert into employees (id, name, dept_id) values (10005, '社員5', 2002);"
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "insert into employees (id, name, dept_id) values (10006, '社員6', 2002);"
#readonly query11_8_1="select e.id, e.name, c.id as comp_id, c.name as company, e.dept_id, d.name as department from employees as e left join departments as d on d.id = e.dept_id left join companies as c on c.id = d.company_id order by e.id;"
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "${query11_8_1}"
#
## 11.8.2
#echo '====[ 11.8.2 ]'
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c 'drop table writings;'    || echo 'ok'
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c 'drop table authors;'     || echo 'ok'
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c 'drop table books;'       || echo 'ok'
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -f ./create-books-table-and-authors-table-and-writings-table.sql
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "insert into books(id, title) values (31, 'デスノート');"
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "insert into books(id, title) values (32, 'バクマン。');"
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "insert into books(id, title) values (33, 'ヒカルの碁');"
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "insert into authors(id, name) values (71, '大場つぐみ');"
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "insert into authors(id, name) values (72, '小畑健');"
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "insert into authors(id, name) values (73, 'ほったゆみ');"
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "insert into writings(book_id, author_id, role) values (31, 71, '原作');"
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "insert into writings(book_id, author_id, role) values (31, 72, '漫画');"
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "insert into writings(book_id, author_id, role) values (32, 71, '原作');"
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "insert into writings(book_id, author_id, role) values (32, 72, '漫画');"
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "insert into writings(book_id, author_id, role) values (33, 73, '原作');"
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "insert into writings(book_id, author_id, role) values (33, 72, '漫画');"
#readonly query11_8_2="select w.book_id, b.title, w.author_id, a.name, w.role from writings as w left outer join books as b on b.id = w.book_id left outer join authors as a on a.id = w.author_id order by b.id, w.role;"
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "${query11_8_2}"
#
## 12.3
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c 'drop table testmembers;' || echo 'ok'
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -f ./create-testmembers-table.sql
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "insert into testmembers(name, height, gender) select 'メンバー#' || x.n, 160 + floor(random() * 20)::integer, case when x.n % 2 = 0 then 'M' else 'F' end from generate_series(1, 1000000) x(n);"
#
#echo "=================Before index"
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "explain select * from testmembers where name = 'メンバー#1000000';"
#echo "====Index"
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "create index testmembers_name_idx on testmembers(name);"
#echo "====After index"
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "explain select * from testmembers where name = 'メンバー#1000000';"
#echo "====After index, but <>"
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "explain select * from testmembers where name <> 'メンバー#1000000';"
#echo "====After index, index only scan"
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "explain select name from testmembers where name = 'メンバー#1000000';"
#echo "================="
#
#
## 15.8 1
#echo '====[ 15.8 1.1 ]'
#readonly query15_8_1_1="select gender, count(*) from members group by gender order by gender desc;"
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "${query15_8_1_1}"
#
#echo '====[ 15.8 1.2 ]'
#readonly query15_8_1_2="select sum((gender = 'M')::integer) as \"M\", sum((gender = 'F')::integer) as \"F\" from members;"
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "${query15_8_1_2}"
#
## 15.8 2
#echo '====[ 15.8 2.1 ]'
#readonly query15_8_2_1="select case when height < 160 then '160cm未満' when height < 170 then '160～170cm' when 170 <= height then '170cm以上' else null end as category, count(*) from members group by category;"
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "${query15_8_2_1}"
#echo '====[ 15.8 2.2 ]'
#readonly query15_8_2_2="select sum((height<160)::integer) as \"160cm未満\", sum((160<=height and height<170)::integer) as \"160～170cm\", sum((170<=height)::integer) as \"170cm以上\"  from members;"
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "${query15_8_2_2}"
#
## 15.8 3
#echo '====[ 15.8 3.1 ]'
#readonly query15_8_3_1="select case when height < 160 then '160cm未満' when height < 170 then '160～170cm' when 170 <= height then '170cm以上' else null end as category, count(*), sum((gender = 'M')::integer) as \"M\", sum((gender = 'F')::integer) as \"F\" from members group by category;"
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "${query15_8_3_1}"
#echo '====[ 15.8 3.2 ]'
#readonly query15_8_3_2="select gender, sum((height < 160)::integer) as \"160cm未満\", sum((160<=height and height<170)::integer) as \"160～170cm\", sum((170 <= height)::integer) as \"170cm以上\" from members group by gender;"
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "${query15_8_3_2}"
#
## 16
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c 'drop table test_scores;' || echo 'ok'
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c 'drop table students;'    || echo 'ok'
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -f ./create-students-table-and-test-scores-table.sql
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "insert into students (id, name, gender, class) values (201, 'さくら　ももこ',   'F', '3-4');"
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "insert into students (id, name, gender, class) values (202, 'はなわ　かずひこ', 'M', '3-4');"
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "insert into students (id, name, gender, class) values (203, 'ほなみ　たまえ',   'F', '3-4');"
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "insert into students (id, name, gender, class) values (204, 'まるお　すえお',   'M', '3-4');"
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "insert into test_scores (student_id, subject, score) values (201, '国語', 60);"
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "insert into test_scores (student_id, subject, score) values (201, '算数', 40);"
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "insert into test_scores (student_id, subject, score) values (201, '理科', 40);"
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "insert into test_scores (student_id, subject, score) values (201, '社会', 50);"
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "insert into test_scores (student_id, subject, score) values (202, '国語', 60);"
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "insert into test_scores (student_id, subject, score) values (202, '算数', 70);"
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "insert into test_scores (student_id, subject, score) values (202, '理科', 50);"
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "insert into test_scores (student_id, subject, score) values (202, '社会', 70);"
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "insert into test_scores (student_id, subject, score) values (203, '国語', 80);"
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "insert into test_scores (student_id, subject, score) values (203, '算数', 80);"
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "insert into test_scores (student_id, subject, score) values (203, '理科', 70);"
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "insert into test_scores (student_id, subject, score) values (203, '社会', 100);"
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "insert into test_scores (student_id, subject, score) values (204, '国語', 80);"
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "insert into test_scores (student_id, subject, score) values (204, '算数', 90);"
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "insert into test_scores (student_id, subject, score) values (204, '理科', 100);"
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "insert into test_scores (student_id, subject, score) values (204, '社会', 100);"
#echo '====[ 16.7 1 a ]'
#readonly query16_7_1_a="select t.student_id, t.score from test_scores as t where t.subject = '算数' and t.student_id in (select s.id from students as s where s.gender = 'F');"
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "${query16_7_1_a}"
#echo '====[ 16.7 1 b ]'
#readonly query16_7_1_b="select t.student_id, t.score from test_scores as t where t.subject = '算数' and 'F' = (select gender from students as s where s.id = t.student_id ) order by t.student_id;"
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "${query16_7_1_b}"
#echo '====[ 16.7 1 c ]'
#readonly query16_7_1_c="select s.id as student_id, (select t.score from test_scores as t where t.student_id = s.id and t.subject = '算数') as score from students as s where s.gender = 'F' order by s.id;"
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "${query16_7_1_c}"
#echo '====[ 16.7 1 d ]'
#readonly query16_7_1_d="select t.student_id, t.score from students as s left outer join test_scores as t on t.student_id = s.id where s.gender = 'F' and t.subject = '算数' order by s.id;"
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "${query16_7_1_d}"
#
## window関数
### ある行と関連する他の行を使って計算や操作が行える機能
## 名前順、そして順番をつける
#readonly query18_1_1="select *, row_number() over (order by name) from members order by name"
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "${query18_1_1}"
## 身長が高い順、そして順番をつける
#readonly query18_1_2="select *, rank() over (order by height desc) from members order by height desc"
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "${query18_1_2}"
## 男女別に身長の高い順に並べて、身長を累計
#readonly query18_1_3="select *, sum(height) over (partition by gender order by height desc, id) from members order by gender desc, height desc;"
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "${query18_1_3}"
## 男女別に身長の高い順に並べて、前の行との身長差を計算
#readonly query18_1_4="select *, m.height - lag(m.height, 1) over (partition by m.gender order by m.height) as diff from members as m;"
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "${query18_1_4}"
## 男女別に身長の高い順に並べて、身長を累計
## order byを消したときのウィンドウフレームは最終行まで
#readonly query18_1_5="select *, sum(height) over (partition by gender) from members order by gender desc, height desc;"
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "${query18_1_5}"
## 男女別と全体の、身長の累計を計算するウィンドウ関数
#readonly query18_1_6="select *, sum(height) over (partition by gender order by height, id) as \"男女別身長累計\", sum(height) over (order by height, id) as \"全体身長累計\" from members;"
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "${query18_1_6}"
## 男女別の身長の、最大値と最小値を表示（もったいない版:2回over句やってる）
#readonly query18_1_7="select *, max(height) over (partition by gender) as max, min(height) over (partition by gender) as min from members;"
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "${query18_1_7}"
## 男女別の身長の、最大値と最小値を表示（最適化版:over句の共有化）
#readonly query18_1_8="select *, max(height) over par_gender as max, min(height) over par_gender as min from members window par_gender as (partition by gender);"
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "${query18_1_8}"
## window ウィンドウ名 as (partition by ... order by ...)
## 18.10 1
#echo '====[ 18.10 1 ]'
#readonly query18_10_1="select *, to_char(avg(height) over par_gender, '999.99') as avg, to_char(height-(avg(height) over par_gender), '999.99') as diff from members over window par_gender as (partition by gender) order by gender desc, id;"
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "${query18_10_1}"
## 18.10 2
#echo '====[ 18.10 2 1 ]'
#readonly query18_10_2_1="select m.* from (select *, rank() over ord_height as rank from members window ord_height as (order by height desc)) as m where m.rank <= 2;"
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "${query18_10_2_1}"
#echo '====[ 18.10 2 2 ]'
#readonly query18_10_2_2="select m.* from (select *, rank() over par_gender_ord_height as rank from members window par_gender_ord_height as (partition by gender order by height desc)) as m where m.rank <= 2 order by m.gender desc, m.rank, m.id;"
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "${query18_10_2_2}"
#
## 20.2
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c 'drop table sos_brigade;' || echo 'ok'
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -f ./create-sos-brigade-table.sql
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "insert into sos_brigade (id, name, memo, boss_id) values (101, 'ハルヒ', '団長',     null);"
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "insert into sos_brigade (id, name, memo, boss_id) values (102, '古泉',   '超能力者', 101);"
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "insert into sos_brigade (id, name, memo, boss_id) values (103, 'みくる', '未来人',   101);"
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "insert into sos_brigade (id, name, memo, boss_id) values (104, 'キョン', '一般人',   102);"
#psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c "insert into sos_brigade (id, name, memo, boss_id) values (105, '有希',   '宇宙人',   101);"








# drop table
psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c 'drop table members;'     || echo 'ok'
psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c 'drop table characters;'  || echo 'ok'
psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c 'drop table movies;'      || echo 'ok'
psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c 'drop table employees;'   || echo 'ok'
psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c 'drop table departments;' || echo 'ok'
psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c 'drop table companies;'   || echo 'ok'
psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c 'drop table writings;'    || echo 'ok'
psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c 'drop table authors;'     || echo 'ok'
psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c 'drop table books;'       || echo 'ok'
psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c 'drop table testmembers;' || echo 'ok'
psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c 'drop table test_scores;' || echo 'ok'
psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c 'drop table students;'    || echo 'ok'
psql -h ${DB_HOST} -U ${DB_USER} -d ${DB_NAME} -c 'drop table sos_brigade;' || echo 'ok'
