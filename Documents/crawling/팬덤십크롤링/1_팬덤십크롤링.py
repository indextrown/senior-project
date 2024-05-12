import requests
from bs4 import BeautifulSoup
import os



def crawling(name, page, text_filename):

    # 이미지 저장 디렉토리 설정
    if not os.path.exists("images"):
        os.makedirs("images")

    # 텍스트 파일로 저장
    text_list = []

    # 이미지 파일용 cnt
    cnt = 0
    for site in range(1, page+1):
        response = requests.get(f"https://fandomship.com/bbs/board.php?bo_table={name}&page={site}")
        html = response.text
        soup = BeautifulSoup(html, 'html.parser')
        sites = soup.select("#fboardlist > div.tbl_head01.tbl_wrap > table > tbody > tr")
        print(f"{site}페이지 크롤링중")
        mycount = 1
        for i in sites:
            banner = i.select_one("#fboardlist > div.tbl_head01.tbl_wrap > table > tbody > tr > td:nth-child(1)").text.split()
            if banner[0] != "공지":
                # 번호 추가
                mycount +=1

                # 각 게시물 링크
                link = i.select_one("td > div > a").attrs['href']
                response = requests.get(link)
                html = response.text
                soup = BeautifulSoup(html, 'html.parser')


                # 게시물 제목
                title = soup.select_one("#bo_v_title > span.bo_v_tit").text.strip()


                # 게시물 내용
                inline = soup.select_one("#bo_v_con").text.split()
                cleaned_inline = ''.join(inline)


                # 게시물을 증빙하는 트위터 링크
                link = soup.select_one("#bo_v_link > ul > li > a").attrs['href']


                # 이미지들
                images = soup.select("#bo_v_img > a > img")


                # 이미지폴더 저장                
                folder_path = f"images/"
                if not os.path.exists(folder_path):
                    os.makedirs(folder_path)


                # 이미지 다운로드 및 저장
                image_paths = []
                for idx, img in enumerate(images):
                    # img_url = img.attrs['href']
                    img_url = img.get('src')
                    img_response = requests.get(img_url)
                    image_filename = f"{cnt}_{idx}.jpg"
                    image_path = os.path.join(folder_path, image_filename)


                    # 이미지 저장
                    with open(folder_path+image_filename, 'wb') as f:
                        f.write(img_response.content)
                    image_paths.append(image_path)


                # 텍스트에 저장
                text_list.append("제목: "+title+"\n" + "내용: "+cleaned_inline+"\n" + "링크: "+link+"\n" + "\n\n")
                cnt+=1


    with open(text_filename, "w") as textfile:
        for i in text_list:
            textfile.write(i)


    print(f"크롤링 완료, 총 {cnt}개의 데이터 추출\n")


if __name__ == "__main__":
    # 크롤링 결과 txt파일로 output
    print("원하는 연예인 생일카페 정보를 입력해주세요")
    print("1: 아이들, 2: 방탄소년단")
    target = (input("입력: "))
 
    if (target == "1"):
        print("아이들 수집 시작\n\n")
        # output: text_filename로 크롤링 결과 추출
        crawling(name="g_i_dle", page=3, text_filename="all_contents.txt") 

     
    elif (target == "2"):
        print("방탄소년단 수집 시작\n\n")
        crawling(name="bts", page=3 , text_filename="all_contents.txt")

