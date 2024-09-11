# 생일 카페 중계 플랫폼 iOS 앱 프로젝트

## 프로젝트 소개
이 프로젝트는 SwiftUI를 사용하여 프론트엔드를 구성하고, Swift를 사용하여 백엔드를 구현하여 앱 애플리케이션을 개발하는 것을 목표로 한다.
X.com 에서 크롤링을 통해 정보를 가져오고, gpt 정제 후 mySQL에 데이터 입력 후, api를 사용하여 mySQL에 저장된 데이터를 띄우도록 한다.

## 사용된 기술 및 도구
- **프론트엔드**
    - SwiftUI
- **백엔드**
    - Swift
## 지원될 iOS 디바이스
- **기본 계획**
    - iPhone XS Max
    - iPhone 11 Pro
    - iPhone 15 Pro Max
    - iPhone 16 Pro
- **최종 계획**
    - iOS 18을 지원하는 모든 디바이스

## 업데이트 로그

### 2024/09/11
.xcodeproj
- AppIcon파일 사용하도록 수정

AppIcon.jpg
- 앱 매인 아이콘 이미지

ContentView.swift
- 앱 메인화면을 CafeView로 수정
- SF Symbols 크기 조정 수정
- 하단에 뷰 선택지를 아티스트, 스케줄, 생일카페, 게시판 -> 생일카페, 스케줄, 게시판, 설정 으로 변경
- 기존 우측 상단에 존재하던 NavigationLink(destination: ProfileView()) 를 제거

ArtistView.swift
- 더 이상 사용되지 않을 예정

CafeView.Swift
- 행사 날짜 범위를 yyyy-MM-dd ~ yyyy-MM-dd 형태로 변경 후 .frame(height: ) 조절

ScheduleView.Swift
- View에서 작성자 id 제거

ScheduleViewDetail.Swift
- "해당 데이터는 개발자들이 무단으로 수집했습니다" 텍스트 제거

LoginView.swift
- 기존 ArtistView에서 구현 예정이었던 가로 형태로 무한히 아티스트들의 목록을 보여주는 기능 추가 및 주변 요소 위치 수정