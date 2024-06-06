import openai
import json
import re

client = openai.OpenAI(api_key = 'API키는 보안상 비공개')


msg = []

f = open("output2.txt", 'r', encoding='UTF8')
lines = f.readlines()
for line in lines:
    line = line.strip()  # 줄 끝의 줄 바꿈 문자를 제거한다.
    msg.append(line)
f.close()
formatted_text = f"제목:{msg}"
print(formatted_text)

completion = client.chat.completions.create(
  model="gpt-4o",
  messages=[
    {"role": "system", "content": "You're summarize assistant.\
    Please answer in Korean. \
    I need to extract all the birthday cafe\
     I only need information about the birthday cafe\
    If there is no information about the cafe, print null\
    Please print out the order in the order of number, name, author, date, place and link.\
    Please print out the output data in the form of a list.\
    Make sure you print everything out\
    Only put numbers in the date\
    Please print out in json format\
    The following is an example of the output"
    "{ '1': { '가수': '슈가', '작성자': '@2024sugadays', '일정': '3/6~3/9, '장소': '카페 키드문: 서울 용산구 한강대로10길 11-68, 1층','게시글_url': 'https://fandomship.com/bbs/link.php?bo_table=bts&wr_id=206&no=1&page=1'}}"},
    {"role": "user", "content":f"{formatted_text}"}
  ]
)

#print(completion.choices[0].message)
i = str(completion.choices[0].message)
start_index = len("ChatCompletionMessage(content='```json\n")
# 원하는 부분을 추출
json_str = i[start_index+1:]
json_str = json_str.replace("```', role='assistant', function_call=None, tool_calls=None)", '')
json_str = json_str.replace('\\n', '').replace('\n', '')
print(json_str)
# JSON 문자열을 파이썬 딕셔너리로 변환
json_data = json.loads(json_str)

# 결과 출력
print(json_data)

filtered_data = {}

for key, value in json_data.items():
    if value['일정'] == 'null' or value['장소'] == 'null' or value['일정'] == '' or value['장소'] == '':
        pass
    else:
        filtered_data[key] = value
print(filtered_data)

file_path = 'Output.txt'

with open(file_path, 'w', encoding='utf-8') as file:
    json.dump(filtered_data, file, ensure_ascii=False, indent=4)

file_path
