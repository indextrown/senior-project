### GPT API 사용하는 이유

크롤링을 통해 얻은 데이터에서 필요없는 부분을 제거하고 가공하여 사용하기 위해서는 자연어 처리를 하여야 하지만 자연어 처리 모델을 직접 개발하기에는 어려움이 존재   
이를 해결 하기 위해서 OpenAi에서 제공하는 GPT API를 이용하여 데이터를 가공하기 위해 사용

### 필요한 기술

#### prompt engineering

● LLM과 상호작용하도록 프롬프트를 개발하고 최적화 하는 작업

### 진행상황   

● 우선 순위

#### 1. OpenAI 사이트에서 프롬프트 엔지니어링 진행
  - 팬덤십 사이트의 결과를 이용하여 정제 진행 및 결과 출력
  - 트위터 크롤링 결과를 이용하여 정제 진행 및 결과 출력
  - DB코드에 바로 이용 할 수 있도록 출력 형식 맞추는 작업
#### 2. 파이썬 코드로 작성 진행    

※ 이미지 처리에 대해서는 텍스트 처리가 우선적으로 진행되고 난 이후 GPT API를 사용하여 이미지 처리 시도

### 발생한 이슈

1. 5월 9일 이후 GPT API에서 입력이 10줄 이상 입력 되지 않도록 업데이트가 된것으로 보임
![image](https://github.com/indextrown/senior-project/assets/125960190/b6b8411a-3c56-453f-aac5-e91f31659a93)

　이를 해결 하기 위해 크롤링 과정에서 결과에 개행 문자를 입력하지 않고 모두 한줄로 출력되도록 크롤링 부분 수정    
  　파이썬 코드로 작성하여 돌리면 해결된다는 정보도 있기에 코드로 옮기는 작업 진행 예정

2. 팬덤십 사이트의 결과는 잘 정리 해주는 모습을 보이나 트위터 데이터를 이용할 경우 아직 제대로 출력하지 못하는 문제가 발생

![image](https://github.com/indextrown/senior-project/assets/125960190/d91ef32d-2439-482b-992e-a089434c0532)    
　　팬덥십 데이터와 트위터 데이터를 섞어서 출력해본 결과

　![image](https://github.com/indextrown/senior-project/assets/125960190/f4672022-70af-4075-8a8d-06c837bb34a7)    
　　트위터 데이터만을 이용하여 출력해본 결과

3. 없는 데이터에 한해서 null값을 넣으라고 엔지니어링 하였지만 null, 공백, 추후 공지, 미상 다양하게 답변을 냄
   ![image](https://github.com/indextrown/senior-project/assets/125960190/3de5d78f-01bb-4203-86d0-8782704fa1a1)   
   null뿐만 아니라 ''으로 값이 나오는경우


5. 코드를 작성 하였때 gpt 답변에 따라 코드가 정상적으로 실행될 떄도 있고 에러가 나는 경우가 발생
    ![image](https://github.com/indextrown/senior-project/assets/125960190/7d68aa11-88db-4bc8-8912-e87de5e15fb3)   
    코드가 에러가 난 모습
    ![image](https://github.com/indextrown/senior-project/assets/125960190/700be61b-d263-4d54-a957-75429f913be6)
    같은코드가 실행되는 모습

### 이슈 해결

1. GPT 4o 공개 이후 사이트에서도 10줄 이상이 다시 잘 입력되는 모습을 보여줌

2. GPT 4o 이후 여전히 필요없는 데이터도 많이 나오나 정제되는 데이터가 나오기 시작 한 것을 확인
   ![트위터에서 데이터 하나 성공](https://github.com/indextrown/senior-project/assets/125960190/b7af2ef9-7655-4656-ae1d-b9294f9793d8)
   
   X 데이터에서 추출된 결과

   이후 쓰레기 데이터를 정체 하기 위해 파이썬 코드를 이용 하여 데이터 정제를 시도
   ![image](https://github.com/indextrown/senior-project/assets/125960190/72bff333-d374-44ba-80d0-36802b0b1dea)

