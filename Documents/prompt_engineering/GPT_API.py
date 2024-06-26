import openai
import json
import re
client = openai.OpenAI(api_key = '=API_key')

def gpt_api(file_path):
    msg = []

    f = open(file_path, 'r', encoding='UTF8')
    lines = f.readlines()
    for line in lines:
        line = line.strip()  # 줄 끝의 줄 바꿈 문자를 제거한다.
        msg.append(line)
    f.close()
    formatted_text = f"제목:{msg}"
    print(formatted_text)

    completion = client.chat.completions.create(
        model="gpt-4o",
        response_format={"type" : "json_object"},
        messages=[
            {
                "role": "system",
                "content": """You're summarize assistant. \
Please answer in Korean. \
I need to extract all the birthday cafe. \
I only need information about the birthday cafe. \
If there is no information about the cafe, print null. \
Please print out the order in the order of number, name, author, date, place and link. \
Please print out the output data in the form of a list. \
Make sure you print everything out. \
Only put numbers in the date. \
Please print out in json format. \
The following is an example of the output:
{
    "1": {
        "가수": "슈가",
        "작성자": "@2024sugadays",
        "일정": "3/6~3/9",
        "장소": "카페 키드문: 서울 용산구 한강대로10길 11-68, 1층",
        "게시글_url": "https://fandomship.com/bbs/link.php?bo_table=bts&wr_id=206&no=1&page=1"
    }
}"""
        },
        {"role": "user", "content": f"{formatted_text}"}
    ]
)

    i = str(completion.choices[0].message)
    #start_index = len("ChatCompletionMessage(content='```json\n")
    #end_index = len("```', role='assistant', function_call=None, tool_calls=None)")
    start = i.find('{')
    end = i.rfind('}') + 1
    json_str = i[start:end]
    # 원하는 부분을 추출
    json_str = json_str.replace('\\n', '').replace('\n', '').replace('\\t', '').replace('\t', '').replace('\\\\', '\\')
    json_str = json_str.replace(' "null"', ' null')
    json_str = re.sub(r'"(\w+)"\s+null', r'"\1": null', json_str)
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

    filtered_data = {}

    # json_data가 리스트인 경우와 딕셔너리인 경우를 나눠서 처리
    if isinstance(json_data, list):
        for item in json_data:
            if isinstance(item, dict):
                for key, value in item.items():
                    if isinstance(value, dict):
                        if value.get('일정') and value.get('장소') and value['일정'] not in ['null', '', '추후공지', '미정', '알수 없음'] and value['장소'] not in ['null', '', '추후공지', '미정', '알수 없음']:
                            filtered_data[key] = value
    elif isinstance(json_data, dict):
        for key, value in json_data.items():
            if isinstance(value, dict):
                if value.get('일정') and value.get('장소') and value['일정'] not in ['null', '', '추후공지', '미정', '알수 없음'] and value['장소'] not in ['null', '', '추후공지', '미정', '알수 없음']:
                    filtered_data[key] = value

    print(filtered_data)

    file_path = 'Output.txt'

    with open(file_path, 'w', encoding='utf-8') as file:
        json.dump(filtered_data, file, ensure_ascii=False, indent=4)


gpt_api("output1.txt")
