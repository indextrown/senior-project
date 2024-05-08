import pymysql
import json

js_file = open()
js_file = json(js_file)

# MySQL 서버에 연결
conn = pymysql.connect(
    host = "localhost",
    user = "root",
    password = "1q2w3e4r!",
    database = "DB"
)
cur = conn.cursor()

