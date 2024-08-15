from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.chrome.service import Service
from webdriver_manager.chrome import ChromeDriverManager
from selenium.webdriver.common.by import By
import pickle
import time
from datetime import datetime, timezone, timedelta

## warning
# brew install openssl@1.1
# pip3 install urllib3==1.26.15





# def convert_to_kst(iso_time):
#     # ISO 8601 형식의 시간을 datetime 객체로 변환
#     utc_time = datetime.fromisoformat(iso_time.replace("Z", "+00:00"))
#
#     # 한국 표준시로 변환 (UTC +9시간)
#     kst_time = utc_time + timedelta(hours=9)
#
#     # 변환된 시간을 ISO 8601 형식의 문자열로 반환
#     return kst_time.isoformat()


def convert_to_kst(iso_time):
    # ISO 8601 형식의 시간을 datetime 객체로 변환
    utc_time = datetime.fromisoformat(iso_time.replace("Z", "+00:00"))

    # 한국 표준시로 변환 (UTC +9시간)
    kst_time = utc_time + timedelta(hours=9)

    # 원하는 형식으로 포맷팅하여 반환
    formatted_time = kst_time.strftime('%Y-%m-%d / %H:%M:%S')
    return formatted_time

def driver_Settings():
    options = Options()

    # 웹드라이버 종료 안시키고 유지
    options.add_experimental_option("detach", True)

    # 주석해제하면 헤드리스 모드
    #options.add_argument("--headless")  # 헤드리스 모드로 실행

    # Windows 10 운영 체제에서 Chrome 브라우저를 사용하는 것처럼 보이는 사용자 에이전트가 설정
    options.add_argument(
        'user-agent=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36')

    # 언어 설정을 한국어로 지정. 이는 웹 페이지가 한국어로 표시
    options.add_argument('lang=ko_KR')

    # 브라우저 창의 크기를 지정. 여기서는 너비 430px, 높이 932px로 설정
    options.add_argument('--window-size=932,932')

    # GPU 가속을 비활성화. GPU 가속이 활성화되어 있으면, Chrome이 GPU를 사용하여 그래픽을 렌더링하려고 시도할 수 있기때문. 일부 환경에서는 GPU 가속이 문제를 일으킬 수 있으므로 이 옵션을 사용하여 비활성화
    options.add_argument('--disable-gpu')

    # 정보 표시줄을 비활성화. 정보 표시줄은 Chrome 브라우저 상단에 나타나는 알림이나 메시지를 의미. 이 옵션을 사용하여 이러한 알림이 나타나지 않도록 설정.
    options.add_argument('--disable-infobars')

    # 확장 프로그램을 비활성화. Chrome에서 확장 프로그램을 사용하지 않도록 설정
    options.add_argument('--disable-extensions')

    #  자동화된 기능을 비활성화. 이 옵션은 Chrome이 자동화된 환경에서 실행되는 것을 감지하는 것을 방지
    options.add_argument('--disable-blink-features=AutomationControlled')

    # 자동화를 비활성화. 이 옵션은 Chrome이 자동화 도구에 의해 제어되는 것으로 감지되는 것을 방지
    options.add_argument('--disable-automation')

    driver = webdriver.Chrome(service=Service(ChromeDriverManager().install()), options=options)

    return driver



