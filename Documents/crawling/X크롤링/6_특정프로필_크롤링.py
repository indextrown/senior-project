from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.chrome.service import Service
from webdriver_manager.chrome import ChromeDriverManager
import pickle
# from selenium.webdriver.common.by import By
import time
import sys

class WebDriverManager:
    def __init__(self):
        self.driver = None
        self.initialize_driver()

    def initialize_driver(self):
        options = Options()
        # 웹드라이버 종료 안시키고 유지
        # options.add_experimental_option("detach", True)

        # 주석해제하면 헤드리스 모드
        # options.add_argument("--headless")  # 헤드리스 모드로 실행

        options.add_argument(
            'user-agent=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36')
        options.add_argument('lang=ko_KR')
        options.add_argument('--window-size=932,932')
        options.add_argument('--disable-gpu')
        options.add_argument('--disable-infobars')
        options.add_argument('--disable-extensions')
        options.add_argument('--disable-blink-features=AutomationControlled')
        options.add_argument('--disable-automation')

        self.driver = webdriver.Chrome(service=Service(ChromeDriverManager().install()), options=options)

    def quit(self):
        if self.driver:
            self.driver.quit()
            self.driver = None

class TwitterCrawler:
    def __init__(self):
        self.driver_manager = WebDriverManager()

    def check_login(self, url):
        self.driver_manager.driver.get(url)
        self.driver_manager.driver.implicitly_wait(15)

        cookies = pickle.load(open('x_cookies.pkl', 'rb'))
        for cookie in cookies:
            self.driver_manager.driver.add_cookie(cookie)

        self.driver_manager.driver.refresh()
        self.driver_manager.driver.implicitly_wait(15)
        time.sleep(1.5)

        current_url = self.driver_manager.driver.current_url

        if current_url.endswith("home"):
            print("로그인 성공")
            return True
        else:
            print("로그인 실패로 프로그램 종료합니다.")
            self.driver_manager.quit()
            sys.exit()

    def profile_crawling(self, profile_url):
        login_url = "https://www.twitter.com"
        if self.check_login(login_url):
            self.driver_manager.driver.get(profile_url)
            self.driver_manager.driver.implicitly_wait(15)
            time.sleep(1.5)

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

            i = 0
            while i < 3:
                self.driver_manager.driver.execute_script(scroll_script)
                i += 1
                time.sleep(3)
            self.driver_manager.quit()
            self.driver_manager.initialize_driver()  # 새 드라이버 인스턴스를 초기화

def main():
    crawler = TwitterCrawler()
    print("아이브 크롤링 시작")
    crawler.profile_crawling("https://x.com/IVEstarship")

    print("뉴진스 크롤링 시작")
    crawler.profile_crawling("https://x.com/NewJeans_ADOR")

if __name__ == "__main__":
    main()
