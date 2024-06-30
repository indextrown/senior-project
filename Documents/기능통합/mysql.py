# pip3 install mypysql
# pip3 install cryptography

# mysql> desc Data;
# +-----------+--------------+------+-----+---------+----------------+
# | Field     | Type         | Null | Key | Default | Extra          |
# +-----------+--------------+------+-----+---------+----------------+
# | NUMBER    | int          | NO   | PRI | NULL    | auto_increment |
# | celebrity | varchar(20)  | YES  |     | NULL    |                |
# | uploader  | varchar(30)  | YES  |     | NULL    |                |
# | date      | varchar(100) | YES  |     | NULL    |                |
# | place     | varchar(100  | YES  |     | NULL    |                |
# | post_url  | varchar(100) | YES  |     | NULL    |                |
# +-----------+--------------+------+-----+---------+----------------+

# output_data.json 예시
# "1": {
#         "가수": "슈가",
#         "작성자": "@bts_thelove_min",
#         "일정": "3/8~3/9",
#         "장소": "서울 해피벌스데이: 서울특별시 마포구 동교로 34길 82층"
#         "게시물_url": "https://fandomship.com/bbs/link.php?bo_table=bts&wr_id=206&no=1&page=1"
# }
#
# 중복에 관여하는 필터링은 (필터링) 키워드를 검색하면 됨

import pymysql
import os
import json
from copy import copy


class mySQL:
    # MySQL 서버에 연결
    os.system("mysql.server start")

    conn = pymysql.connect(
        host="localhost",
        user="root",
        password="1q2w3e4r!",
        database="DB"
    )
    cur = conn.cursor()
    keys = {
        "가수": "celebrity",
        "작성자": "uploader",
        "일정": "date",
        "장소": "place",
        "게시글_url": "post_url"
    }

    filter_keys = ["가수", "일정", "장소"]  # 해당 키들이 모두 같아야 중복으로 처리(필터링)

    @staticmethod
    def mysql():
        # 새로 들어오는 데이터들
        with open("output_gpt.json", "r") as file:
            # JSON 데이터 읽기
            js_data = json.load(file)

        print("\nmysql 진행 시작")

        mySQL.makeTable("Data")
        data = mySQL.pureData(js_data)  # 새로 들어오는 데이터 내에서 중복 제거
        data = mySQL.getfromTable(data)  # 새로 들어오는 데이터가 테이블 내의 데이터와 중복되는것 제거
        data = mySQL.filter_url_with_X(data) # 게시글url이 x가 아니면 필터링
        mySQL.insertData(data, "Data")  # 중복이 전혀 없는 데이터들만 테이블에 추가
        # reset_auto_increment() #데이터가 삭제될 일이 없으면 호출하지 않아도 됨

        mySQL.conn.close()
        print("mysql 진행 종료")

    @staticmethod
    def makeTable(name):  # 테이블 제작 함수
        sql = """CREATE TABLE IF NOT EXISTS {} (
        NUMBER INT AUTO_INCREMENT PRIMARY KEY,
        celebrity VARCHAR(20),
        uploader VARCHAR(30),
        date varchar(100),
        place varchar(100),
        post_url varchar(100)
        );""".format(name)
        mySQL.cur.execute(sql)
        mySQL.conn.commit()

    @staticmethod
    def insertData(dic, name):  # 데이터 추가 쿼리
        if len(dic) == 0:  # 입력에 데이터가 없으면 그냥 끝
            return
        columns = ",".join(map(str, list(mySQL.keys.values())))

        columns_list = tuple(mySQL.keys.keys())
        data = ""
        for i in dic.values():
            row_data = ["NULL" for _ in range(len(mySQL.keys))]
            for j in i:  # i의 key들을 순차적으로 갖고옴
                if i[j] != None:  # None 처리 이유: reset_auto_increment()에서 NULL값을 None으로 가져와서
                    row_data[columns_list.index(j)] = "'" + i[j] + "'"

            if row_data[0] == "NULL" or row_data[2] == "NULL" or row_data[3] == "NULL":
                continue
            data += "(" + ",".join(map(str, row_data)) + "),"

        sql = "INSERT INTO {} ({}) VALUES {};".format(name, columns, data[:-1])

        mySQL.cur.execute(sql)
        mySQL.conn.commit()

    @staticmethod
    def pureData(dic) -> dict:  # 새로 들어오는 데이터들에 한해 서로 겹치는 데이터가 있으면 제거
        num = 1
        data, tmp = {}, {}
        for i in dic.values():
            _i = copy(i);
            for j in mySQL.keys.keys():
                if j not in mySQL.filter_keys:
                    del _i[j]  # 중복에 비교되지 않는 데이터는 제거 후 비교(필터링)

            if tuple(_i.values()) not in tmp:  # O(1)
                tmp[tuple(_i.values())] = 0
                data[num] = i
                num += 1
        return data

    @staticmethod
    def getfromTable(dic) -> dict:  # 테이블에서 데이터 중복 확인 후 중복되지 않는것만 거름
        data = {}
        num = 1
        for i in dic.values():
            sql = "WHERE  "
            for j in i.keys():
                if j in mySQL.filter_keys:  # 해당 key들 일때만 필터링 하기 위해 sql문에 추가(필터링)
                    sql += mySQL.keys[j] + " = \'" + i[j] + "\' AND "

            if sql == "WHERE  ":
                raise "Input data's all values are None."

            sql = sql[:-5]  # 맨 뒤에 AND가 공란 포함 5글자임
            mySQL.cur.execute("SELECT * FROM Data " + sql + ";")
            row = mySQL.cur.fetchone()
            if row == None:  # 테이블에 자료 없음
                data[str(num)] = i
                num += 1

        return data

    @staticmethod
    def filter_url_with_X(data): #X가 아닌 url이면 거름
        newdata = {}
        for i in data:
            if "https://x.com" in data[i]["게시글_url"]:
                newdata[i] = data[i]
        return newdata

    @staticmethod
    def reset_auto_increment():
        mySQL.makeTable("tmp")  # 기존 테이블의 내용을 백업할 테이블
        mySQL.cur.execute("SELECT * FROM Data;")
        dic, data = dict(), mySQL.cur.fetchall()

        for idx, value in enumerate(data):
            dic[str(idx + 1)] = {_value: value[_idx + 1] for _idx, _value in enumerate(mySQL.keys.keys())}

        mySQL.insertData(dic, "tmp")
        mySQL.cur.execute("DROP TABLE Data;")
        mySQL.cur.execute("RENAME TABLE tmp TO Data;")
        mySQL.conn.commit()



    def __init__(self):  # 생성자
        pass

    def __del__(self):  # 소멸자
        pass


if __name__ == "__main__":  # 호출법
    mySQL.mysql()