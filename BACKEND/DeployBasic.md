## AWS 서버 구축

### 1. 가입

[AWS Console - Signup](https://portal.aws.amazon.com/billing/signup#/start/email)

### 2. EC2

크기 조정이 가능한 컴퓨팅 용량을 클라우드에서 제공하는 웹 서비스

[아마존 클라우드 서버 호스팅 | Amazon Web Services](https://aws.amazon.com/ko/ec2/)

### 3. S3, RDS

S3: 확장성, 가용성, 내구성을 가진 데이터 저장 공간 제공

RDS: 관계형 DB 관리 서비스. 관계형 DB 모니터링, 백업

<aside>
💬 **관련 용어**

on-Premise: 서버를 직접 운영하는 방식
Serverless: 서버 작업을 서버 내부가 아닌 클라우드 서비스로 처리
Region: 데이터 센터가 물리적으로 존재하는 곳
CDN(Content Delivery Network): 정적 리소스를 빠르게 제공할 수 있게 전세계의 캐시서버에 복제해주는 서비스

</aside>

아마존에 VM (instance) 클라우드 공간에 Tomcat 설치해서 구동한 해당 서버에 우리의 컴퓨터에서 접속해보자. 서버에 바로 DB를 설치해도 되고 RDS를 사용해도 된다.

### 4. 인스턴스 생성 및 접속

1. Region 변경 (서울)
2. 인스턴스 시작
3. AMI 선택(윈도우, 프리티어 확인)
4. 새 키 페어 생성(RSA, .pem)
5. 인스턴스 시작 → 인스턴스 보기
6. 상태 검사 확인(검사 통과)
7. 연결 (체크 확인)
8. RDP 클라이언트 → 원격 데스크톱 파일 다운로드
   Mac: rdp 앱에서 다운로드
9. RDP 설치 → 암호 필요: RDP 페이지에서 암호 가져오기 → 아까 저장한 키 페어 파일 → 암호 해독 → 복사 해서 RDP 비번으로 입력 → 접속 완료

### 5. 인스턴스에 톰캣 설치

- 다운로드 안되면 인터넷 설정 > Security > Custom level > Download enable

[Archived OpenJDK GA Releases](https://jdk.java.net/archive/)

1. 11.0.2 Windows 64-bit 다운로드 후 설치
2. bin 폴더 경로 복사
3. `control panel` 실행 → env 검색 후 `System` 실행

4. `Advanced > Environment Variables` 클릭
5. `Path` 선택 후 Edit 클릭

6. `New` 클릭해서 아까 복사한 bin 경로 입력하기

7. `Move Up` 눌러서 제일 상단에 위치 시키기(우선 순위 설정)
8. Environment Variables에 `JAVA_HOME` 추가: Java 설치한 폴더(아까 bin 주소에서 /bin 삭제하면 그 주소랑 같음)
9. powershell 가서 자바 설치 확인 `javac -version`

[Apache Tomcat® - Apache Tomcat 9 Software Downloads](https://tomcat.apache.org/download-90.cgi)

1. zip 파일 다운로드 후 설치
2. 설치 폴더에서 `startup.bat` 실행
3. [localhost:8080](http://localhost:8080) 접속해서 확인

### 6. 원격 서버 방화벽 해제

- Control Panel > System and Security > Window Defender Firewall (Firewall 검색해서 들어가기)
- `Advanced settings` 클릭

- 인바운드 규칙에 8080 포트 추가
- `New Rule` 클릭
- `Port` 선택 → TCP, 8080 → Allow Connection → default → name 작성 → 완료

### 7. EC2 방화벽 해제

1. Dashboad(대시보드) > 보안 그룹
2. 이름이 launch-wizard-1 클릭
3. 인바운드 규칙에 `Edit Inbound Rules` 클릭
4. 유형: `모든 TCP` → 완료

### 8. 접속

1. 인스턴스 > 퍼블릭 IPv4 주소
2. 주소 복사해서 8080 포트 접속 확
