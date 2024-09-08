import crawling as c
import openai
import gpt as g
import x_filter as xf
import mysql as m
import kill_chromedriver as k

if __name__ == "__main__":

    # Slack 알람 전송 (코드 실행)
    c.alarm(c.token, c.channel, c.text)

    # 크롤링 실행 및 결과 확인
    if c.crawling_main():
        # 크롤링이 성공했을 때만 아래 코드 실행

        # Slack 알람 전송 (코드 종료)
        c.alarm(c.token, c.channel, c.text_end)

        # GPT 실행
        g.main()

        # GPT 2중 필터링
        xf.x_filter_data("output_gpt.json")

        # MySQL 실행
        m.mySQL.mysql()

        c.alarm(c.token, c.channel, "크롤링 성공: 정상종료되었습니다.")

        # 남아있는 크롬 프로세스 강제 종료
        k.kill_chrome_processes()
    else:
        # 크롤링 실패 시 알림
        print("크롤링 실패 혹은 결과가 없습니다.")
        c.alarm(c.token, c.channel, "크롤링 실패: 결과가 없습니다.")


# if __name__ == "__main__":
#
#     # slack 알람 전송(코드 실행)
#     # 매개변수: 토큰, 채널명, 원하는 텍스트
#     c.alarm(c.token, c.channel, c.text)
#
#     # 코드 실행
#     c.crawling_main()
#
#     #  slack 알람 전송(코드 종료)
#     # 매개변수: 토큰, 채널명, 원하는 텍스트
#     c.alarm(c.token, c.channel, c.text_end)
#
#     # gpt 실행
#     g.main()
#
#     # gpt 2중 필터링
#     xf.x_filter_data("output_gpt.json")
#
#     # mysql 실행
#     m.mySQL.mysql()
#
#     # 만약 크롬프로세스가 남아있으면 강제로 종료 추가
#     k.kill_chrome_processes()


