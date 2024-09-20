import openai
import json
import re
from datetime import datetime
import requests

def format_date(date_str):
    try:
        # 유연한 포맷으로 날짜를 파싱하고 YYYY-MM-DD 형식으로 변환
        date_obj = datetime.strptime(date_str, '%Y-%m-%d')
        return date_obj.strftime('%Y-%m-%d')
    except ValueError:
        return date_str  # 변환 실패 시 원본을 반환

def gpt_api(file_path):
    print("\ngpt 진행 시작\n")
    client = openai.OpenAI(api_key='GPT_API')
    msg = []

    now = datetime.now()
    msg.append(now.strftime('%Y-%m-%d %H:%M:%S'))
    f = open(file_path, 'r', encoding='UTF8')

    lines = f.readlines()
    #print("input : " + str(lines))
    for line in lines:
        line = line.strip()  # 줄 끝의 줄 바꿈 문자를 제거한다.
        msg.append(line)
    f.close()
    formatted_text = f"제목:{msg}"
    formatted_text = formatted_text.replace("\\", "")
    formatted_text = formatted_text.replace('"', '')
    # print(formatted_text)

    completion = client.chat.completions.create(
        model="gpt-4o",
        temperature=0.1,
        response_format={"type": "json_object"},
        messages=[
            {
                "role": "system",
                "content": """You're summarize assistant. \
Please answer in Korean. \
I need to extract all the birthday cafe. \
I only need information about the birthday cafe. \
If there is no information about the cafe, print null. \
Please print out the order in the order of number, name, author, start_date, end_date, place and link. \
Please print out the output data in the form of a list. \
Make sure you print everything out. \
You must organize only about the birthday cafe schedule. \
Only put numbers in the date. \
Please print out in json format. \
Date should be in YYYY-MM-DD format\
Make sure you keep that in mind\
Fix the date format to mm/dd~mm/dd
The following is an example of the output:
{
    "1": {
        "celebrity": "슈가",
        "uploader": "@2024sugadays",
        "start_date": "2024-03-06",
        "end_date": "2024-03-09",
        "place": "카페 키드문: 서울 용산구 한강대로10길 11-68, 1층",
        "post_url": "https://fandomship.com/bbs/link.php?bo_table=bts&wr_id=206&no=1&page=1"
    },
    "2": {
        "celebrity": "임영웅",
        "uploader": "@timeslashcafe2",
        "start_date": "2024-06-09",
        "end_date": "2024-06-09",
        "place": "부산 타임슬래시",
        "post_url": "https://x.com/timeslashcafe2/status/1797519845355126945"
    },
    "3": {
        "celebrity": "AB6IX",
        "uploader": "@cafe_ys_event",
        "start_date": "2024-05-22",
        "end_date": "2024-05-26",
        "place": "#더서초",
        "post_url": "https://x.com/cafe_ys_event/status/1797519611828814030"
    }
}"""
            },
            {"role": "user", "content": f"{formatted_text}"}
        ]
    )

    i = str(completion.choices[0].message)
    start = i.find('{')
    end = i.rfind('}') + 1
    json_str = i[start:end]
    # 원하는 부분을 추출 및 오류가 발생하는 \, ' 제거
    json_str = json_str.replace('\\n', '').replace('\n', '').replace('\\t', '').replace('\t', '').replace('\\\\', '\\')
    json_str = json_str.replace(' "null"', ' null')
    json_str = re.sub(r'"(\w+)"\s+null', r'"\1": null', json_str)
    json_str = json_str.replace("'", "")
    json_str = json_str.replace("\\", "")
    json_str = json_str.replace("#", "")
    json_str = json_str.rstrip()
    # 끝 부분에 }가 없는 경우에 대해서 처리
    if json_str.endswith('}}'):
        pass
    elif json_str.endswith('}'):
        json_str += '}'
    else:
        # If it does not end with }, add }}
        json_str += '}}'
    # print(json_str)

    # json_str이 JSON 문자열인지 딕셔너리인지 확인
    if isinstance(json_str, str):
        try:
            # JSON 문자열을 파이썬 데이터로 변환
            json_data = json.loads(json_str)
        except json.JSONDecodeError as e:
            print(f"JSON Decode Error: {e}")
            json_data = {}  # JSON Decode Error 발생 시 빈 딕셔너리 반환
        except Exception as e:
            print(f"Error: {e}")
            json_data = {}  # 기타 예외 발생 시 빈 딕셔너리 반환
    else:
        json_data = json_str  # 문자열이 아닌 경우 그대로 반환

    filtered_data = {}
    filtered_pattern = re.compile(r'^\d{4}-\d{1,2}-\d{1,2}$')

    # json_data가 리스트인 경우와 딕셔너리인 경우를 나눠서 처리
    if isinstance(json_data, list):
        for item in json_data:
            if isinstance(item, dict):
                for key, value in item.items():
                    if isinstance(value, dict):
                        if value.get('start_date') and value.get('end_date') and value.get('place') and\
                                filtered_pattern.match(value['start_date']) and\
                                filtered_pattern.match(value['end_date'])\
                                and value['start_date'] not in ['null', '', '추후 공지', '미정','알수 없음','알 수 없음', '정보 없음', '생략', '미상', '불명','오늘'] \
                                and value['end_date'] not in ['null', '', '추후 공지', '미정','알수 없음','알 수 없음', '정보 없음', '생략', '미상', '불명','오늘'] \
                                and value['place'] not in ['null', '', '추후 공지', '미정','알수 없음', '알 수 없음', ' 정보 없음', '생략', '미상', '불명', '서울', '부산', '대구','광주', '대전', '생일카페']:
                            value['start_date'] = format_date(value['start_date'])
                            value['end_date'] = format_date(value['end_date'])
                            filtered_data[key] = value
    elif isinstance(json_data, dict):
        for key, value in json_data.items():
            if isinstance(value, dict):
                if value.get('start_date') and value.get('end_date') and value.get('place') and\
                        filtered_pattern.match(value['start_date']) and \
                        filtered_pattern.match(value['end_date'])\
                        and value['start_date'] not in ['null', '', '추후 공지', '미정','알수 없음', '알 수 없음', '정보 없음', '생략', '미상', '불명','오늘']\
                        and value['start_date'] not in ['null', '', '추후 공지', '미정','알수 없음', '알 수 없음', '정보 없음', '생략', '미상', '불명','오늘']\
                        and value['place'] not in ['null', '', '추후 공지', '미정','알수 없음', '알 수 없음', '정보 없음', '생략', '미상', '불명', '서울', '부산', '대구', '광주', '대전', '생일카페']:
                    value['start_date'] = format_date(value['start_date'])
                    value['end_date'] = format_date(value['end_date'])
                    filtered_data[key] = value

    file_path = 'output_no_addr_gpt.json'

    with open(file_path, 'w', encoding='utf-8') as file:
        json.dump(filtered_data, file, ensure_ascii=False, indent=4)
    for key in filtered_data:
        print("정제데이터 키 : " + key)
    print("\ngpt 진행 종료\n")

    place_addr()

