# my lib
import install_import as myimport
# 라이브러리 자동 설치
package_manager = myimport.PackageManager()
package_manager.check_and_install_modules()

from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from webdriver_manager.chrome import ChromeDriverManager
from bs4 import BeautifulSoup
from selenium.webdriver.common.by import By
from urllib.parse import urlparse

#import requests
import time
import pickle
import sys
import re
import requests
import datetime
now = datetime.datetime.now() # 크롤링 시작 및 저장시간



# 봇 감지 전처리
def open_Driver():
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

    return driver


# x 쿠키 저장 함수
def save_cookie_x(driver):
    url = 'https://www.twitter.com/'
    driver.get(url)

    # 30초 이내 로그인
    time.sleep(30)
    pickle.dump(driver.get_cookies(), open('x_cookies.pkl', 'wb')) 

    driver.quit()

# 셀레니움에서 쿠키 정상 동작 확인
def check_login_selenium_x(driver):
    url = 'https://www.twitter.com'
    driver.get(url)

    cookies = pickle.load(open('x_cookies.pkl', 'rb'))
    for cookie in cookies:
        driver.add_cookie(cookie)
    
    driver.refresh()
    driver.implicitly_wait(15)
    time.sleep(1)


    #print("로그인 확인중")
    cur_url = driver.current_url
    # print("현재 URL 마지막 경로: ", cur_url)
    # print("현재 URL 마지막 경로: ", cur_url[-4:])

    
    if (cur_url[-4:] == "home"):
        print("로그인 성공")
    else:
        print("로그인 실패로 프로그램 종료합니다.")
        sys.exit()
        



# x 프로필 정보 가져오기
def get_profile_x(driver):
    driver.implicitly_wait(15)
    profiles = driver.find_elements(By.CSS_SELECTOR, "#react-root > div > div > div.css-175oi2r.r-1f2l425.r-13qz1uu.r-417010.r-18u37iz > header > div > div > div > div:nth-child(1) > div.css-175oi2r.r-15zivkp.r-1bymd8e.r-13qz1uu.r-1awozwy > nav > a")
    profiles[-1].click()


    driver.implicitly_wait(15)
    profile_name = driver.find_element(By.CSS_SELECTOR, "#react-root > div > div > div.css-175oi2r.r-1f2l425.r-13qz1uu.r-417010.r-18u37iz > main > div > div > div > div > div > div:nth-child(3) > div > div > div > div.css-175oi2r.r-ymttw5.r-ttdzmv.r-1ifxtd0 > div.css-175oi2r.r-6gpygo.r-14gqq1x > div.css-175oi2r.r-1wbh5a2.r-dnmrzs.r-1ny4l3l > div > div.css-175oi2r.r-1wbh5a2.r-dnmrzs.r-1ny4l3l > div > div > span > span:nth-child(1)").text
    profile_id = driver.find_element(By.CSS_SELECTOR, "#react-root > div > div > div.css-175oi2r.r-1f2l425.r-13qz1uu.r-417010.r-18u37iz > main > div > div > div > div > div > div:nth-child(3) > div > div > div > div.css-175oi2r.r-ymttw5.r-ttdzmv.r-1ifxtd0 > div.css-175oi2r.r-6gpygo.r-14gqq1x > div.css-175oi2r.r-1wbh5a2.r-dnmrzs.r-1ny4l3l > div > div.css-175oi2r.r-1awozwy.r-18u37iz.r-1wbh5a2 > div > div > div > span").text
    print(f"profile_name: {profile_name}")
    print(f"profile_id: {profile_id}")
    driver.quit()

