import openai
import json
import re
client = openai.OpenAI(api_key = 'API_KEY')

def gpt_api(file_path):
    msg = []

    f = open(file_path, 'r', encoding='UTF8')
    lines = f.readlines()
    for line in lines:
        line = line.strip()  # 줄 끝의 줄 바꿈 문자를 제거한다.
        msg.append(line)
    f.close()
    formatted_text = f"제목:{msg}"
    formatted_text = formatted_text.replace('"', '')
    print(formatted_text)

    completion = client.chat.completions.create(
        model="gpt-4o",
        temperature=0.1,
        response_format={"type":"json_object"},
        messages=[
            {
                "role": "system",
                "content": """[게시자아이디, 게시글작성시간, 게시글내용, 게시글링크, [사진의 경로]]의  인스타 크롤링 데이터가 주어지는데 데이터를 방송/행사/사진 의 종류를 판단하여 제목, 내용, 게시자아이디, 배우, 행사날짜시간(없다면 게시글날짜시간과 똑같이 출력),게시글날짜시간,url,종류,사진의경로의 json형식의 데이터로 출력해줘 모든 데이터를 해줘 데이터가 없다면 NULL을 넣어줘 단 행사날짜시간은 없다면 게시글날짜 시간과 똑같이 출력해 날짜 데이터는 모두 yyyy-mm-dd /time 형식으로 출력해줘 제목은 왠만하면 겹치지 않았으면 좋겠어. 다음은 출력 예시야
{
    "1": {
        "title": "<폭군> 홍보 일정 비하인드 모음집",
        "detail":  "더운 여름 시원하게 보낼수 있는 김선호 배우의 디즈니+ 오리지널 시리즈 <폭군> 홍보 일정 비하인드 모음집 선물 🎁 - 📢 디즈니+ 오리지널 시리즈 <폭군> 지금 절찬 스트리밍 중 -",
        "id": "@salt_ent",
        "artist": "김선호",
        "event_date": "2024-08-20 / 17:05:46",
        "post_date": "2024-08-20 / 17:05:46",
        "url": "https://www.instagram.com/p/C-4mfwXyj32/?img_index=1",
        "kind": "방송",
        "photo":[
            "image/insta/@salt_ent/2024-08-20-17-05-46/image0.jpg",
            "image/insta/@salt_ent/2024-08-20-17-05-46/image1.jpg",
            "image/insta/@salt_ent/2024-08-20-17-05-46/image2.jpg",
            "image/insta/@salt_ent/2024-08-20-17-05-46/image3.jpg",
            "image/insta/@salt_ent/2024-08-20-17-05-46/image4.jpg"
        ]
            },
    "2": {
 	    "title": "김주헌 광고 촬영 비하인드",
        "detail": "감 찾으러 오셨나봐요? - 신뢰감, 안도감, 안정감, 자신감을 키워낸 감농장 농부로 변신한 김주헌 배우의 교보생명 광고 촬영 비하인드 💜 -",
        "id": "@salt_ent",
        "artist": "김주헌",
        "event_date": "2024-08-19 / 17:00:28",
        "post_date": "2024-08-19 / 17:00:28",
        "url": "https://www.instagram.com/p/C-2BGFPyULC/?img_index=5",
        "kind": "행사",
        "photo": [
            "image/insta/@salt_ent/2024-08-19-17-00-28/image0.jpg",
            "image/insta/@salt_ent/2024-08-19-17-00-28/image1.jpg",
            "image/insta/@salt_ent/2024-08-19-17-00-28/image2.jpg",
            "image/insta/@salt_ent/2024-08-19-17-00-28/image3.jpg",
            "image/insta/@salt_ent/2024-08-19-17-00-28/image4.jpg"
        ]
    },
    "3": {
        "title": "박신혜 <지옥에서 온 판사> 첫 스틸 공개",
        "detail": "#박신혜#Parkshinhye#朴信惠판사의몸에들어간,지옥에서온악마’강빛나‘의첫스틸!😈-🔜9월21일(토)밤10시,SBS<지옥에서온판사>1회,2회연속방송!-#지옥에서온판사#TheJudgeFromHell#강빛나#출처_SBS_금토드라마_지옥에서온판사",
        "id": "@salt_ent",
        "artist": "박신혜",
        "event_date": "2024-08-19 / 11:32:40",
        "post_date": "2024-08-19 / 11:32:40",
        "url": "https://www.instagram.com/p/C-1blO0SP0n/?img_index=5",
        "kind": "방송",
        "photo": [
            "image/insta/@salt_ent/2024-08-19-11-32-40/image0.jpg",
            "image/insta/@salt_ent/2024-08-19-11-32-40/image1.jpg",
            "image/insta/@salt_ent/2024-08-19-11-32-40/image2.jpg"
        ]
    },
    "4": {
        "title": "김주헌 <크로스> 넷플릭스 1위 등극",
        "detail": "#김주헌#Kimjuhun글로벌톱10영화(비영어)부문1위에등극한넷플릭스영화<크로스>속김주헌배우:)-아직도<크로스>를보지못한분들이계시다면,지금바로넷플릭스에서만나보세요!(시간순삭,꿀잼보장!🤙)-#넷플릭스#Netflix#크로스#Mission_Cross#중산#출처_넷플릭스",
        "id": "@salt_ent",
        "artist": "김주헌",
        "event_date": "2024-08-16 / 17:02:48",
        "post_date": "2024-08-16 / 17:02:48",
        "url": "https://www.instagram.com/p/C-uS-hVS5wo/?img_index=3",
        "kind": "방송",
        "photo": [
            "image/insta/@salt_ent/2024-08-16-17-02-48/image0.jpg",
            "image/insta/@salt_ent/2024-08-16-17-02-48/image1.jpg",
            "image/insta/@salt_ent/2024-08-16-17-02-48/image2.jpg",
            "image/insta/@salt_ent/2024-08-16-17-02-48/image3.jpg"
        ]
    },
    "5": {
        "title": "박신혜 <지옥에서 온 판사> 티저 포스터 공개",
        "detail": "#박신혜#Parkshinhye#朴信惠SBS새금토드라마<지옥에서온판사>티저포스터공개!-사악하지만사랑스러운악마’강빛나‘가있는세계로온걸환영해😈-🔜9월21일(토)밤10시,<지옥에서온판사>1회,2회연속방송!-#지옥에서온판사#TheJudgeFromHell#강빛나#출처_SBS_금토드라마_지옥에서온판사",
        "id": "@salt_ent",
        "artist": "박신혜",
        "event_date": "2024-08-16 / 10:39:15",
        "post_date": "2024-08-16 / 10:39:15",
        "url": "https://www.instagram.com/p/C-tnFYiyxxE/?img_index=4",
        "kind": "방송",
        "photo": ["NULL"]
    }
}
"""
        },
        {"role": "user", "content": f"{formatted_text}"}
    ]
)

    i= str(completion.choices[0].message)
    #start_index = len("ChatCompletionMessage(content='```json\n")
    #end_index = len("```', role='assistant', function_call=None, tool_calls=None)")
    start = i.find('{')
    end = i.rfind('}')
    json_str = i[start:end]
    # 원하는 부분을 추출
    json_str = json_str.replace('\\n', '').replace('\n', '').replace('\\t', '').replace('\t', '').replace('\\\\', '\\')
    json_str = json_str.replace(' "null"', ' null')
    json_str = re.sub(r'"(\w+)"\s+null', r'"\1": null', json_str)
    json_str = json_str.replace("'", "")
    json_str = json_str.replace("\\", "")
    json_str = json_str.rstrip()
    if json_str.endswith('}}'):
        pass
    elif json_str.endswith('}'):
        json_str += '}'
    else:
        # If it does not end with }, add }}
        json_str += '}}'
    print(json_str)

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

    # 결과 출력
    print(json_data)

    file_path = 'Insta_Output.json'

    with open(file_path, 'w', encoding='utf-8') as file:
        json.dump(json_data, file, ensure_ascii=False, indent=4)


gpt_api("insta_output.txt")
