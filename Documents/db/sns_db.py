#pip3 install mypysql
#pip3 install cryptography

#mysql> desc insta_db;
#+------------+--------------+------+-----+---------+----------------+
#| Field      | Type         | Null | Key | Default | Extra          |
#+------------+--------------+------+-----+---------+----------------+
#| number     | int          | NO   | PRI | NULL    | auto_increment |
#| kind       | varchar(30)  | YES  |     | NULL    |                |
#| title      | varchar(255) | YES  |     | NULL    |                |
#| detail     | text         | YES  |     | NULL    |                |
#| artist     | varchar(255) | YES  |     | NULL    |                |
#| id         | varchar(15)  | YES  |     | NULL    |                |
#| event_date | datetime     | YES  |     | NULL    |                |
#| post_date  | datetime     | YES  |     | NULL    |                |
#| url        | varchar(255) | YES  |     | NULL    |                |
#| photo      | text         | YES  |     | NULL    |                |
#+------------+--------------+------+-----+---------+----------------+

import pymysql
import os
import json
import platform
from datetime import datetime

class mySQL:
    os_name = platform.system()

    if os_name == "Windows":
        os.system("net start MySQL")
    elif os_name == "Darwin":
        os.system("mysql.server start")
    elif os_name == "Linux":
        os.system("sudo systemctl start mysqld")
    else:
        pass

    CONN = pymysql.connect(
        host="localhost",
        user="root",
        password="1q2w3e4r!",
        database="db"
    )
    CUR = CONN.cursor()
    KEYS = ["title", "detail", "id", "artist", "event_date", "post_date", "url", "kind", "photo"]

    #ko to en
    @staticmethod
    def setVariables():
        mySQL.CONN = pymysql.connect(
            host="localhost",
            user="root",
            password="1q2w3e4r!",
            database="db"
        )
        mySQL.CUR = mySQL.CONN.cursor()

    @staticmethod
    def createTable(name): #
        sql = f"""CREATE TABLE IF NOT EXISTS `{name}` (
            number INT NOT NULL AUTO_INCREMENT,
            kind VARCHAR(30),
            title VARCHAR(255),
            detail TEXT,
            artist VARCHAR(255),
            id VARCHAR(15),
            event_date DATETIME,
            post_date DATETIME,
            url VARCHAR(255),
            photo TEXT,
            PRIMARY KEY (number)
            );"""

        mySQL.CUR.execute(sql)
        mySQL.CONN.commit()

    @staticmethod
    def insertData(name, newData): #name: Table Name, js_data:
        if len(newData) == 0:
            return
        columns = []
        input_data = ""
        for idx0, data in enumerate(newData):
            input_data += "("
            for idx1, key in enumerate(data.keys()):
                if key in mySQL.KEYS:
                    if idx0 == 0:
                        columns.append(key)
                    if data[key] == "NULL" or data[key] == ["NULL"]:
                        input_data += "NULL"
                    elif key == "photo":
                        input_data += "'"
                        for idx2, link in enumerate(data[key]):
                            input_data += f"{link}"
                            if idx2 < len(data[key]) - 1:
                                input_data += ","
                        input_data += "'"
                    else:
                        input_data += f"'{data[key]}'"
                    if idx1 < len(mySQL.KEYS) - 1:
                        input_data += ","
            input_data += ")"
            if idx0 < len(newData) - 1:
                input_data += ",\n"


        sql = f"INSERT INTO {name} ({', '.join(columns)}) VALUES {input_data};"
        mySQL.CUR.execute(sql)
        mySQL.CONN.commit()

    @staticmethod
    def isValidDate(date_str):
        try:
            datetime.strptime(date_str, "%Y-%m-%d / %H:%M:%S")
            return True
        except ValueError:
            return False

    @staticmethod
    def correctDateFormat(arr) -> list:
        if len(arr) == 0:  # 입력에 데이터가 없으면 그냥 끝
            return
        data = []

        for i in arr:
            if mySQL.isValidDate(i["event_date"]) and mySQL.isValidDate(i["post_date"]):
                data.append(i)

        return data

    @staticmethod
    def Log(arr, sns):
        fout = open(f"{sns}_db_log.txt", "a")
        t = datetime.now().strftime("%Y-%m-%d %H:%M")
        tmp = ""
        for idx, value in enumerate(arr):
            tmp += "\n\t\"{}\": {{".format(idx)
            for j in value.keys():
                tmp += "\n\t\t\"{}\": \"{}\",".format(j, value[j])
            tmp = tmp[:-1] + "\n\t},"
        res = "{{\"{}\": {{".format(t) + tmp[:-1] + "\n}}"
        if tmp == "":
            res = "{{\"{}\"".format(t) + ": {}}"
        fout.write("\n" + res + "\n")


    @staticmethod
    def mysql(sns):
        if sns != "x" and sns != "insta":
            return
        with open("Output_" + sns + ".json", "r") as file:
            # read .json file
            js_data = json.load(file)
            js_data = list(js_data.values())

        # print(js_data)
        print("\nmysql started")
        name = sns + "_db"   #Table name
        mySQL.createTable(name)
        data = mySQL.correctDateFormat(js_data)
        mySQL.insertData(name, data)
        mySQL.Log(data, sns)

if __name__ == "__main__":  # Call if this file is main
    #mySQL.mysql("x")
    mySQL.mysql("insta")