def search_x(driver, search):
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
    # 스크롤 횟수
    scroll_count = 0    

    
    # 이중리스트, 각 요소는[nickname, user_id, cclear_new_title]
    # 이전의 요소와 비교하기 위한 리스트임 같으면 안들어감
    old_titles = []

    # 현재시간으로부터 60분까지의 게시물만 가져온다 -> 1시간 주기로 반복 돌릴 예정  
    # title_time = 0
    ongoing = True 

    while ongoing:
        # if scroll_count == 10: break
        #if title_time > 30: break

        titles = driver.find_elements(By.CSS_SELECTOR, "#react-root > div > div > div.css-175oi2r.r-1f2l425.r-13qz1uu.r-417010.r-18u37iz > main > div > div > div > div > div > div:nth-child(3) > section > div > div > div")
        
        for title in titles:
            #li = title.find_elements(By.CSS_SELECTOR, "div > div > article > div > div > div:nth-child(2) > div:nth-child(2) > div")
            try:
                li = title.find_elements(By.CSS_SELECTOR, "div > div > article > div > div > div:nth-child(2) > div:nth-child(2) > div")
                info = li[0].text.split("\n")

                # 프로필 url
                profile_url = li[0].find_element(By.CSS_SELECTOR, "div > div > div > div > div > div > a").get_attribute('href')
                
                # 게시글 url
                title_url = li[0].find_element(By.CSS_SELECTOR, "div > div > div > div > div:nth-child(2) > div > div:nth-child(3) > a").get_attribute('href')
                
                # 게시시간
                mytesttime = li[0].find_element(By.CSS_SELECTOR, "div > div > div > div > div:nth-child(2) > div > div:nth-child(3) > a > time").get_attribute('datetime')
                #print("mytesttime: ", mytesttime)

                # 현재시간 - 게시시간
                mytesttime2 = li[0].find_element(By.CSS_SELECTOR, "div > div > div > div > div:nth-child(2) > div > div:nth-child(3) > a > time").text
                #print("mytesttime: ", mytesttime2)
            except:
                continue

            # # 현재 탭의 핸들 저장
            # original_tab = driver.current_window_handle

            # # 새 탭을 열지 여부를 결정하기 위해 현재 열린 탭의 수 확인
            # if len(driver.window_handles) == 1:  # 현재 하나의 탭만 열려 있는 경우
            #     # 새 탭 열기
            #     driver.execute_script("window.open('');")

            # # 새 탭으로 전환 (새 탭이 이미 있었다면 그 탭으로, 새로 열었다면 새 탭으로 전환)
            # new_tab = [tab for tab in driver.window_handles if tab != original_tab][0]
            # driver.switch_to.window(new_tab)

            # # 새 탭에서 원하는 페이지 열기
            # driver.get(profile_url)
            # driver.implicitly_wait(15)
            # time.sleep(1)

            # # 자기소개
            # try:
            #     introduce = driver.find_element(By.CSS_SELECTOR, "#react-root > div > div > div.css-175oi2r.r-1f2l425.r-13qz1uu.r-417010.r-18u37iz > main > div > div > div > div.css-175oi2r.r-kemksi.r-1kqtdi0.r-13l2t4g.r-1ljd8xs.r-1phboty.r-16y2uox.r-184en5c.r-61z16t.r-11wrixw.r-1jgb5lz.r-13qz1uu.r-1ye8kvj > div > div:nth-child(3) > div > div > div > div.css-175oi2r.r-ymttw5.r-ttdzmv.r-1ifxtd0").text.split()
            #     introduce = ' '.join(introduce)
            # except:
            #     introduce = None

            # # input()

            # # 새 탭 닫기
            # driver.close()

            # # 원래 탭으로 돌아오기
            # driver.switch_to.window(original_tab)

            # 게시글 시간
            #title_time = info[-1]
            title_time = mytesttime2


            # 닉네임
            nickname = info[0]

            # 유저id
            user_id = info[1]
            
            # 게시글
            new_title = li[1].text
            clear_new_title = new_title.split()
            cclear_new_title = ' '.join(clear_new_title)

            # 시간
            int_title_time = extract_time(title_time)
            
            # 현재시간으로부터 30분까지의 내용만 추출하고 종료하겠다. 
            if int_title_time[-1] == "분" and int(int_title_time[:-1]) > 30:
                ongoing = False
                break


            url_gap = extract_last_part(title_url)
            # print("nickname: ",nickname)
            # print("user_id: ", user_id)
            # print("profile_url: ", profile_url)
            # print("title_url: ", title_url)
            # print("gap: ", url_gap)
            # print("게시물내용", cclear_new_title)
            # print("게시시간: ", mytesttime)
            
            # print("현재시간 - 게시시간: ", int_title_time)
            # print()
            

            fiveth_elements = [item[4] for item in old_titles]
            #####
            # try:
            #     # 현재 탭의 핸들 저장
            #     original_tab = driver.current_window_handle

            #     # 새 탭을 열지 여부를 결정하기 위해 현재 열린 탭의 수 확인
            #     if len(driver.window_handles) == 1:  # 현재 하나의 탭만 열려 있는 경우
            #         # 새 탭 열기
            #         driver.execute_script("window.open('');")

            #     # 새 탭으로 전환 (새 탭이 이미 있었다면 그 탭으로, 새로 열었다면 새 탭으로 전환)
            #     new_tab = [tab for tab in driver.window_handles if tab != original_tab][0]
            #     driver.switch_to.window(new_tab)

            #     # 새 탭에서 원하는 페이지 열기
            #     driver.get(profile_url)
            #     driver.implicitly_wait(15)
            #     time.sleep(1)
            #     # print(driver.page_source)
            #     # input()


            #      # 자기소개
            #     info = driver.find_elements(By.CSS_SELECTOR, "#react-root > div > div > div.css-175oi2r.r-1f2l425.r-13qz1uu.r-417010.r-18u37iz > main > div > div > div > div > div > div:nth-child(3) > div > div > div > div > div:nth-child(n+2)")
            
            #     # 각 요소의 텍스트를 하나의 문자열로 결합
            #     # all_text = "".join([element.text for element in info])
            #     # 각 요소의 텍스트를 공백으로 분리하고 다시 합치기
            #     introduce = " ".join([" ".join(element.text.split()) for element in info])

            #     # 자기소개
            #     # try:
            #     #     introduce = driver.find_element(By.CSS_SELECTOR, "#react-root > div > div > div.css-175oi2r.r-1f2l425.r-13qz1uu.r-417010.r-18u37iz > main > div > div > div > div.css-175oi2r.r-kemksi.r-1kqtdi0.r-13l2t4g.r-1ljd8xs.r-1phboty.r-16y2uox.r-184en5c.r-61z16t.r-11wrixw.r-1jgb5lz.r-13qz1uu.r-1ye8kvj > div > div:nth-child(3) > div > div > div > div.css-175oi2r.r-ymttw5.r-ttdzmv.r-1ifxtd0").text.split()
            #     #     introduce = ' '.join(introduce)
            #     # except:
            #     #     introduce = None

            #     # 새 탭 닫기
            #     driver.close()

            #     # 원래 탭으로 돌아오기
            #     driver.switch_to.window(original_tab)
            # except:
            #     # 새 탭 닫기
            #     driver.close()

            #     # 원래 탭으로 돌아오기
            #     driver.switch_to.window(original_tab)

            ####
            introduce = "None"
            if url_gap not in fiveth_elements:
                old_titles.append([nickname, user_id, profile_url, title_url, url_gap, cclear_new_title, mytesttime, int_title_time, introduce])
                print("nickname: ",nickname)
                print("user_id: ", user_id)
                print("profile_url: ", profile_url)
                print("title_url: ", title_url)
                print("gap: ", url_gap)
                print("게시물내용: ", cclear_new_title)
                print("게시시간: ", mytesttime)
                print("현재시간 - 게시시간: ", int_title_time)
                print("자기소개: ", introduce)
                print()
        # scroll_count 횟수만큼 내리겠다
        driver.execute_script(scroll_script)
        scroll_count += 1
        time.sleep(1.2) 
    return old_titles

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


