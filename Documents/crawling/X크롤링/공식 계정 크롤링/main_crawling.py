from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.chrome.service import Service
from webdriver_manager.chrome import ChromeDriverManager
import pickle
from selenium.webdriver.common.by import By
import time
import sys
import os
import requests


## warning
# brew install openssl@1.1
# pip3 install urllib3==1.26.15

## error solved
# rm -rf /users/kimdonghyeon/.wdm
# pip3 uninstall webdriver-manager
# pip3 install webdriver-manager

## 폴더 생성
def create_folder(directory):
    if not os.path.exists(directory):
        os.makedirs(directory)
        print(f"폴더 생성됨: {directory}")
    else:
        print(f"폴더가 이미 존재합니다: {directory}")

## 이미지 다운로드
def download_image(image_url, save_path):
    try:
        response = requests.get(image_url, stream=True)
        if response.status_code == 200:
            with open(save_path, 'wb') as file:
                for chunk in response.iter_content(1024):
                    file.write(chunk)
            print(f"이미지 저장됨: {save_path}")
        else:
            print(f"이미지 다운로드 실패: {image_url}")
    except Exception as e:
        print(f"이미지 다운로드 중 오류 발생: {e}")

## url 마지막 / 우측 요소만 뽑아냄
def extract_last_part(url):
    # URL을 '/'로 분리
    parts = url.split('/')
    # 맨 마지막 부분 반환
    last_part = parts[-1] if parts[-1] != '' else parts[-2]  # 마지막이 빈 문자열인 경우를 대비
    return last_part

## 드라이버 최적화
def driver_Settings():
    options = Options()

    # 웹드라이버 종료 안시키고 유지
    #options.add_experimental_option("detach", True)

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

## 로그인 확인
def check_login(driver, url):
    driver.get(url)
    driver.implicitly_wait(15)

    cookies = pickle.load(open('x_cookies.pkl', 'rb'))
    for cookie in cookies:
        driver.add_cookie(cookie)

    # 새로고침 및 새로고침 지연시간 고려
    driver.refresh()
    driver.implicitly_wait(15)
    time.sleep(1.5)


    # 새로고침하여 로그인된 상태의  url 가져온다
    current_url = driver.current_url

    if (current_url[-4:] == "home"):
        print("로그인 성공")
        return True;
    else:
        print("로그인 실패로 프로그램 종료합니다.")
        driver.quit()
        sys.exit()
        return False;

## 크롤링 진행
def profile_crawling(profile_url_list):
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

    login_url = "https://www.twitter.com"
    driver = driver_Settings()
    if check_login(driver, login_url):
        all_titles = []
        for url in profile_url_list:
            profile_name = url.split("/")[-1]
            print(profile_name, "크롤링 시작")
            folder_path = f"image/{profile_name}"
            create_folder(folder_path)

            driver.get(url)
            driver.implicitly_wait(15)
            time.sleep(3)

            # 기저사례동안 크롤링 진행
            i = 0

            old_titles = []
            while(i < 3):
                posts = driver.find_elements(By.CSS_SELECTOR, "#react-root > div > div > div.css-175oi2r.r-1f2l425.r-13qz1uu.r-417010.r-18u37iz > main > div > div > div > div.css-175oi2r.r-kemksi.r-1kqtdi0.r-1ua6aaf.r-th6na.r-1phboty.r-16y2uox.r-184en5c.r-1c4cdxw.r-1t251xo.r-f8sm7e.r-13qz1uu.r-1ye8kvj > div > div:nth-child(3) > div > div > section > div > div > div > div > div  > article")

                # 프로필명, 게시글내용, 게시글날짜시간, url, 이미지절대경로
                for num, post in enumerate(posts):
                    # pinned게시글 무시
                    chrcktitle = post.find_element(By.CSS_SELECTOR, "div > div > div:nth-child(1)").text.split()

                    if ' '.join(chrcktitle) == "Pinned": continue

                    if len(chrcktitle) > 1 and chrcktitle[-1] == 'reposted': continue

                    # 게시글 정보 전처리
                    postinfo = post.find_elements(By.CSS_SELECTOR, "div > div > div:nth-child(2) > div:nth-child(2) > div")

                    # 게시글 정보
                    postname = postinfo[0].find_element(By.CSS_SELECTOR, "div > div > div:nth-child(1)").text.split()
                    # print(postname)

                    index = postname.index('·')
                    index_with_at = -1
                    for index, element in enumerate(postname):
                        if '@' in element:
                            index_with_at = index
                            break

                    post_name = ''.join(postname[index_with_at])
                    post_date = ' '.join(postname[index+2:])
                    post_conents = ' '.join(postinfo[1].text.split())


                    # url
                    post_url = driver.execute_script(
                        """
                        var element = arguments[0].querySelector("div > div:nth-child(1) > div:nth-child(1) > div > div:nth-child(2) > div > div:nth-child(3) > a");
                        if (element) {
                            return element.getAttribute('href');
                        } else {
                            return null;
                        }
                        """,
                        postinfo[0]
                    )

                    if not post_url:
                        print("No URL found")
                        continue

                    url_gap = extract_last_part(post_url)

                    # 연속성 파악
                    elements = [extract_last_part(item[3]) for item in old_titles]

                    # 비디오 태그 여부 확인
                    has_video = driver.execute_script(
                        "return arguments[0].querySelectorAll('div > div > div > div > div > div video').length > 0;",
                        postinfo[-2]
                    )

                    # 비디오 태그가 있는 경우 빈 리스트 반환
                    if has_video:
                        error_srcs = []
                    else:
                        errtest_elements = driver.execute_script(
                            "return arguments[0].querySelectorAll('div > div > div > div > div > div > div > div img');",
                            postinfo[-2])
                        error_srcs = [elem.get_attribute("src") for elem in errtest_elements] if errtest_elements else []

                    if url_gap not in elements:
                        test_len = len(postinfo)

                        if test_len <= 4:
                            # 이미지 없는경우 빈리스트 반환
                            error_srcs = []


                        # 존재하면
                        if error_srcs:
                            images_path = []
                            for img_num, img_url in enumerate(error_srcs):
                                # image_filename = f"{profile_name}_{i}_{img_num}.jpg"
                                image_filename = f"{profile_name}_{url_gap}_{img_num}.jpg"
                                image_save_path = os.path.join(folder_path, image_filename)
                                download_image(img_url, image_save_path)
                                images_path.append(image_save_path)

                            old_titles.append([post_name, post_date, post_conents, post_url, images_path])
                        else:
                            old_titles.append([post_name, post_date, post_conents, post_url, ["NULL"]])


                driver.execute_script(scroll_script)
                time.sleep(2.5)
                i += 1
            print("####################################################################")
            all_titles.append(url.split("/")[-1]+"크롤링 시작")
            all_titles.append("####################################################################")
            all_titles.extend(old_titles)
            all_titles.append("\n")

        with open('output.txt', 'w', encoding='utf-8') as file:
            file.write('\n'.join([str(res) for res in all_titles]))

    driver.quit()

# main함수
def main():
    # 게시글 크롤링할 프로필 리스트
    profile_url_list = ["https://x.com/IVEstarship",
                        "https://x.com/NewJeans_ADOR",
                        "https://x.com/bts_bighit"
                        ]
    profile_crawling(profile_url_list)

if __name__ == "__main__":
    main()



# selenium
# webdriver_manager