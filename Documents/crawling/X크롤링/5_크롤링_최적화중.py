import pickle
from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from webdriver_manager.chrome import ChromeDriverManager
from bs4 import BeautifulSoup
from selenium.webdriver.common.by import By
from selenium.webdriver.common.keys import Keys
import time
import sys
import re
import requests


ban_list = ["다현, 플라워샵", "정대만", "럭키드로우", "오레오", "박지훈"]

# 전역 변수 선언
driver = None

# 봇 감지 전처리
def open_Driver():

    # 함수안에서 Local이 아닌 Global을 사용하겠다.
    global driver
    options = Options()

    #options.add_experimental_option("detach", True)
    options.add_argument("--headless")  # 헤드리스 모드로 실행

    # Windows 10 운영 체제에서 Chrome 브라우저를 사용하는 것처럼 보이는 사용자 에이전트가 설정
    options.add_argument('user-agent=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36')
    
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

# 사이트에 쿠키 적용
def check_login_selenium_x():
    global driver
    # url 이동
    url = 'https://www.twitter.com'
    driver.get(url)
    driver.implicitly_wait(15)

    cookies = pickle.load(open('x_cookies.pkl', 'rb'))
    for cookie in cookies:
        driver.add_cookie(cookie)

    driver.refresh()
    driver.implicitly_wait(15)
    time.sleep(1)

    cur_url = driver.current_url

    
    if (cur_url[-4:] == "home"):
        print("로그인 성공")
        return True;
    else:
        print("로그인 실패로 프로그램 종료합니다.")
        sys.exit()
        return False;

# url고유 번호
def extract_last_part(url):
    # URL을 '/'로 분리
    parts = url.split('/')
    # 맨 마지막 부분 반환
    last_part = parts[-1] if parts[-1] != '' else parts[-2]  # 마지막이 빈 문자열인 경우를 대비
    return last_part

# 정규표현식 파싱
def extract_time(s):
    # 숫자와 그 뒤에 오는 문자(m 또는 s)를 찾습니다.
    match = re.search(r"(\d+)(m|s)", s)
    if match:
        number = int(match.group(1))  # 숫자 추출
        unit = match.group(2)         # 단위 추출 (m 또는 s)

        # 단위에 따라 출력문을 결정합니다.
        if unit == 'm':
            return f"{number}분"
        elif unit == 's':
            return f"{number}초"
    return "적절한 시간 단위가 포함된 문자열이 아닙니다."

# x 크롤링
def search_x(search):
    global driver
    driver.get(f"https://twitter.com/search?q={search}&src=typed_query&f=live")
    driver.implicitly_wait(15)
    time.sleep(3)

    # 스크롤을 조금씩 내리는 JavaScript 코드
    scroll_script = """
        var currentPosition = window.pageYOffset;
        var targetPosition = currentPosition + 500;
        var scrollInterval = setInterval(function() {
            if (currentPosition >= targetPosition) {
                clearInterval(scrollInterval);
            } else {
                window.scrollBy(0, 50);
                currentPosition += 50;
            }
        }, 100);
    """

    # 스크롤 카운트
    scroll_count = 0

    # 이중리스트, 각 요소는[nickname, user_id, cclear_new_title]
    # 이전의 요소와 비교하기 위한 리스트임 같으면 안들어감
    old_titles = []

    while (True):
        if scroll_count == 30: break

        titles = driver.find_elements(By.CSS_SELECTOR, "#react-root > div > div > div.css-175oi2r.r-1f2l425.r-13qz1uu.r-417010.r-18u37iz > main > div > div > div > div > div > div:nth-child(3) > section > div > div > div")

        for title in titles:
            try:
                # 게시물 정보
                li = title.find_elements(By.CSS_SELECTOR, "div > div > article > div > div > div:nth-child(2) > div:nth-child(2) > div")

                if not li:
                    continue
                info = li[0].text.split("\n")
                #print(li)

                # 광고게시물 무시
                if info[-1] == 'Ad': 
                    #print("광고게시물 무시합니다")
                    #print("\n\n")
                    continue
                
                ban = False
                for ban_keyword in ban_list:
                    # 특정 벤 리스트 키워드 무시
                    if (ban_keyword in li[1].text):
                        #print(f"{ban_keyword} 가 게시물에 있기 때문에 해당 게시물 무시합니다.")
                        ban = True

                # 벤 키워드가 있는 게시물 무시
                if (ban): 
                    #print("벤게시글 무시합니다")
                    #print("\n\n")
                    ban = False
                    continue
                

                # 프로필 url
                # profile_url = li[0].find_element(By.CSS_SELECTOR, "div > div > div > div > div > div > a").get_attribute('href')
                
                # 게시시간
                #mytesttime = li[0].find_element(By.CSS_SELECTOR, "div > div > div > div > div:nth-child(2) > div > div:nth-child(3) > a > time").get_attribute('datetime')

                # 게시글 url
                title_url = li[0].find_element(By.CSS_SELECTOR, "div > div > div > div > div:nth-child(2) > div > div:nth-child(3) > a").get_attribute('href')
                
                #  현재시간 - 게시시간
                catch_title = li[0].find_element(By.CSS_SELECTOR, "div > div > div > div > div:nth-child(2) > div > div:nth-child(3) > a > time").text

            except Exception as e:
                #print(e)
                continue

            # 닉네임
            nickname = info[0]

            # 유저id
            user_id = info[1]

            # 게시글
            new_title = li[1].text
            clear_new_title = new_title.split()
            clear_new_title = ' '.join(clear_new_title)

            # 고유 url
            url_gap = extract_last_part(title_url)

            # 연속성 파악
            elements = [item[3] for item in old_titles]

            # 시간조건
            int_catch_title = extract_time(catch_title)

            # 현재시간으로부터 30분까지의 내용만 추출하고 종료하겠다. 
            if int_catch_title[-1] == "분" and int(int_catch_title[:-1]) > 30:
                break


            
            # 삽입
            if url_gap not in elements:
                old_titles.append([user_id, clear_new_title, title_url, url_gap])

                #print(f"게시시간: {catch_title}")
                #print(f"게시물길이: {len(li)}")
                #print("닉네임: ",nickname)
                print("작성자: ", user_id)
                print("게시물내용\n", clear_new_title)
                print("게시글: ", title_url)
                print("\n\n")

        # scroll_count 횟수만큼 내리겠다
        driver.execute_script(scroll_script)
        scroll_count += 1
        time.sleep(1)
    return old_titles

# 크롤링 진행 
def main():
    global driver
    try:
        # 봇 감지 우회 전처리
        open_Driver()
        
        # 로그인 성공하면 생일카페 검색 로직 시작
        if (check_login_selenium_x()):
            print("진행 시작")
            crawling_list = search_x("생일카페")
        

        # file i/o
        with open("output.txt", "a") as file:
            for contents in crawling_list:
                file.write(contents[0]+"\n")
                file.write(contents[1]+"\n")
                file.write(contents[2]+"\n\n")

    except Exception as e:
        print(e)
        print("err")
    finally:
        print("종료")
        driver.quit()

if __name__ == "__main__":
    # 코드 실행시 slack 알람 전송

    main()






