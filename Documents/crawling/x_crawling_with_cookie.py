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

import requests
import time
import pickle



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
    options.add_argument('--window-size=430,932') 
    
    # GPU 가속을 비활성화. GPU 가속이 활성화되어 있으면, Chrome이 GPU를 사용하여 그래픽을 렌더링하려고 시도할 수 있기때문. 일부 환경에서는 GPU 가속이 문제를 일으킬 수 있으므로 이 옵션을 사용하여 비활성화
    options.add_argument('--disable-gpu')

    # 정보 표시줄을 비활성화. 정보 표시줄은 Chrome 브라우저 상단에 나타나는 알림이나 메시지를 의미. 이 옵션을 사용하여 이러한 알림이 나타나지 않도록 설정.
    options.add_argument('--disable-infobars')

    # 확장 프로그램을 비활성화합니다. Chrome에서 확장 프로그램을 사용하지 않도록 설정
    options.add_argument('--disable-extensions')

    #  자동화된 기능을 비활성화. 이 옵션은 Chrome이 자동화된 환경에서 실행되는 것을 감지하는 것을 방지.
    options.add_argument('--disable-blink-features=AutomationControlled')

    # 자동화를 비활성화. 이 옵션은 Chrome이 자동화 도구에 의해 제어되는 것으로 감지되는 것을 방지
    options.add_argument('--disable-automation')

    # service = Service(executable_path=ChromeDriverManager().install())
    # driver = webdriver.Chrome(service=service, options=options)
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


def main():
    # 봇 감지 전처리
    driver = open_Driver()

    # 1. 최초 한번만 실행, 이후 주석 처리
    #save_cookie(driver)

    # x login
    check_login_selenium_x(driver)

    # x profile
    get_profile_x(driver)
    

if __name__ == '__main__':
    main()

