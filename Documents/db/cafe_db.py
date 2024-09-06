# pip3 install mypysql
# pip3 install cryptography

# mysql> desc cafe_db;
# +-----------+--------------+------+-----+---------+----------------+
# | Field     | Type         | Null | Key | Default | Extra          |
# +-----------+--------------+------+-----+---------+----------------+
# | NUMBER    | int          | NO   | PRI | NULL    | auto_increment |
# | celebrity | varchar(20)  | YES  |     | NULL    |                |
# | uploader  | varchar(30)  | YES  |     | NULL    |                |
# | start_date| date         | YES  |     | NULL    |                |
# | end_date  | date         | YES  |     | NULL    |                |
# | place     | varchar(100  | YES  |     | NULL    |                |
# | post_url  | varchar(100) | YES  |     | NULL    |                |
# +-----------+--------------+------+-----+---------+----------------+

# output_data.json 예시
# "1": {
#     "celebrity": "채봉구",
#     "uploader": "@1101_GOTP",
#     "start_date": "2024-07-13",
#     "end_date": "2024-07-15",
#     "place": "부산 카페 비전문",
#     "post_url": "https://x.com/1101_GOTP/status/1797270083083116902"
# }
#
# 중복에 관여하는 필터링은 (필터링) 키워드를 검색하면 됨

import pymysql
import os
import json
from copy import copy
from datetime import datetime
import platform

class mySQL:
    # MySQL 서버에 연결
    os_name = platform.system()

    if os_name == "Windows":
        os.system("net start MySQL")
    elif os_name == "Darwin":
        os.system("mysql.server start")
    elif os_name == "Linux":
        os.system("sudo systemctl start mysqld")
    else:
        pass

    conn = pymysql.connect(
        host="localhost",
        user="root",
        password="1q2w3e4r!",
        database="db"
    )
    cur = conn.cursor()

    keys = [
        "celebrity",
        "uploader",
        "start_date",
        "end_date",
        "place",
        "post_url"
    ]

    filter_keys = ["celebrity", "start_date", "end_date", "place"]  # 해당 키들이 모두 같아야 중복으로 처리(필터링)

    @staticmethod
    def mysql():
        # 새로 들어오는 데이터들
        with open("output_gpt.json", "r") as file:
            # JSON 데이터 읽기
            js_data = json.load(file)

        print("\nmysql 진행 시작")

        mySQL.makeTable("cafe_db")
        data = mySQL.correctDateFormat(js_data)
        data = mySQL.pureData(data)  # 새로 들어오는 데이터 내에서 중복 제거
        data = mySQL.getfromTable(data)  # 새로 들어오는 데이터가 테이블 내의 데이터와 중복되는것 제거
        data = mySQL.filter_url_with_X(data) # 게시글url이 x가 아니면 필터링
        mySQL.insertData(data, "cafe_db")  # 중복이 전혀 없고 NULL을 포함하지 않는 데이터들만 테이블에 추가
        mySQL.Log(data)
        # reset_auto_increment("cafe_db") #데이터가 삭제될 일이 없으면 호출하지 않아도 됨
        mySQL.cur.close()
        mySQL.conn.close()
        print("mysql 진행 종료")

    @staticmethod
    def makeTable(name):  # 테이블 제작 함수
        sql = """CREATE TABLE IF NOT EXISTS {} (
        NUMBER INT AUTO_INCREMENT PRIMARY KEY,
        celebrity VARCHAR(20),
        uploader VARCHAR(30),
        start_date DATE,
        end_date DATE,
        place VARCHAR(100),
        post_url VARCHAR(100)
        );""".format(name)
        mySQL.cur.execute(sql)
        mySQL.conn.commit()

    @staticmethod
    def isCorrectFormatDate(date):
        try:
            datetime.strptime(date, '%Y-%m-%d')
            return True
        except ValueError:
            return False

    @staticmethod
    def isValidDate(date_str):
        try:
            datetime.strptime(date_str, '%Y-%m-%d')
            return True
        except ValueError:
            return False

    @staticmethod
    def correctDateFormat(dic) -> dict:
        if len(dic) == 0:  # 입력에 데이터가 없으면 그냥 끝
            return
        num = 1
        data = {}

        for i in dic.values():
            if mySQL.isValidDate(i["start_date"]) and mySQL.isValidDate(i["end_date"]):
                data[str(num)] = i
                num += 1

        return data
    @staticmethod
    def insertData(dic, name):  # 데이터 추가 쿼리
        if len(dic) == 0:  # 입력에 데이터가 없으면 그냥 끝
            return
        columns = ",".join(map(str, list(mySQL.keys)))

        data = ""
        for i in dic.values():
            row_data = ["NULL" for _ in range(len(mySQL.keys))]
            for j in i:  # i의 key들을 순차적으로 갖고옴, i는 딕셔너리임
                if i[j] != None:  # None 처리 이유: reset_auto_increment()에서 NULL값을 None으로 가져와서
                    row_data[mySQL.keys.index(j)] = "'" + i[j] + "'"

            if "NULL" in row_data:
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
            for j in mySQL.keys:
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
            for j in mySQL.filter_keys:
                sql += j + " = \'" + i[j] + "\' AND "

            sql = sql[:-5]  # 맨 뒤에 AND가 공란 포함 5글자임
            mySQL.cur.execute("SELECT * FROM cafe_db " + sql + ";")
            row = mySQL.cur.fetchone()
            if row == None:  # 테이블에 자료 없음
                data[str(num)] = i
                num += 1

        return data

    @staticmethod
    def filter_url_with_X(data): #X가 아닌 url이면 거름
        newdata = {}
        for i in data:
            if "https://x.com" in data[i]["post_url"]:
                newdata[i] = data[i]
        return newdata

    @staticmethod
    def reset_auto_increment(name):
        mySQL.makeTable("tmp")  # 기존 테이블의 내용을 백업할 테이블
        mySQL.cur.execute(f"SELECT * FROM {name};")
        dic, data = dict(), mySQL.cur.fetchall()

        for idx, value in enumerate(data):
            dic[str(idx + 1)] = {_value: value[_idx + 1] for _idx, _value in enumerate(mySQL.keys)}

        mySQL.insertData(dic, "tmp")
        mySQL.cur.execute(f"DROP TABLE {name};")
        mySQL.cur.execute(f"RENAME TABLE tmp TO {name};")
        mySQL.conn.commit()

    @staticmethod
    def Log(data):
        fout = open("DB_log.txt", "a")
        t = datetime.now().strftime("%Y-%m-%d %H:%M")
        tmp = ""
        for idx, value in enumerate(data.values()):
            tmp += "\n\t\"{}\": {{".format(idx)
            for j in value.keys():
                tmp += "\n\t\t\"{}\": \"{}\",".format(j, value[j])
            tmp = tmp[:-1] + "\n\t},"
        res = "{{\"{}\": {{".format(t) + tmp[:-1] + "\n}}"
        if tmp == "":
            res = "{{\"{}\"".format(t) + ": {}}"
        fout.write("\n" + res + "\n")


    def __init__(self):  # 생성자
        pass

    def __del__(self):  # 소멸자
        pass


if __name__ == "__main__":  # 호출법
    mySQL.mysql()
