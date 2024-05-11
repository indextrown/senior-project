2024/05/09
python to sql 시작

2024/05/09
샘플 데이터 추가

2024/05/11
MySQL 테이블 구조 변경

#mysql> desc Data;  
#+-----------+--------------+------+-----+---------+----------------+  
#| Field     | Type         | Null | Key | Default | Extra          |  
#+-----------+--------------+------+-----+---------+----------------+  
#| ORDER     | int          | NO   | PRI | NULL    | auto_increment |  
#| celebrity | varchar(20)  | YES  |     | NULL    |                |  
#| uploader  | varchar(30)  | YES  |     | NULL    |                |  
#| date      | varchar(50)  | YES  |     | NULL    |                |  
#| place     | varchar(50)  | YES  |     | NULL    |                |  
#| post_url  | varchar(100) | YES  |     | NULL    |                |  
#+-----------+--------------+------+-----+---------+----------------+  

MySQL에 새로 들어오는 데이터에 대해 중복 필터링 및 기존 데이터와의 중복 필터링 후 추가하는 작업 완료