def extract_last_part(url):
    # URL을 '/'로 분리
    parts = url.split('/')
    # 맨 마지막 부분 반환
    last_part = parts[-1] if parts[-1] != '' else parts[-2]  # 마지막이 빈 문자열인 경우를 대비
    return last_part


def main():
    try:
        ## slack
        
        # 봇 감지 전처리
        driver = open_Driver()

        # 1. 최초 한번만 실행, 이후 주석 처리
        #save_cookie(driver)

        # x login
        check_login_selenium_x(driver)

        # x profile
        #get_profile_x(driver)

        # search
        print("생일카페 검색중...")
        crawling_list = search_x(driver, "생일카페")

         # file i/o
        with open("x_crawling_output.txt", "a") as file:
            # if file.tell() > 0:
            #     file.write("\n")  # 파일이 이미 존재할 경우, 줄 바꿈 추가
                # print("이미 파일 존재")
            print("############################################################")
            file.write(f"크롤링 수집 시작: {now}\n")
            for contents in crawling_list:
                # print("닉네임: ", contents[0])
                # print("계정명: ", contents[1])
                # print("게시글: ", contents[2])
                # # print("게시글: ",''.join(contents[2]))
                # print()

                # print("닉네임: ",contents[0])
                print("유저id: ", contents[1])
                # print("프로필url: ", contents[2])
                print("게시물 url: ", contents[3])
                # print("게시물고유코드: ", contents[4])
                print("게시물내용: ", contents[5])
                print("게시시간: ", contents[6])
                # print("현재시간 - 게시시간: ", contents[7])

                file.write(f"닉네임: {contents[0]}\n")
                file.write(f"유저id: {contents[1]}\n")
                # file.write(f"프로필url: {contents[2]}\n")
                file.write(f"게시물url: {contents[3]}\n")
                # file.write(f"게시물고유코드: {contents[4]}\n")
                file.write(f"게시물내용: {contents[5]}\n")
                file.write(f"게시시간: {contents[6]}\n")
                # file.write(f"현재시간 - 게시시간: {contents[7]}\n")
                file.write("\n")
                # print("자기소개: ", contents[8])
                print()

    except Exception as e:
        print(e)
        driver.quit()
        print("강제종료")
    finally:
        driver.quit()
        print("정상종료")
    
