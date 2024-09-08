import openai
import json
import re

client = openai.OpenAI(api_key = '')

def x_filter_data(file_path):
    msg = []

    f = open(file_path, 'r', encoding='UTF8')
    lines = f.readlines()
    for line in lines:
        line = line.strip()  # 줄 끝의 줄 바꿈 문자를 제거한다.
        msg.append(line)
    f.close()
    formatted_text = f"제목:{msg}"
    formatted_text = formatted_text.replace('"', '')
    #print(formatted_text)

    completion = client.chat.completions.create(
        model="gpt-4o",
        temperature=0.1,
        response_format={"type":"json_object"},
        messages=[
            {
                "role": "system",
                "content": """
                다음은 생일카페 이벤트에 대한 가수, 업로더, 시작날짜, 끝날짜, 장소, url 정보가 주어질거야 그중에서 장소 정보가 카페이름이라고 볼 수 없는 데이터(단순 지역명(서울, 홍대 등등), 한국을 제외한 지역(상해, 일본 등등), ~~ 생일카페 등)는 아예 뺴버리고 json형식으로 출력해줘 결과가 없다면 {}만 출력해 예를 들어
{
    "31": {
        "celebrity": "해찬",
        "uploader": "@podoal_official",
        "start_date": "2024-06-04",
        "end_date": "2024-06-06",
        "place": "카페식스 (마포구 와우산로29라길 19 2층)",
        "post_url": "https://x.com/podoal_official/status/1797614253752647957"
    },
    "38": {
        "celebrity": "성한빈",
        "uploader": "@loveeeeleeo",
        "start_date": "2024-06-16",
        "end_date": "2024-06-16",
        "place": "홍대",
        "post_url": "https://x.com/loveeeeleeo/status/1797609241777508408"
    },
    "41": {
        "celebrity": "준",
        "uploader": "@jeonghy76329077",
        "start_date": "2024-06-08",
        "end_date": "2024-06-09",
        "place": "홍대",
        "post_url": "https://x.com/jeonghy76329077/status/1797608338475413616"
    }
}

의 데이터가 있을때 38번과 41번은 장소가 카페의 이름이라고 볼수 없으니 지우고 아래의 하나만 출력하는거야
{
    "31": {
        "celebrity": "해찬",
        "uploader": "@podoal_official",
        "start_date": "2024-06-04",
        "end_date": "2024-06-06",
        "place": "카페식스 (마포구 와우산로29라길 19 2층)",
        "post_url": "https://x.com/podoal_official/status/1797614253752647957"
    }}
"""
        },
        {"role": "user", "content": f"{formatted_text}"}
    ]
)

    i = str(completion.choices[0].message)

    filter_data = []

    file_path = 'Output_cafe.json'

    start = i.find('{')
    end = i.rfind('}')

    json_str = i[start:end]
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

    json_dict = json.loads(json_str)

    with open(file_path, 'w', encoding='utf-8') as file:
        json.dump(json_dict, file, ensure_ascii=False, indent=4)


#x_filter_data("output_gpt.json")
