#GPT API 프롬프트 엔지니어링 사이트에서 만든 함수로 전체 코드가 아님
#출력 값을 Json 형식으로 출력하기 위해 형식을 지정해주는 함수

{
  "name": "summary_bot",
  "description": "요약처리기",
  "parameters": {
    "type": "object",
    "properties": {
      "순번": {
        "type": "string"
      },
      "가수": {
        "type": "string"
      },
      "작성자": {
        "type": "string"
      },
      "날짜": {
        "type": "string"
      },
      "장소": {
        "type": "string"
      }
    },
    "required": [
      "순번",
      "가수",
      "작성자",
      "날짜",
      "장소"
    ]
  }
}
