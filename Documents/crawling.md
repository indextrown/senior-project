## 파이썬을 사용해서 웹크롤링을 하는 이유  
파이썬 웹크롤링은 Pandas와 TensorFlow(머신러닝) 패키지가 있기 때문에  
한 언어로 데이터 수집, 처리, 분석이 모두 가능하다는 다른 언어보다 강점이 있다.  

## 크롤링에 주로 사용되는 파이썬 라이브러리  
- Requests
- Selenium
- Beautifulsoup4

#### Requests
파이썬에서 동작하는 작고 빠른 브라우저 웹서버로부터 초기 HTML만 받고  
추가 CSS/JavaScript 처리 하지 못한다. 거의 모든 플랫폼에서 구동 가능하다.  


#### Selenium 
브라우저를 원격 컨트롤하는 테스팅 라이브러리 Chrome, Firefox, IE, PhantomJS  
기존 브라우저를 사용하므로, 추가 CSS/JavaScript 처리 지원  
리소스를 많이 사용하고 느린 단점. 사이트에 따라 사용 못하기도 한다.  

#### BeautifulSoup4  
HTML 파서이다.  
지정 HTML로부터 원하는 위치/형식의 문자열을 획득할 수 있다.  
주로 Requests에 의해 많이 사용되지만, Selenium에서도 사용할 수 있다.  

#### 웹페이지 크롤링은 크게 3가지로 구분된다.
- 단순 HTML 크롤링: Requests  
- Ajax 렌더링 크롤링: Requests or Selenium  
- Angular JS, Vue.js, React.JS 류의 자바스크립트 렌더링 크롤링: Selenium  

#### 흔한 크롤링 실패 사례
- "페이지 소스" 메뉴를 통해 본 HTML은 웹서버로부터 받은 최초의 HTML이고, 이 HTML 구조는 자바 스크립트에 의해서 동적으로 로딩 후에 변경될 수 있다.
- "브라우저 개발자도구"를 통해 확인한 구조는 최초의 구조로부터 JavaScript를 통해 변경된 구조이다.
- 따라서, ReactJS라는 JavaScript 코드를 통해 내용이 그려진 웹페이지를 보고 requests로 크롤링하면 변경 전의 최초의 HTML을 크롤링하기 때문에 내가 찾고자 하는 태그의 데이터가 없는 경우가 있다.  
- 이를 해결하는 방법으로 Selenium을 사용한다. 


#### 예시  
웹 브라우저가 보여주는 HTML에는 분명히 존재하는 태그를 가져올 수 없다.   
<img width="952" alt="image" src="https://github.com/indextrown/senior-project/assets/69367698/1ecde472-f9b4-4b71-8271-95380128b8fa">

```python
import requests
from bs4 import BeautifulSoup

#reponse는 객체이다
response = requests.get("https://twitter.com/search?q=생일카페&src=typed_query")
html = response.text
soup = BeautifulSoup(html, 'html.parser')

#soup.select_one('선택자') 선택되는 제일 첫번째 태그 가져옴
#soup.select('선택자')     선택되는 모든 태그를 리스트로 가져옴
li = soup.select_one('._searchListTitleAnchor')  # 원하는 동적 태그라고 가정

print(li.text)
```

#### 원인 
![IMG_DBE09C12B644-1](https://github.com/indextrown/senior-project/assets/69367698/2d2d397b-d8da-4973-86e3-9ae60b996970)

1) 클라이언트가 서버에게 요청(URL)을 보낸다
2) 서버는 요청에 대한 resource를 응답으로 전송한다. Resource에는 HTML, CSS, JavaScript, 그리고 이미지 등이 포함될 수 있다.
3) 웹 브라우저(클라이언트)는 HTML 문서를 DOM 트리 형태로 변환하고 CSS 파일을 CSSOM으로 변환하고 JavaScript를 실행한다.
4) DOM 트리와 CSSOM 트리를 합쳐 렌더 트리를 만든다(파싱). 그리고 레이아웃을 결정(렌더링)한다. 5) 레이아웃은 트리의 각 노드가 브라우저의 어디에, 어떤 크기로 배치될 지를 정하는 것이다.
6) 브라우저 화면에 렌더 트리의 각 노드를 그려준다.  

위의 코드에서는 BeautifulSoup 객체를 사용해 서버에 요청을 보낸뒤 그 resource를 받아와서 JavaScript 코드를 실행하지는 않는다. 그래서 JavaScript에 의해 클라이언트에서 동적으로 추가된 태그에는 접근하지 못한 것이다.  

#### 해결
Selenium과 WebDriver를 사용하면 된다.  
WebDriver가 JavaScript를 실행한 뒤에 Selenium으로 HTML에 접근하면 브라우저에 보여지는 그대로의 컨텐츠에 접근할 수 있게 된다.  
  

#### Selenium 사용이 유리한 경우
- 웹페이지가 JavaScript로 동작한다.
- 내가 요청할 웹페이지가 몇 개 안된다.
- GUI가 있는 컴퓨터에서 수행한다. 
- 컴퓨터 사양이 넉넉하다.

#### Selenium 사용이 불리한 경우
- 요청할 웹페이지가 매우 많은 경우
- 컴퓨터 사양이 넉넉하지 못한 경우
- 자바스크립트 동작이 필요없는 경우

#### Requests를 통해 처리하는 것이 효율이 훨씬 좋다.
추가 이미지/JavaScript/CSS 등의 리소스를 로딩/실행하지 않기 때문이다.  

#### 결론
트위터를 먼저 진행하려고 하였으나 Selenium으로 접근하더라도 스크롤을 내릴 때마다 태그의 위치가 무작위로 바뀌어버림. 그래서 먼저 request로 접근할 수 있는 사이트를 선택하였음.
크롤링 하려는 대상 사이트[팬던십]가 js 동작이 거의 없고, 초기 HTML 내용만으로 파싱이 가능하다고 판단하였기 떄문에 requests와 beautifulsoup4로 크롤링 진행하였다. 
![image](https://github.com/indextrown/senior-project/assets/69367698/ca7e1970-6015-4e1b-9eaf-c32e20870552)



