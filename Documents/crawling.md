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
크롤링 하려는 대상 사이트[팬던십]가 js 동작이 거의 없고, 초기 HTML 내용만으로 파싱이 가능하다고 판단하였기 떄문에 requests와 beautifulsoup4로 크롤링 진행하였다. 
![image](https://github.com/indextrown/senior-project/assets/69367698/ca7e1970-6015-4e1b-9eaf-c32e20870552)



