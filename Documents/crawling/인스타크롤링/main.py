from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.chrome.service import Service
from webdriver_manager.chrome import ChromeDriverManager
from selenium.webdriver.common.by import By
import pickle
import time
from datetime import datetime, timezone, timedelta
import requests
import os

## warning
# brew install openssl@1.1
# pip3 install urllib3==1.26.15

def extract_last_part(url):
    # URL을 '/'로 분리
    parts = url.split('/')
    # 맨 마지막 부분 반환
    last_part = parts[-1] if parts[-1] != '' else parts[-2]  # 마지막이 빈 문자열인 경우를 대비
    return last_part

def create_folder(directory):
    if not os.path.exists(directory):
        os.makedirs(directory)
        print(f"폴더 생성됨: {directory}")
    else:
        print(f"폴더가 이미 존재합니다: {directory}")

def download_image(image_url, save_path):
    try:
        response = requests.get(image_url, stream=True, timeout=3)
        if response.status_code == 200:
            with open(save_path, 'wb') as file:
                for chunk in response.iter_content(1024):
                    file.write(chunk)
            print(f"이미지 저장됨: {save_path}")
        else:
            print(f"이미지 다운로드 실패: {image_url}")
    except Exception as e:
        print(f"이미지 다운로드 중 오류 발생: {e}")

def convert_to_kst(iso_time):
    # ISO 8601 형식의 시간을 datetime 객체로 변환
    utc_time = datetime.fromisoformat(iso_time.replace("Z", "+00:00"))

    # 한국 표준시로 변환 (UTC +9시간)
    kst_time = utc_time + timedelta(hours=9)

    # 원하는 형식으로 포맷팅하여 반환
    formatted_time = kst_time.strftime('%Y-%m-%d / %H:%M:%S')
    return formatted_time

def convert_to_kst_folder(iso_time):
    # ISO 8601 형식의 시간을 datetime 객체로 변환
    utc_time = datetime.fromisoformat(iso_time.replace("Z", "+00:00"))

    # 한국 표준시로 변환 (UTC +9시간)
    kst_time = utc_time + timedelta(hours=9)

    # 원하는 형식으로 포맷팅하여 반환
    formatted_time = kst_time.strftime('%Y-%m-%d-%H-%M-%S')
    return formatted_time

def driver_Settings():
    options = Options()

    # 웹드라이버 종료 안시키고 유지
    options.add_experimental_option("detach", True)

    # 주석해제하면 헤드리스 모드
    # options.add_argument("--headless")  # 헤드리스 모드로 실행

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