if __name__ == "__main__":
    driver = driver_Settings()
    driver.get("https://www.instagram.com/")
    driver.implicitly_wait(15)

    cookies = pickle.load(open('insta_cookies.pkl', 'rb'))
    for cookie in cookies:
        driver.add_cookie(cookie)

    # 새로고침 및 새로고침 지연시간 고려
    driver.refresh()
    driver.implicitly_wait(15)
    time.sleep(1.5)

    # target profile
    driver.get("https://www.instagram.com/salt_ent/")
    driver.implicitly_wait(15)
    time.sleep(3)

    first_title = driver.find_element(By.CSS_SELECTOR, "._aagw")
    first_title.click()
    time.sleep(2)

    first_a9zr_div = driver.find_element(By.CSS_SELECTOR, '._ap3a._aaco._aacu._aacx._aad7._aade')
    print(first_a9zr_div.text.strip())

    for title in range(10):
        print("#########################################################################")
        # next_btn = driver.find_element(By.CSS_SELECTOR, '.x1lliihq.x1n2onr6.x175jnsf')
        next_btn = driver.find_element(By.CSS_SELECTOR, 'body > div.x1n2onr6.xzkaem6 > div.x9f619.x1n2onr6.x1ja2u2z > div > div.x1uvtmcs.x4k7w5x.x1h91t0o.x1beo9mf.xaigb6o.x12ejxvf.x3igimt.xarpa2k.xedcshv.x1lytzrv.x1t2pt76.x7ja8zs.x1n2onr6.x1qrby5j.x1jfb8zj > div > div > div > div > div:nth-child(1) > div > div > div._aaqg._aaqh > button')
        next_btn.click()

        first_a9zr_div = driver.find_element(By.CSS_SELECTOR,
                                             'body > div.x1n2onr6.xzkaem6 > div.x9f619.x1n2onr6.x1ja2u2z > div > div.x1uvtmcs.x4k7w5x.x1h91t0o.x1beo9mf.xaigb6o.x12ejxvf.x3igimt.xarpa2k.xedcshv.x1lytzrv.x1t2pt76.x7ja8zs.x1n2onr6.x1qrby5j.x1jfb8zj > div > div > div > div > div.xb88tzc.xw2csxc.x1odjw0f.x5fp0pe.x1qjc9v5.xjbqb8w.x1lcm9me.x1yr5g0i.xrt01vj.x10y3i5r.xr1yuqi.xkrivgy.x4ii5y1.x1gryazu.x15h9jz8.x47corl.xh8yej3.xir0mxb.x1juhsu6 > div > article > div > div.x1qjc9v5.x972fbf.xcfux6l.x1qhh985.xm0m39n.x9f619.x78zum5.xdt5ytf.x1iyjqo2.x5wqa0o.xln7xf2.xk390pu.xdj266r.x11i5rnm.xat24cr.x1mh8g0r.x65f84u.x1vq45kp.xexx8yu.x4uap5.x18d9i69.xkhd6sd.x1n2onr6.x11njtxf > div > div > div.x78zum5.xdt5ytf.x1q2y9iw.x1n2onr6.xh8yej3.x9f619.x1iyjqo2.x18l3tf1.x26u7qi.xy80clv.xexx8yu.x4uap5.x18d9i69.xkhd6sd > div.x78zum5.xdt5ytf.x1iyjqo2.xs83m0k.x2lwn1j.x1odjw0f.x1n2onr6.x9ek82g.x6ikm8r.xdj266r.x11i5rnm.x4ii5y1.x1mh8g0r.xexx8yu.x1pi30zi.x18d9i69.x1swvt13 > ul > div.x1qjc9v5.x972fbf.xcfux6l.x1qhh985.xm0m39n.x9f619.x78zum5.xdt5ytf.x2lah0s.xk390pu.xdj266r.x11i5rnm.xat24cr.x1mh8g0r.xexx8yu.x4uap5.x18d9i69.xkhd6sd.x1n2onr6.xggy1nq.x11njtxf > li > div > div > div._a9zr > div._a9zs > h1')
        time_info = driver.find_element(By.CSS_SELECTOR, "body > div.x1n2onr6.xzkaem6 > div.x9f619.x1n2onr6.x1ja2u2z > div > div.x1uvtmcs.x4k7w5x.x1h91t0o.x1beo9mf.xaigb6o.x12ejxvf.x3igimt.xarpa2k.xedcshv.x1lytzrv.x1t2pt76.x7ja8zs.x1n2onr6.x1qrby5j.x1jfb8zj > div > div > div > div > div.xb88tzc.xw2csxc.x1odjw0f.x5fp0pe.x1qjc9v5.xjbqb8w.x1lcm9me.x1yr5g0i.xrt01vj.x10y3i5r.xr1yuqi.xkrivgy.x4ii5y1.x1gryazu.x15h9jz8.x47corl.xh8yej3.xir0mxb.x1juhsu6 > div > article > div > div.x1qjc9v5.x972fbf.xcfux6l.x1qhh985.xm0m39n.x9f619.x78zum5.xdt5ytf.x1iyjqo2.x5wqa0o.xln7xf2.xk390pu.xdj266r.x11i5rnm.xat24cr.x1mh8g0r.x65f84u.x1vq45kp.xexx8yu.x4uap5.x18d9i69.xkhd6sd.x1n2onr6.x11njtxf > div > div > div.x78zum5.xdt5ytf.x1q2y9iw.x1n2onr6.xh8yej3.x9f619.x1iyjqo2.x18l3tf1.x26u7qi.xy80clv.xexx8yu.x4uap5.x18d9i69.xkhd6sd > div.x1yztbdb.x1h3rv7z.x1swvt13 > div > div > a > span > time")
        #print(first_a9zr_div.text.strip())

        # datetime 속성과 title 속성 값을 추출
        datetime_value = time_info.get_attribute("datetime")
        title_value = time_info.get_attribute("title")

        # KST 시간으로 변환하여 출력
        kst_time = convert_to_kst(datetime_value)


        # 두 값을 출력
        print("게시글 생략")
        print("KST Datetime:", kst_time)
        print("Title:", title_value)

        time.sleep(1.5)








































    # li = driver.find_elements(By.CSS_SELECTOR, "._aagw")
    # for i in li:
    #     print(i)

    # scroll_script = """
    #             var currentPosition = window.pageYOffset;
    #             var targetPosition = currentPosition + 500;
    #             var scrollInterval = setInterval(function() {
    #                 if (currentPosition >= targetPosition) {
    #                     clearInterval(scrollInterval);
    #                 } else {
    #                     window.scrollBy(0, 50);
    #                     currentPosition += 50;
    #                 }
    #             }, 100);
    #         """
    #
    # for _ in range(3):
    #     print("스크롤")
    #     hangs = driver.find_elements(By.CSS_SELECTOR,
    #                                  "#mount_0_0_jT > div > div > div.x9f619.x1n2onr6.x1ja2u2z > div > div > div.x78zum5.xdt5ytf.x1t2pt76.x1n2onr6.x1ja2u2z.x10cihs4 > div:nth-child(2) > div > div.x1gryazu.xh8yej3.x10o80wk.x14k21rp.x17snn68.x6osk4m.x1porb0y.x8vgawa > section > main > div > div:nth-child(3) > div > div")
    #     for hang in hangs:
    #         print("1")
    #         element_3 = hang.find_elements(By.CSS_SELECTOR, "div")
    #         for element in element_3:
    #             print(element.text)
    #
    #     driver.execute_script(scroll_script)
    #     time.sleep(2.5)





    print("입력: ")
    n = input()
    if n == 1:
        driver.quit()
    else:
        print("강제종료")
        driver.quit()









    # first_title = driver.find_element(By.CSS_SELECTOR, "#mount_0_0_Gu > div > div > div.x9f619.x1n2onr6.x1ja2u2z > div > div > div.x78zum5.xdt5ytf.x1t2pt76.x1n2onr6.x1ja2u2z.x10cihs4 > div:nth-child(2) > div > div.x1gryazu.xh8yej3.x10o80wk.x14k21rp.x17snn68.x6osk4m.x1porb0y.x8vgawa > section > main > div > div:nth-child(3) > div > div:nth-child(1) > div:nth-child(1) > a")
    # first_title.click()

    # hangs = driver.find_elements(By.CSS_SELECTOR, "#mount_0_0_jT > div > div > div.x9f619.x1n2onr6.x1ja2u2z > div > div > div.x78zum5.xdt5ytf.x1t2pt76.x1n2onr6.x1ja2u2z.x10cihs4 > div:nth-child(2) > div > div.x1gryazu.xh8yej3.x10o80wk.x14k21rp.x17snn68.x6osk4m.x1porb0y.x8vgawa > section > main > div > div:nth-child(3) > div > div")
    #
    # for hang in hangs:
    #     print("1")
    #     element_3 = hang.find_elements(By.CSS_SELECTOR, "div")
    #     for element in element_3:
    #         print(element.text)
