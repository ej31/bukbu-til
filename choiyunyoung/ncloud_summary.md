
### Naver Cloud 실습  
#### 2023-08-18
1. VPC → NACL → subnet → init script → web → storage → image
2. LB : Application LB        
3. AutoScaling
4. CDN
5. 메모
   1. http://101.79.14.34  `LB까지 잘됨, 강사님을 비롯 다들 init스크립트가 잘못 된듯하다. 오전에 미리 해둬서 그런가 문제없이 되는것도 문제인데..`  
#### 2023-08-19
6. 강의 내용 복습
7. ssh 접속 설정 org1, org2
8. ssh : `allow 해야 집에서 가능`  
    ```
    ssh-keygen -t rsa -b 4096 -f auth_keys
    cp auth_keys authorized_keys
    /etc/ssh/sshd_config
    RSAAuthentication yes
    PubkeyAuthentication yes
    AuthorizedKeysFile      .ssh/authorized_keys
    systemctl restart sshd.service
    ```
#### 2023-08-20
9. mysql 설정 및 php 수정  
   1.  ssh 접속 설정 org1, org2
   2.  php에서 접근시 access deny 나와서 acg랑 서브넷 설정 확인
   3.  apache 로그 확인하며 작업 : tail
   4.  db를 지우고 재생성, 자동생성 db-acg에서 inbound 소스 lba1-acg 오타인듯
   5.  mysql 접속 확인 : private url 내부에서만 가능하다
   6.  웹에서 DB Server Configuration시 unable to open file chmod chown
       1.  웹에서 테이블 생성과 dummy데이터 확인
   7.  웹에서 DB Action시 오류
       1.  org1, org2 따로 수정 해야 되네? ftp로 복붙
   8.  전체적으로 php파일의 수정이 필요한듯        
10. nas 마운트후 웹루트 파일 백업 : org1, org2 이걸로 복사하면 될것을 ftp는 성급했다
11. cifs 
    1.  무슨 파일시스템이였는데 삼바 common internet file system
    2.  nas 볼륨생성 cifs
    3.  window server 생성 223.130.129.170
    4.  내컴 원격 -> windows server -> nas 연결
    5.  acl <- win 추가
12. 전체적으로 설정을 다시 한번 복습한셈이 되었다  
      
### Index
---
- ncloud
  - Naver Cloud Platform Certified Associate
  - Professional, Expert
  - On-promise? 보다 빠른 Deploy
1. Compute
2. Network
   1. `Domain Name Server`
   2. `Load Balancer` : 분기?
   3. `AutoScaling`?
3. Storage
   1. `Network Attached Storage`
4. Database
5. AI & App
6. Management
   1. Monitoring
   2. CLA?
* ~~Spring Cloud 조사~~
### Content
---
#### Naver Cloud
- 관리 범위
  - `Infrastructure-as-a-Service`  
    $\Rightarrow$ `가상화까지, Image로 만드는거 까지?`
  - `Platform-` : OS, middleware, 개발환경, 개발도구, appengine  
    $\Rightarrow$ `was도 포함? apache, tomcat`
  - `Software-`  
    $\Rightarrow$ `gmail, docs`
- Deployment
  - public, private, hybrid, multi
1. Compute
   1. bare metal server : os포함 물리  
        $\Rightarrow$ `barebone에서의 의미랑 비슷한건가, centos 단종된거 아닌가`
   2. gpu server : 딥러닝
   3. Server Image / SnapShot
   4. init script : `쉘스크립트`
   5. ACG (`Access Control Group`): Firewall
   6. Storage 추가
   7. Auto scaling
      1. Launch Configuration
         1. image, server type, ACG, Keypair, init Script
      2. Autoscaling Server Group
         1. minSize ≤ desire ≥ maxSize
2. Networking
   - 논리적 망 분리 Virtual Private Cloud, `Load Balancer, Domain Name Server, Content Delivery Network, Network Address Translation`
   1. VPC
      1. public cloud 에서의 private network
      2. subnet  
        $\Rightarrow$ `네트워크 대역을 세분화`
      3. NACL (Network Access Control List)  
        $\Rightarrow$ `방화벽 설정이란 거지`
         1. NACL : subnet 단위, allow, deny
         2. ACG : NIC 단위, allow만 (Compute/Server부분)  
            $\Rightarrow$ `nic는 랜카드인디 network interface card`         
      4. init script (Compute>Server부분)  
        $\Rightarrow$ `apache,mysql등의 설치,설정하는 쉘스크립트`
      5. 필요에따라 Storage 추가
   2. LB : 9만 CPS  
        $\Rightarrow$ `Connection per second`
      1. 알고리즘
         1. Round Robin : 서버에 1개씩
         2. Least Connection
         3. Source IP Hash
      2. Network LB (DSR지원)
         1. in lb, out direct server return
      3. Network Proxy LB (dsr x)
      4. Application LB (hhtp/s)
   3. Global DNS
   4. CDN : 컨텐츠를 Caching  
        $\Rightarrow$ `js 라이브러리도 이걸로 하지, vod라던가`
   5. Storage
      1. Object Storage
         1. 콘솔, RESTful API, SDK로 관리
         2. S3 Compatibility API
         3. Data lifecycle
         4. WORM (write once read many)
      2. Archive Storage
         1. 콘솔, API(swift, s3), cli, sdk
      3. NAS (network attached storage)
         1. 500GB ~ 10TB
         2. NFS, CIFS  
            $\Rightarrow$ `samba? 마운트 가능이라 이거지?`
      4. Backup
         1. 파일, DBMS
         2. Full backup, 증분
      5. Database
         1. MySQL
            1. 23vCPU, 256GB 메모리
            2. 10GB, 10GB 단위로 6TB
            3. 복제 Slave : 용량?
         2. DB를 생성하면서 자동으로 생성 안되는것   
3. Hint Sheet
   1. 네이버클라우드 설립 : 2009/05/01
   2. AWS: E2, S3
#### `Spring Cloud 조사`  
- Cloud Native Application : MSA, 컨테이너화, 자동화, 가상화
- Service Discovery
- Gateway (API Gateway): URI, Hostname, Path, Query parameter
- Distributed Configuration
- Distributed Tracing
- Load Balancing
- Circuit Breaker
- MSA 구축하는 프레임워크란 거지? 지금은 아니니 나중에 알아보자