def get_location(place_name, api_key):
    if '카페' not in place_name:
        place_name = '카페 ' + place_name
    # Google Maps Geocoding API URL
    url = f'https://maps.googleapis.com/maps/api/geocode/json?address={place_name}&key={api_key}&language=ko'

    # API 호출
    response = requests.get(url)
    #print(f"Requesting location for: {place_name}")  # 디버깅용
    if response.status_code == 200:
        data = response.json()
        if len(data['results']) > 0:
            # 첫 번째 결과에서 위치 데이터 추출
            address = data['results'][0]['formatted_address']
            #print("address : " + address+"\n")
            return {
                'address': address
            }
        else:
            #print("address not found\n")
            return {'address': 'X'}


def place_addr():
    print("주소 추가 시작\n")
    input_file = 'output_no_addr_gpt.json'
    output_file = 'output_gpt.json'

    with open(input_file, 'r', encoding='utf-8') as f:
        data = json.load(f)

    google_api = "Google_API" #Google Maps API

    # 데이터 순회하면서 주소 추가
    for key, entry in data.items():
        print(f"Key: {key} 장소 추가")  # 디버깅용
        if 'place' in entry:
            place_name = entry['place']
            #print(f"Place: {place_name}")  # 디버깅용
            # 주소 가져오기
            location_data = get_location(place_name, google_api)
            # 주소를 엔트리에 추가
            entry['address'] = location_data['address']

    # 변경된 데이터를 새로운 JSON 파일로 저장
    with open(output_file, 'w', encoding='utf-8') as f:
        json.dump(data, f, ensure_ascii=False, indent=4)

    print("\n주소 추가 종료\n")
    #print(f"주소가 추가된 데이터가 {output_file}에 저장되었습니다.")
