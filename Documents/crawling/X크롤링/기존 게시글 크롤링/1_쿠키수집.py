from selenium import webdriver
from selenium.webdriver.chrome.service import Service
from selenium.webdriver.chrome.options import Options
from webdriver_manager.chrome import ChromeDriverManager
import time
import pickle


# 봇 감지 전처리
def open_Driver():
    options = Options()

    #options.add_experimental_option("detach", True)
    #options.add_argument("--headless")  # 헤드리스 모드로 실행

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


def main():
    try:        
        # 봇 감지 전처리
        driver = open_Driver()

        # 1. 최초 한번만 실행, 이후 주석 처리
        save_cookie_x(driver)

    except Exception as e:
        print(e)
        driver.quit()
        print("강제종료")
    finally:
        driver.quit()
        print("정상종료")
    

if __name__ == '__main__':
    main()











