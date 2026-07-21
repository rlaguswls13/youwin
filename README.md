# Youwin

음악과 아티스트를 중심으로 커뮤니티와 채팅 기능을 제공하기 위해 개발 중인 Spring Boot JSP 애플리케이션입니다.

## 아키텍처

웹 요청은 아래 한 방향으로만 흐르도록 계층을 나눕니다.

```text
Browser
   │
   ▼
Controller ── Model ──> JSP
   │
   ▼
Service (비즈니스 로직, 트랜잭션)
   │
   ▼
Repository (MyBatis)
   │
   ▼
MySQL ◀── Flyway (스키마 버전 관리)
```

| 계층 | 위치 | 책임 |
| --- | --- | --- |
| Controller | `com.youwin.controller` | 요청 파라미터 수신, Service 호출, JSP 이름과 Model 반환 |
| Service | `com.youwin.service` | 회원가입, 공지 등록 등 비즈니스 규칙과 트랜잭션 처리 |
| Repository | `com.youwin.repository` | MyBatis를 이용한 DB 읽기/쓰기 |
| DTO | `com.youwin.dto` | 계층 사이에서 전달할 데이터 |
| View | `src/main/webapp/WEB-INF/views` | 서버에서 렌더링하는 JSP 화면 |
| Flyway | `src/main/resources/db/migration` | 실행 순서가 보장되는 DB 스키마 변경 이력 |

`api` 패키지에는 현재 콘솔 TCP 통신 실험 코드만 있습니다. 향후 JSON API를 만들 경우 `api.controller`를 별도로 두되 비즈니스 로직은 동일한 `service`를 사용합니다. 비즈니스 로직을 `api` 안에 넣으면 JSP와 API 사이에 로직이 중복될 수 있으므로 Service를 독립 계층으로 유지합니다.

## 프로젝트 구조

```text
.
├─ pom.xml
├─ sql/                              # 설계/조회 참고용 SQL 초안
└─ src/main/
   ├─ java/com/youwin/
   │  ├─ YouwinApplication.java      # 애플리케이션 진입점
   │  ├─ config/                     # Spring 설정
   │  ├─ controller/                 # JSP 화면 컨트롤러
   │  ├─ service/                    # 비즈니스 로직 및 트랜잭션
   │  ├─ repository/                 # MyBatis Repository 인터페이스
   │  ├─ dto/                        # 요청/응답 및 조회 데이터
   │  └─ api/websocket/              # TCP 서버/클라이언트 실험 코드
   ├─ resources/
   │  ├─ application.yml             # 서버, DB, MyBatis 설정
   │  ├─ db/migration/               # Flyway 스키마
   │  ├─ repository/                 # MyBatis XML
   │  └─ static/                     # CSS 및 JavaScript
   └─ webapp/WEB-INF/views/          # JSP
```

## 현재 기능

- `/` 홈 JSP 렌더링
- `/board` 공지사항 목록 조회
- `/board/write` 공지사항 등록
- `/member/join` 회원가입 화면 및 회원가입 처리 골격
- 회원 아이디 중복 확인과 BCrypt 비밀번호 암호화
- 아티스트, 음악, 테마, 채팅 도메인의 DTO 및 Repository 골격
- `localhost:9999`를 사용하는 단일 클라이언트 TCP 채팅 예제

## 기술 스택

- Java 17
- Spring Boot 4.1.0
- Spring MVC, JSP, JSTL
- Spring Security
- MyBatis 4.0.1
- MySQL / MariaDB JDBC 드라이버
- Flyway 12.4.0
- Lombok
- Maven

## 실행 준비

JDK 17, Maven 3.9 이상, MySQL 서버가 필요합니다. Maven Wrapper는 아직 포함되어 있지 않습니다.

기본 연결 정보는 다음과 같습니다.

| 항목 | 기본값 |
| --- | --- |
| 주소 | `localhost:3306` |
| 데이터베이스 | `youwin` |
| 사용자 | `youwin` |
| 비밀번호 | `youwin` |
| 애플리케이션 포트 | `8080` |

MySQL 관리자 계정으로 개발용 DB와 사용자를 준비합니다.

```sql
CREATE DATABASE youwin
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

CREATE USER 'youwin'@'localhost' IDENTIFIED BY 'youwin';
GRANT ALL PRIVILEGES ON youwin.* TO 'youwin'@'localhost';
FLUSH PRIVILEGES;
```

애플리케이션 시작 시 Flyway가 다음 마이그레이션을 순서대로 적용합니다.

- `V1__init_schema.sql`: 회원 테이블
- `V2__create_notice_board.sql`: 공지사항 테이블

`sql/` 폴더는 음악·채팅 도메인 설계 초안이며 자동 실행되지 않습니다. 실제 운영 스키마 변경은 새 Flyway 파일(`V3__...sql` 등)로 추가해야 합니다. 이미 적용된 마이그레이션 파일은 수정하지 않는 것이 원칙입니다.

## 실행

```powershell
mvn spring-boot:run
```

- 홈: <http://localhost:8080/>
- 공지사항: <http://localhost:8080/board>
- 회원가입: <http://localhost:8080/member/join>
- 로그인: <http://localhost:8080/member/login>

포트 변경:

```powershell
$env:SERVER_PORT = "8081"
mvn spring-boot:run
```

## 빌드 및 테스트

```powershell
mvn clean test
mvn clean package
```

결과물은 `target/`에 WAR 파일로 생성됩니다. 현재 테스트 소스는 포함되어 있지 않습니다.

## 개발 규칙

새 기능은 다음 순서로 연결합니다.

1. DB 변경이 필요하면 `db/migration`에 다음 버전의 Flyway SQL을 추가합니다.
2. `repository`에 DB 연산을 정의하고 같은 이름의 MyBatis XML을 작성합니다.
3. `service`에서 Repository를 호출하며 비즈니스 규칙과 트랜잭션을 처리합니다.
4. `controller`는 Service만 호출하고 JSP에 필요한 Model을 전달합니다.
5. JSP는 화면 표시와 사용자 입력에 집중하고 DB에 직접 접근하지 않습니다.

의존성은 생성자 주입을 사용합니다. Controller에서 Repository를 직접 호출하거나 Service에서 JSP 경로를 반환하지 않습니다.

## TCP 채팅 예제

`api/websocket`은 패키지 이름과 달리 WebSocket이 아니라 Java `ServerSocket`/`Socket` 기반의 콘솔 예제입니다.

1. `ServerCumstomSocket.main()` 실행
2. `ClinetSocket.main()` 실행
3. 양쪽 콘솔에서 메시지 입력
4. 클라이언트에서 `bye`를 입력해 종료

## 알려진 제약 사항

- 회원용 JSP(`member/join`, `member/login`, `member/index`)는 컨트롤러 경로만 있고 현재 저장소에 뷰 파일이 없습니다.
- 아티스트·음악·테마·채팅 Repository는 아직 구현 골격입니다.
- FAQ와 1:1 문의는 정적 UI이며 서버 저장 기능이 없습니다.
- 음악·채팅용 `sql/01_create_table.sql`은 Flyway로 이전되지 않았습니다.
- 일부 기존 JSP와 SQL 초안에는 인코딩이 깨진 문구가 남아 있습니다.
- 현재 보안 설정은 개발 편의를 위해 모든 요청을 허용합니다.

## 라이선스

자세한 내용은 [LICENSE](LICENSE)를 참고하세요.