# 시간 , 내용, 사진
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

    # 게시글
    contents = driver.find_element(By.CSS_SELECTOR, '._ap3a._aaco._aacu._aacx._aad7._aade')

    # 시간정보
    time_info = driver.find_element(By.CSS_SELECTOR,
                                    "body > div.x1n2onr6.xzkaem6 > div.x9f619.x1n2onr6.x1ja2u2z > div > div.x1uvtmcs.x4k7w5x.x1h91t0o.x1beo9mf.xaigb6o.x12ejxvf.x3igimt.xarpa2k.xedcshv.x1lytzrv.x1t2pt76.x7ja8zs.x1n2onr6.x1qrby5j.x1jfb8zj > div > div > div > div > div.xb88tzc.xw2csxc.x1odjw0f.x5fp0pe.x1qjc9v5.xjbqb8w.x1lcm9me.x1yr5g0i.xrt01vj.x10y3i5r.xr1yuqi.xkrivgy.x4ii5y1.x1gryazu.x15h9jz8.x47corl.xh8yej3.xir0mxb.x1juhsu6 > div > article > div > div.x1qjc9v5.x972fbf.xcfux6l.x1qhh985.xm0m39n.x9f619.x78zum5.xdt5ytf.x1iyjqo2.x5wqa0o.xln7xf2.xk390pu.xdj266r.x11i5rnm.xat24cr.x1mh8g0r.x65f84u.x1vq45kp.xexx8yu.x4uap5.x18d9i69.xkhd6sd.x1n2onr6.x11njtxf > div > div > div.x78zum5.xdt5ytf.x1q2y9iw.x1n2onr6.xh8yej3.x9f619.x1iyjqo2.x18l3tf1.x26u7qi.xy80clv.xexx8yu.x4uap5.x18d9i69.xkhd6sd > div.x1yztbdb.x1h3rv7z.x1swvt13 > div > div > a > span > time")

    # datetime 속성과 title 속성 값을 추출
    datetime_value = time_info.get_attribute("datetime")
    title_value = time_info.get_attribute("title")

    # KST 시간으로 변환하여 출력
    kst_time = convert_to_kst(datetime_value)

    #print("게시글 생략")
    print("#########################################################################")
    # print("".join(contents.text.split()))
    # print("KST Datetime:", kst_time)
    # print("Title:", title_value)

    ################################################################################################################################################################################################################################
    # 첫 게시글 하드코딩
    # 폴더 생성
    folder_path = f"image/{convert_to_kst_folder(datetime_value)}"
    create_folder(folder_path)

    # while문에 존재하는 img_selector와 다르기 때문에 중복되는 코드 필요.
    img_selector = "body > div.x1n2onr6.xzkaem6 > div.x9f619.x1n2onr6.x1ja2u2z > div > div.x1uvtmcs.x4k7w5x.x1h91t0o.x1beo9mf.xaigb6o.x12ejxvf.x3igimt.xarpa2k.xedcshv.x1lytzrv.x1t2pt76.x7ja8zs.x1n2onr6.x1qrby5j.x1jfb8zj > div > div > div > div > div.xb88tzc.xw2csxc.x1odjw0f.x5fp0pe.x1qjc9v5.xjbqb8w.x1lcm9me.x1yr5g0i.xrt01vj.x10y3i5r.xr1yuqi.xkrivgy.x4ii5y1.x1gryazu.x15h9jz8.x47corl.xh8yej3.xir0mxb.x1juhsu6 > div > article > div > div._aatk._aatl > div > div.x1lliihq.x1n2onr6 > div.x9f619.xjbqb8w.x78zum5.x168nmei.x13lgxp2.x5pf9jr.xo71vjh.x10l6tqk.x1ey2m1c.x13vifvy.x17qophe.xds687c.x1plvlek.xryxfnj.x1c4vz4f.x2lah0s.xdt5ytf.xqjyukv.x1qjc9v5.x1oa3qoh.x1nhvcw1 > div > div > div > ul > li:nth-child(2) > div > div > div > div > div > div > img"
    img_element = driver.find_element(By.CSS_SELECTOR, img_selector)
    img_url = img_element.get_attribute("src")

    # 여기에 다운로드 로직
    image_name = f"image{0}.jpg"
    save_path = os.path.join(folder_path, image_name)
    download_image(img_url, save_path)



    ###
    img_cnt = 1
    while True:
        clicked = driver.execute_script('''
                    var btn = document.querySelector('button[aria-label="다음"]');
                    if (btn) {
                        btn.click();
                        return true;
                    } else {
                        return false;
                    }
                ''')

        #time.sleep(1.5)

        if clicked:
            # print("클릭됨")
            img_selector = "body > div.x1n2onr6.xzkaem6 > div.x9f619.x1n2onr6.x1ja2u2z > div > div.x1uvtmcs.x4k7w5x.x1h91t0o.x1beo9mf.xaigb6o.x12ejxvf.x3igimt.xarpa2k.xedcshv.x1lytzrv.x1t2pt76.x7ja8zs.x1n2onr6.x1qrby5j.x1jfb8zj > div > div > div > div > div.xb88tzc.xw2csxc.x1odjw0f.x5fp0pe.x1qjc9v5.xjbqb8w.x1lcm9me.x1yr5g0i.xrt01vj.x10y3i5r.xr1yuqi.xkrivgy.x4ii5y1.x1gryazu.x15h9jz8.x47corl.xh8yej3.xir0mxb.x1juhsu6 > div > article > div > div._aatk._aatl > div > div.x1lliihq.x1n2onr6 > div.x9f619.xjbqb8w.x78zum5.x168nmei.x13lgxp2.x5pf9jr.xo71vjh.x10l6tqk.x1ey2m1c.x13vifvy.x17qophe.xds687c.x1plvlek.xryxfnj.x1c4vz4f.x2lah0s.xdt5ytf.xqjyukv.x1qjc9v5.x1oa3qoh.x1nhvcw1 > div > div > div > ul > li:nth-child(3) > div > div > div > div > div > div > img"
            img_element = driver.find_element(By.CSS_SELECTOR, img_selector)
            img_url = img_element.get_attribute("src")

            # 여기에 다운로드 로직
            image_name = f"image{img_cnt}.jpg"
            save_path = os.path.join(folder_path, image_name)
            download_image(img_url, save_path)
            time.sleep(1.5)

            img_cnt += 1
        else:
            break

    # 두 값을 출력
    # print("게시글 생략")
    print("".join(contents.text.split()))
    print("KST Datetime:", kst_time)
    # print("Title:", title_value)

    time.sleep(1.5)



    ################################################################################################################################################################################################################################

    # 첫 게시글 클릭 후 두번째부터 진행과정
    cnt = 0
    while cnt < 3:
        print("#########################################################################")
        # next_btn = driver.find_element(By.CSS_SELECTOR, '.x1lliihq.x1n2onr6.x175jnsf')
        next_btn = driver.find_element(By.CSS_SELECTOR,
                                       'body > div.x1n2onr6.xzkaem6 > div.x9f619.x1n2onr6.x1ja2u2z > div > div.x1uvtmcs.x4k7w5x.x1h91t0o.x1beo9mf.xaigb6o.x12ejxvf.x3igimt.xarpa2k.xedcshv.x1lytzrv.x1t2pt76.x7ja8zs.x1n2onr6.x1qrby5j.x1jfb8zj > div > div > div > div > div:nth-child(1) > div > div > div._aaqg._aaqh > button')
        next_btn.click()

        contents = driver.find_element(By.CSS_SELECTOR,
                                             'body > div.x1n2onr6.xzkaem6 > div.x9f619.x1n2onr6.x1ja2u2z > div > div.x1uvtmcs.x4k7w5x.x1h91t0o.x1beo9mf.xaigb6o.x12ejxvf.x3igimt.xarpa2k.xedcshv.x1lytzrv.x1t2pt76.x7ja8zs.x1n2onr6.x1qrby5j.x1jfb8zj > div > div > div > div > div.xb88tzc.xw2csxc.x1odjw0f.x5fp0pe.x1qjc9v5.xjbqb8w.x1lcm9me.x1yr5g0i.xrt01vj.x10y3i5r.xr1yuqi.xkrivgy.x4ii5y1.x1gryazu.x15h9jz8.x47corl.xh8yej3.xir0mxb.x1juhsu6 > div > article > div > div.x1qjc9v5.x972fbf.xcfux6l.x1qhh985.xm0m39n.x9f619.x78zum5.xdt5ytf.x1iyjqo2.x5wqa0o.xln7xf2.xk390pu.xdj266r.x11i5rnm.xat24cr.x1mh8g0r.x65f84u.x1vq45kp.xexx8yu.x4uap5.x18d9i69.xkhd6sd.x1n2onr6.x11njtxf > div > div > div.x78zum5.xdt5ytf.x1q2y9iw.x1n2onr6.xh8yej3.x9f619.x1iyjqo2.x18l3tf1.x26u7qi.xy80clv.xexx8yu.x4uap5.x18d9i69.xkhd6sd > div.x78zum5.xdt5ytf.x1iyjqo2.xs83m0k.x2lwn1j.x1odjw0f.x1n2onr6.x9ek82g.x6ikm8r.xdj266r.x11i5rnm.x4ii5y1.x1mh8g0r.xexx8yu.x1pi30zi.x18d9i69.x1swvt13 > ul > div.x1qjc9v5.x972fbf.xcfux6l.x1qhh985.xm0m39n.x9f619.x78zum5.xdt5ytf.x2lah0s.xk390pu.xdj266r.x11i5rnm.xat24cr.x1mh8g0r.xexx8yu.x4uap5.x18d9i69.xkhd6sd.x1n2onr6.xggy1nq.x11njtxf > li > div > div > div._a9zr > div._a9zs > h1')
        time_info = driver.find_element(By.CSS_SELECTOR,
                                        "body > div.x1n2onr6.xzkaem6 > div.x9f619.x1n2onr6.x1ja2u2z > div > div.x1uvtmcs.x4k7w5x.x1h91t0o.x1beo9mf.xaigb6o.x12ejxvf.x3igimt.xarpa2k.xedcshv.x1lytzrv.x1t2pt76.x7ja8zs.x1n2onr6.x1qrby5j.x1jfb8zj > div > div > div > div > div.xb88tzc.xw2csxc.x1odjw0f.x5fp0pe.x1qjc9v5.xjbqb8w.x1lcm9me.x1yr5g0i.xrt01vj.x10y3i5r.xr1yuqi.xkrivgy.x4ii5y1.x1gryazu.x15h9jz8.x47corl.xh8yej3.xir0mxb.x1juhsu6 > div > article > div > div.x1qjc9v5.x972fbf.xcfux6l.x1qhh985.xm0m39n.x9f619.x78zum5.xdt5ytf.x1iyjqo2.x5wqa0o.xln7xf2.xk390pu.xdj266r.x11i5rnm.xat24cr.x1mh8g0r.x65f84u.x1vq45kp.xexx8yu.x4uap5.x18d9i69.xkhd6sd.x1n2onr6.x11njtxf > div > div > div.x78zum5.xdt5ytf.x1q2y9iw.x1n2onr6.xh8yej3.x9f619.x1iyjqo2.x18l3tf1.x26u7qi.xy80clv.xexx8yu.x4uap5.x18d9i69.xkhd6sd > div.x1yztbdb.x1h3rv7z.x1swvt13 > div > div > a > span > time")

        photo_next_btn = driver.execute_script('return document.querySelector(\'button[aria-label="다음"]\') ? true : false;')


        #print("현재URL: ", extract_last_part(driver.current_url))

        # datetime 속성과 title 속성 값을 추출
        datetime_value = time_info.get_attribute("datetime")
        title_value = time_info.get_attribute("title")

        # KST 시간으로 변환하여 출력
        kst_time = convert_to_kst(datetime_value)

        # 폴더 생성
        folder_path = f"image/{convert_to_kst_folder(datetime_value)}"
        create_folder(folder_path)

        # while문에 존재하는 img_selector와 다르기 때문에 중복되는 코드 필요.
        img_selector = "body > div.x1n2onr6.xzkaem6 > div.x9f619.x1n2onr6.x1ja2u2z > div > div.x1uvtmcs.x4k7w5x.x1h91t0o.x1beo9mf.xaigb6o.x12ejxvf.x3igimt.xarpa2k.xedcshv.x1lytzrv.x1t2pt76.x7ja8zs.x1n2onr6.x1qrby5j.x1jfb8zj > div > div > div > div > div.xb88tzc.xw2csxc.x1odjw0f.x5fp0pe.x1qjc9v5.xjbqb8w.x1lcm9me.x1yr5g0i.xrt01vj.x10y3i5r.xr1yuqi.xkrivgy.x4ii5y1.x1gryazu.x15h9jz8.x47corl.xh8yej3.xir0mxb.x1juhsu6 > div > article > div > div._aatk._aatl > div > div.x1lliihq.x1n2onr6 > div.x9f619.xjbqb8w.x78zum5.x168nmei.x13lgxp2.x5pf9jr.xo71vjh.x10l6tqk.x1ey2m1c.x13vifvy.x17qophe.xds687c.x1plvlek.xryxfnj.x1c4vz4f.x2lah0s.xdt5ytf.xqjyukv.x1qjc9v5.x1oa3qoh.x1nhvcw1 > div > div > div > ul > li:nth-child(2) > div > div > div > div > div > div > img"
        img_element = driver.find_element(By.CSS_SELECTOR, img_selector)
        img_url = img_element.get_attribute("src")

        # 여기에 다운로드 로직
        image_name = f"image{0}.jpg"
        save_path = os.path.join(folder_path, image_name)
        download_image(img_url, save_path)


        img_cnt = 1
        while True:
            clicked = driver.execute_script('''
                var btn = document.querySelector('button[aria-label="다음"]');
                if (btn) {
                    btn.click();
                    return true;
                } else {
                    return false;
                }
            ''')

            time.sleep(1.5)

            if clicked:
                # print("클릭됨")
                img_selector = "body > div.x1n2onr6.xzkaem6 > div.x9f619.x1n2onr6.x1ja2u2z > div > div.x1uvtmcs.x4k7w5x.x1h91t0o.x1beo9mf.xaigb6o.x12ejxvf.x3igimt.xarpa2k.xedcshv.x1lytzrv.x1t2pt76.x7ja8zs.x1n2onr6.x1qrby5j.x1jfb8zj > div > div > div > div > div.xb88tzc.xw2csxc.x1odjw0f.x5fp0pe.x1qjc9v5.xjbqb8w.x1lcm9me.x1yr5g0i.xrt01vj.x10y3i5r.xr1yuqi.xkrivgy.x4ii5y1.x1gryazu.x15h9jz8.x47corl.xh8yej3.xir0mxb.x1juhsu6 > div > article > div > div._aatk._aatl > div > div.x1lliihq.x1n2onr6 > div.x9f619.xjbqb8w.x78zum5.x168nmei.x13lgxp2.x5pf9jr.xo71vjh.x10l6tqk.x1ey2m1c.x13vifvy.x17qophe.xds687c.x1plvlek.xryxfnj.x1c4vz4f.x2lah0s.xdt5ytf.xqjyukv.x1qjc9v5.x1oa3qoh.x1nhvcw1 > div > div > div > ul > li:nth-child(3) > div > div > div > div > div > div > img"
                img_element = driver.find_element(By.CSS_SELECTOR, img_selector)
                img_url = img_element.get_attribute("src")

                # 여기에 다운로드 로직
                image_name = f"image{img_cnt}.jpg"
                save_path = os.path.join(folder_path, image_name)
                download_image(img_url, save_path)
                time.sleep(1.5)

                img_cnt+=1
            else:
                break


        # 두 값을 출력
        #print("게시글 생략")
        print("".join(contents.text.split()))
        print("KST Datetime:", kst_time)
        # print("Title:", title_value)

        time.sleep(1.5)
        cnt += 1




    print("입력: ")
    n = input()
    if n == 1:
        driver.quit()
    else:
        print("강제종료")
        driver.quit()



