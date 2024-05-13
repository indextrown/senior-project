#pip3 intsall mypysql
#pip3 install cryptography

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

#output_data.json 예시
# "1": {
#         "가수": "슈가",
#         "작성자": "@bts_thelove_min",
#         "일정": "3/8~3/9",
#         "장소": "서울 해피벌스데이: 서울특별시 마포구 동교로 34길 82층"
#         "게시물_url": "https://fandomship.com/bbs/link.php?bo_table=bts&wr_id=206&no=1&page=1"
#}

import pymysql
import os
import json

def makeTable(name): #테이블 제작 함수
    sql = """CREATE TABLE IF NOT EXISTS {} (
    `ORDER` INT AUTO_INCREMENT PRIMARY KEY,
    celebrity VARCHAR(20),
    uploader VARCHAR(30),
    date varchar(100),
    place varchar(100),
    post_url varchar(100)
    );""".format(name)
    cur.execute(sql)
    conn.commit()

def insertData(dic, name): #데이터 추가 쿼리
    if len(dic) == 0: #입력에 데이터가 없으면 그냥 끝
        return
    sql = "INSERT INTO {} (celebrity, uploader, date, place, post_url) VALUES".format(name)
    for i in dic.values():
        i = tuple(i.values())
        sql += "('{}','{}','{}','{}','{}'),".format(i[0], i[1], i[2], i[3], i[4])
    sql = sql[:-1] + ";"
    cur.execute(sql)
    conn.commit()

def pureData(dic) -> dict: #새로 들어오는 데이터들에 한해 서로 겹치는 데이터가 있으면 제거
    num = 1
    data, tmp = {}, {}
    for i in dic.values():
        if tuple(i.values()) not in tmp: #O(1)
            tmp[tuple(i.values())] = 0
            data[num] = i
            num += 1
    return data

def getfromTable(dic) -> dict: #테이블에서 데이터 중복 확인 후 중복되지 않는것만 거름
    data = {}
    num = 1
    for i in dic.values():
        sql = "WHERE  "
        for j in i.keys():
            if i[j] != "":
                sql += keys[j] + " = \'" + i[j] + "\' AND "

        if sql == "WHERE  ":
           raise "Input data's all values are None."
        
        sql = sql[:-5]
        cur.execute("SELECT * FROM Data " + sql + ";")

        row = cur.fetchone()
        if row == None: #기존 테이블에 이미 자료가 있음
            data[str(num)] = i
            num += 1

    return data

def reset_auto_increment():
    makeTable("tmp") #기존 테이블의 내용을 백업할 테이블
    cur.execute("SELECT * FROM Data;")
    dic, data = dict(), cur.fetchall() #

    for idx, value in enumerate(data):
        dic[str(idx+1)] = {_value: value[_idx + 1]  for _idx, _value in enumerate(keys.values())}

    insertData(dic, "tmp")
    cur.execute("DROP TABLE Data;")
    cur.execute("RENAME TABLE tmp TO Data;")
    conn.commit()


#새로 들어오는 데이터들
with open("output_data (2).json", "r") as file:
    # JSON 데이터 읽기
    js_data = json.load(file)

# MySQL 서버에 연결
os.system("mysql.server start")
conn = pymysql.connect(
    host = "localhost",
    user = "root",
    password = "1q2w3e4r!",
    database = "DB"
)
cur = conn.cursor()

keys = {
    "가수": "celebrity",
    "작성자": "uploader",
    "일정": "date",
    "장소": "place",
    "게시글_url": "post_url"
}

makeTable("Data")
data = pureData(js_data) #새로 들어오는 데이터 내에서 중복 제거
data = getfromTable(data) #새로 들어오는 데이터가 테이블 내의 데이터와 중복되는것 제거
insertData(data, "Data") #중복이 전혀 없는 데이터들만 테이블에 추가
reset_auto_increment()

conn.close()