def main2():
    
    # 봇 감지 전처리
    driver = open_Driver()

    # 1. 최초 한번만 실행, 이후 주석 처리
    #save_cookie(driver)

    # x login
    check_login_selenium_x(driver)

    # x profile
    #get_profile_x(driver)

    # search
    print("생일카페 검색중...")
    crawling_list = search_x(driver, "생일카페")

    # print("############################################################")
    for contents in crawling_list:
        print("닉네임: ",contents[0])
        print("유저id: ", contents[1])
        print("프로필url: ", contents[2])
        print("게시물_url: ", contents[3])
        print("게시물고유코드: ", contents[4])
        print("게시물내용: ", contents[5])
        print("게시시간: ", contents[6])
        print("현재시간 - 게시시간: ", contents[7])
        print("자기소개: ", contents[8])
        print()


    driver.quit()

    print("정상종료")
    

if __name__ == '__main__':
    main()













# def find_unique_parts(url1, url2):
#     # URL 파싱
#     parsed_url1 = urlparse(url1)
#     parsed_url2 = urlparse(url2)
    
#     # 경로 분리
#     path1 = parsed_url1.path
#     path2 = parsed_url2.path
    
#     # 고유 부분 추출
#     unique_path1 = path1.replace(path2, '') if path2.startswith(path1) else path1
#     unique_path2 = path2.replace(path1, '') if path1.startswith(path2) else path2
    
#     return unique_path1, unique_path2
