![image](https://github.com/indextrown/senior-project/assets/69367698/02a52316-37f7-40b6-be0b-fc439b421f0a)
### [긴급]AWS EC2 CPU 부하 문제 발생
AWS EC2 서버에서 X 크롤링을 매 30분마다 자동으로 실행 중 새벽에 CPU 부하가 발생하였음.  
~~크롬 드라이버가 정상 종료되지 않고 코드가 계속 실행되어 문제가 발생한 것으로 추정됨.~~  
-> 크롬 드라이버 문제가 아닌 aws ec2 Memory 부족 문제이다.  
  

t2.micro의 램은 1GB인데 실제로 사용 가능한 램은 280MB였어서 Memory 사용률 과다로 CPU 사용률이 100%가 된 것으로 판단되었다.   
  
이를 해결하기 위해 스왑영역을 생성해서 해결하였다.  

<img width="567" alt="image" src="https://github.com/indextrown/senior-project/assets/69367698/ed374e13-71a9-4000-9fb1-480e972a1ae5">

```bash
free
```    

### 스왑 파일은 2GB(128MB x 16)
```bash
sudo dd if=/dev/zero of=/swapfile bs=128M count=16
```    
### 스왑 파일의 읽기 및 쓰기 권한을 업데이트
```bash
sudo chmod 600 /swapfile
```  
### Linux 스왑 영역을 설정
```bash
sudo mkswap /swapfile
```  
### 스왑 공간에 스왑 파일을 추가하여 스왑 파일을 즉시 사용할 수 있도록 함
```bash
sudo swapon /swapfile
```
### 절차가 성공적으로 완료되었는지 확인
```bash
sudo swapon -s  
```    
### 부팅 시 /etc/fstab 파일을 편집하여 스왑 파일을 시작
```bash
sudo vi /etc/fstab
```   
### 파일 끝에 줄을 추가하고 파일을 저장한 다음 종료
```bash
/swapfile swap swap defaults 0 0
```   
<img width="571" alt="image" src="https://github.com/indextrown/senior-project/assets/69367698/3db67fc1-011b-4d14-b1b5-6570ac485400">

```bash
free
```  

#### [2024-06-30] aws 서버 시간 동기화

### 설정된 대륙 확인
```bash
vim /etc/sysconfig/clock
```

### 대륙 선택
```bash
tzselect
```

### 환경변수 저장
```bash
vim /etc/profile
TZ='Asia/Seoul'
export TZ 추가
```



 

<!-- ### [해결방안]  
크롤링 코드는 사이트 변경으로 주기적으로 코드 오류가 생길 수 있음.   
이를 대비하기 위해 서버에서 발생하는 오류를 실시간으로 감지하고, 문제 발생 시 즉각적으로 서버 관리자에게 경고 알림을 전송하는 시스템을 구축할 필요함.   


### [조치사항] 
1. CPU 사용량 30% 이상 시 경고 이메일 발송:  
  
- 서버의 CPU 사용량이 30% 이상일 때 경고를 이메일/slack으로 자동으로 발송.    
- 이를 통해 서버 관리자가 시스템의 부하를 주시하고 추가 조치를 취할 수 있음.    
   

2. CPU 사용량 50% 이상 시 서버 또는 프로세스 자동 재부팅 로직 실행(개발중):    

- 서버의 CPU 사용량이 50% 이상일 때 자동으로 서버를 재부팅 실시.    
- 이를 통해 서버의 안정성을 유지하고 과부하로 인한 장애를 최소화할 수 있음.     -->
