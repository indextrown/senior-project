import pymysql
import json

with open("data.json", "r") as file:
    # JSON 데이터 읽기
    js_data = json.load(file)

# MySQL 서버에 연결
conn = pymysql.connect(
    host = "localhost",
    user = "root",
    password = "1q2w3e4r!",
    database = "DB"
)
cur = conn.cursor()

for i in js_data:
    try:
        sql = ""
        cur.execute(sql)
    except:
        continue;

conn.commit()
conn.close()