## AWS EC2 Ubuntu

### 1. Jar 빌드

- 스프링 프로젝트 새로 생성
  Dependency: Spring Web, Mustache
- MainController.java 및 main.mustache 파일 생성

```java
// controller / MainController.java

package com.example.spring.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class MainController {

    @GetMapping("/")
    public String main() {

        return "main";
    }
}

// templates / main.mustache

<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Main Page</title>
</head>
<body>
    This is Main page :)
</body>
</html>
```

- Gradle > build > bootjar 클릭
- 프로젝트 폴더를 살펴보면 `build` 폴더가 생겼을 것이다. 그 안에 .jar 빌드 압축 파일이 있다. 찾기 쉬운 위치로 옮기자.

### 3. EC2 Ubuntu 설치

- 인스턴스 Ubuntu로 생성
  용량만 10GB 수정, 나머지 디폴트
  pem 키 생성 후 빌드 압축 파일과 같은 위치에 보관
- 보안 그룹 > 인바운드 규칙 > 추가 > 8080포트 모든 ip4 허용

### 4. Git Bash

> 왠만하면 설치

### 5. Remote Access

- 인스턴스 연결 > SSH 클라이언트
- 지침대로 따라하면 됨

1. Git Bash 켜라
2. 다운 받은 암호 파일(.pem)에게 권한 부여 `chmod 400 mainkey.pem`
3. 주소 입력해서 인스턴스에 연결(예: 밑에 복사할 수 있게 되어 있음.)
4. 연결 성공

### 6. 자바 설치

- 연결된 인스턴스에서
- 자바 버전 확인
- 없으면 설치
- `sudo apt updat`
- `sudo apt install openjdk-17-jre-headless`

### 7. JAR 파일 전송

- 내 컴퓨터에서
- 암호에 다시 권한 부여 `chmod 400 mainkey.pem`
- 파일 전송 `scp -i mainkey.pem ~/Desktop/spring-0.0.1-SNAPSHOT.jar ubuntu@ec2-13-124-243-242.ap-northeast-2.compute.amazonaws.com:~/`

### 8. JAR 실행

- `sudo java -jar spring-0.0.1-SNAPSHOT.jar`

<br>

> TIP<br>
>
> - 위 ec2 접속 주소는 13.124.243.242
> - 파일이동: sudo scp -i ubuntukey.pem /mnt/c/Goorm/ubuntu-0.0.1-SNAPSHOT.jar [ubuntu@ec2-3-35-54-159.ap-northeast-2.compute.amazonaws.com](mailto:ubuntu@ec2-3-35-54-159.ap-northeast-2.compute.amazonaws.com):~/ <br>
> - jar 파일 실행: sudo java -jar ubuntu-0.0.1-SNAPSHOT.jar
