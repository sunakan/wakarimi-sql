-- 生徒
create table students (
  id     integer primary key
, name   text    not null
, gender char(1) not null
, class  text    not null
);
-- テストの点数
create table test_scores (
  student_id integer not null references students(id)
, subject    text    not null -- 教科（国語, 算数, 理科, 社会）
, score      integer not null -- 点数
, primary key (student_id, subject)
);
