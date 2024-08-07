#pip3 install mypysql
#pip3 install cryptography

#mysql> desc test_table;
#+------------+--------------+------+-----+---------+----------------+
#| Field      | Type         | Null | Key | Default | Extra          |
#+------------+--------------+------+-----+---------+----------------+
#| number     | int          | NO   | PRI | NULL    | auto_increment |
#| kind       | varchar(10)  | YES  |     | NULL    |                |
#| title      | varchar(255) | YES  |     | NULL    |                |
#| detail     | text         | YES  |     | NULL    |                |
#| x_id       | varchar(15)  | YES  |     | NULL    |                |
#| event_date | date         | YES  |     | NULL    |                |
#| post_date  | date         | YES  |     | NULL    |                |
#| url        | varchar(255) | YES  |     | NULL    |                |
#| photo      | text         | YES  |     | NULL    |                |
#| singer     | varchar(255) | YES  |     | NULL    |                |
#+------------+--------------+------+-----+---------+----------------+

import pymysql
import os
import json
import platform
class mySQL:
    CONN = pymysql.connect(
        host="localhost",
        user="root",
        password="1q2w3e4r!",
        database="db"
    )

    CUR = CONN.cursor()
    #ko to en
    KEYS = {
        "제목": "title",
        "내용": "detail",
        "게시자아이디": "x_id",
        "가수": "singer",
        "행사날짜시간": "event_date",
        "게시글날짜시간": "post_date",
        "url": "url",
        "사진의경로": "photo"
    }

    @staticmethod
    def startMySQL():
        os_name = platform.system()

        if os_name == "Windows":
            os.system("net start MySQL")
        elif os_name == "Darwin":
            os.system("mysql.server start")
        elif os_name == "Linux":
            os.system("sudo systemctl start mysqld")
        else:
            pass

    @staticmethod
    def createTable(name): #
        sql = f"""CREATE TABLE IF NOT EXISTS `{name}` (
            number INT NOT NULL AUTO_INCREMENT,
            kind VARCHAR(10),
            title VARCHAR(255),
            detail TEXT,
            singer VARCHAR(255),
            x_id VARCHAR(15),
            event_date DATE,
            post_date DATE,
            url VARCHAR(255),
            photo TEXT,
            PRIMARY KEY (number)
            );"""

        mySQL.CUR.execute(sql)
        mySQL.CONN.commit()

    @staticmethod
    def insertData(name, js_data): #name: Table Name, js_data:
        columns = ",".join(map(str, list(mySQL.KEYS.values())))
        input_data = ""
        for idx0, data in enumerate(js_data):
            input_data += "("
            for idx1, key in enumerate(data.keys()):
                if key in mySQL.KEYS:
                    if data[key] is None or data[key] == ["NULL"]:
                        input_data += "NULL"
                    elif key == "사진의경로":
                        input_data += "'"
                        title_link = data["url"]    # 게시글 url
                        title_link = title_link[title_link.find("status")+7:]
                        for idx2, link in enumerate(data[key]):
                            input_data += f"{title_link}_{idx2}"
                            if idx2 < len(data[key]) - 1:
                                input_data += ","
                        input_data += "'"
                    else:
                        input_data += f"'{data[key]}'"
                    if idx1 < len(mySQL.KEYS) - 1:
                        input_data += ","
            input_data += ")"
            if idx0 < len(js_data) - 1:
                input_data += ",\n"


        sql = f"""INSERT INTO {name} ({columns}) VALUES {input_data};"""
        mySQL.CUR.execute(sql)
        mySQL.CONN.commit()

    @staticmethod
    def mysql():
        with open("Output.json", "r") as file:
            # read .json file
            js_data = json.load(file)
            js_data = list(js_data.values())

        # print(js_data)
        print("\nmysql started")
        name = "blipdb"   #Table name
        mySQL.startMySQL()
        mySQL.createTable(name)
        mySQL.insertData(name, js_data)


if __name__ == "__main__":  # Call if this file is main
    mySQL.mysql()