import crawling as c
import openai
import gpt as g
import mysql as m


if __name__ == "__main__":

    # slack 알람 전송(코드 실행)
    # 매개변수: 토큰, 채널명, 원하는 텍스트
    c.alarm(c.token, c.channel, c.text)
    
    # 코드 실행
    c.crawling_main()

    #  slack 알람 전송(코드 종료)
    # 매개변수: 토큰, 채널명, 원하는 텍스트
    c.alarm(c.token, c.channel, c.text_end)

    #gpt 실행 
    # 매개변수: 읽을 파일
    g.gpt_api("output_crawling.txt")

    # mysql 실행
    m.mySQL.mysql()



