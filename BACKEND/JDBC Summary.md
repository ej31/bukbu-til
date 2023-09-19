### JDBC, JDBC Template, JPA

## JDBC

JDBC(Java Database Connectivity)는 자바에서 데이터베이스에 접속할 수 있도록 하는 자바 API 이다. JDBC는 데이터베이스에서 자료를 쿼리하거나 업데이트하는 데 사용한다.

![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/baf5297a-348f-4501-8737-811aca03a2dd/732f1d7f-0709-4739-b5ab-940d8981f672/Untitled.png)

## JDBC Driver

JDBC 드라이버들은 자바 프로그램의 요청을 DBMS(DataBase Management System)가 이해할 수 있는 프로토콜로 변환해주는 클라이언트 사이드 어댑터이다.(서버가 아닌 클라이언트 머신에 설치)

- 로딩코드 : Class.forName(”JDBC드라이버 이름”)
  - MySQL : com.mysql.jdbc.Driver
  - Oracle : oracle.jdbc.driver.OracleDriver
- JDBC URL
  - DBMS와의 연결을 위한 식별 값
  - 구성 : jdbc : [DBMS]:[데이터베이스 식별자]
    - MySQL: jdbc:mysql://HOST[:PORT]/DBNAME?param1=value&param2=value…
    - Oracle : jdbc:oracle:thin:@HOST:PORT:SID

## java.sql Package

1. java.sql.Driver
   - DB와 연결하는 Driver Class를 만들 때 반드시 implements 해야 하는 interface로 JDBC 드라이버의 중심이 되는 Interface 입니다.
2. java.sql.Connection
   - 특정 데이터베이스와의 연결정보를 가지는 Interface입니다.
   - DriverManager로부터 Connection 객체를 가져옵니다.
3. java.sql.Statement
   - SQL query문을 DB에 전송하는 방법을 정의한 Interface입니다.
   - Connection을 통해 가져옵니다.
4. java.sql.ResultSet
   - SELECT 구문 실행 결과를 조회할 수 있는 방법을 정의한 Interface 입니다.
5. java.sql.PreparedStatement
   - Statement의 하위 Interface 입니다.
   - SQL문을 미리 컴파일하여 실행 속도를 높입니다.

### JDBC 개발 단계

1. JDBC Driver Loading
   - 데이터베이스 벤더에 맞는 드라이버를 호출합니다.
   - 데이터베이스와의 연결을 위해 드라이버를 로딩합니다.
2. Connection
   - DB와 연결을 위해 URl과 계정정보가 필요합니다.
   - 연결 메소드로는 DriverManager.getConnection(url, id, pw): Connection 입니다.
3. Statement / PreparedStatement
   - SQL 구문을 정의하고 변경될 값을 치환문자를 이용해 쿼리 전송 전에 값을 setting 합니다.
4. executeUpdate() or executeQuery()
   - executeUpdate()는 SQL Query문이 INSERT, DELETE, UPDATE의 경우에 사용합니다. 반환값은 int형입니다.
   - executeQuery()는 SQL Query문이 SELECT인 경우에 사용합니다. 반환값의 타입은 ResultSet입니다.
5. ResultSet(SELECT의 경우)
   - 데이터베이스 조회 결과집합에 대한 표준입니다.
   - next()를 통해 DB의 table 안의 row 한 줄을 불러옵니다.
   - getString(), getInt()를 통해 한 행의 특정 Column값을 가져옵니다.
6. close( Connection, Statement, ResultSet )
   - Connection, Statement, ResultSet에 대해 close를 해줍니다.

```jsx
@Override
    public Member save(Member member) {
        String sql = "insert into member(name) values(?)";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            pstmt = conn.prepareStatement(sql,
                    Statement.RETURN_GENERATED_KEYS);
            pstmt.setString(1, member.getName());
            pstmt.executeUpdate();
            rs = pstmt.getGeneratedKeys();
            if (rs.next()) {
                member.setId(rs.getLong(1));
            } else {
                throw new SQLException("id 조회 실패");
            }
            return member;
        } catch (Exception e) {
            throw new IllegalStateException(e);
        } finally {
            close(conn, pstmt, rs);
        }
    }
```

## JDBC Template

- 스프링의 가장 기본적인 Data Access 템플릿으로 쿼리 기반으로 데이터 베이스에 접근 가능
- 프레임워크 내부적으로 JDBC API를 사용
- DAO 계층에서 JDBC Template API를 사용

![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/baf5297a-348f-4501-8737-811aca03a2dd/3f5ba55b-8654-4459-a30e-b79f728afd92/Untitled.png)

## DataSource

- DataSource가 나타내는 물리적인 데이터와의 Connection을 위한 Factory 이다.
- DriverManager의 대안이다.
- Connection을 얻기 위한 수단 중 선호되는 것이다.
- DataSoruce interface를 구현하는 객체는 JNDI라는 기술을 통해서 등록된다.
- DataSource.class의 설명
  - 커넥션을 맺어줌
  - 커넥션 풀링을 지원
  - 분산 트랜잭션에서 사용될 수 있는 커넥션을 생성
- DataSource를 Bean으로 등록하는 방법
  - yml, properties파일에 DataSource에 관한 정보를 입력.
  - AutoConfiguration 과정에서 DataSource를 Bean으로 등록할 때 해당 정보를 토대로 DataSource의 구현체를 Bean으로 등록함
  - ex
  ```jsx
  public JdbcTemplateMemberRepository(DataSource dataSource){
          jdbcTemplate = new JdbcTemplate(dataSource);
      }
  ```
  ```jsx
  //yml
  spring:
    datasource:
      driver-class-name: org.h2.Driver
      url: jdbc:h2:mem:testdb
      username: sa
      password:

  //properties
  app.datasource.url=jdbc:h2:mem:testdb
  app.datasource.driver-class-name=sa
  app.datasource.username=sa
  ```
  - 자체적으로 Connection Pool을 지원하여 개발자가 따로 관리할 필요가 없음

## SimpleJdbcInsert

간단하게 데이터를 저장하기 위해 만드어진 구현체

1. SImpleJdbcInsert 객체를 생성
2. withTableName 메소드로 어떤 테이블에 데이터를 삽입할지 설정
3. usingGenerateKeyColumns 메소드로 어떤 칼럼을 자동으로 값을 받아올지 설정
4. executeAndReturnKey()메서드는 인자를 데이터베이스에 저장하고 자동 생성된 주 키의 값을 반환

```jsx
@Override
    public Member save(Member member){
        SimpleJdbcInsert jdbcInsert = new SimpleJdbcInsert(jdbcTemplate);
        jdbcInsert.withTableName("member").usingGeneratedKeyColumns("id");

        Map<String, Object> parameters = new HashMap<>();
        parameters.put("name",member.getName());

        Number key = jdbcInsert.executeAndReturnKey(new MapSqlParameterSource(parameters));
        member.setId(key.longValue());

        return member;
```

## RowMapper

JDBC 템플릿에서 각 row를 ResultSet에 맵핑하는 인터페이스

구현시 예외처리에대해 고려하지 않아도 됨.

RowMapper 객체는 일반적으로 상태가 없으므로 재사용이 가능함

```jsx
private RowMapper<Member> memberRowMapper(){
        return (rs, rowNum) -> {
            Member member = new Member();
            member.setId(rs.getLong("id"));
            member.setName(rs.getString("name"));
            return member;
        };
```

ResultSet의 각 행을 맵핑하는 메서드, 데이터베이스의 반환 결과인 ResultSet을 객체형태로 변환해주며 ResultSet의 값을 rowNum 수만큼 반복함

## JDBC Template Query

- JDBC API를 템플릿 형태로 사용하여 간결화하는 것으로, 쿼리는 직접 해줘야함
- List<T> query(String sql, RowMapper<T>)
  - sql 쿼리 문을 통해 데이터를 가지고오고, RowMapper를 통해 ResultSet에 저장 즉 java 객체로 변환함

```jsx
@Override
    public Optional<Member> findById(Long id){
        List<Member> result = jdbcTemplate.query("select * from member where id=?",memberRowMapper(),id);
        return result.stream().findAny();
    }
```

## JPA

- Java Persistence API
- 자바 진영에서 ORM(Object-Relational Mapping) 기술 표준으로 사용되는 인터페이스의 모음
- JPA는 기존의 반복 코드는 물론이고, 기본적인 SQL도 JPA가 직접 만들어서 실행해준다.
- 즉 SQL 문이 아닌 메서드를 통해 DB를 조작할 수 있다. 내부적으로는 SQL 쿼리를 생성하여 조작하나 개발자가 신경쓰지 않아도 된다.
- JPA를 사용하면 , SQL과 데이터 중심의 설계에서 객체 중심의 설계로 패러다임을 전환할 수 있다.
- JPA를 사용하면 개발 생산성을 크게 높일 수 있다.
- 인터페이스이므로 Hibernate, OpenJPA 등이 JPA를 구현한다.

## ORM

- Object-Relational DataBase
- 애플리케이션 Class와 RDB(Relational DataBase)의 테이블을 맵핑한다는뜻

![Untitled](https://prod-files-secure.s3.us-west-2.amazonaws.com/baf5297a-348f-4501-8737-811aca03a2dd/d2c04541-d550-43b9-8d24-ecc8bc9f580e/Untitled.png)

### JPA ex

```jsx
@Override
    public Member save(Member member) {
        em.persist(member);
        return member;
    }

    @Override
    public Optional<Member> findById(Long id) {
        Member member = em.find(Member.class, id);
        return Optional.ofNullable(member);
    }

    @Override
    public Optional<Member> findByName(String name) {
        List<Member> result = em.createQuery("select m from Member m where m.name = :name",Member.class).setParameter("name",name).getResultList();
        return result.stream().findAny();
    }

    @Override
    public List<Member> findAll() {
        return em.createQuery("select m from Member m", Member.class).getResultList();
    }
}
```

- 메서드로 구현하고, Entity Manager를 통해 객체와 데이터베이스를 연결함
- 특정 데이터를 검색하는 경우에는 Entity Manager의 createQuery 메서드를 통해 SQL을 작성해야함
- JPA는 객체 지향 설계이므로, SQL을 추상화한 JPQL이라는 객체 지향 쿼리 언어를 제공
-

## 스프링 데이터 JPA

- 인터페이스를 통한 기본적인 CRUD
- findByName(), findByEmail() 처럼 메서드 이름 만으로 조회 기능 제공
- 페이징 기능 자동 제공(Page, Pageable)

```jsx
public interface SpringDataJpaMemberRepository extends JpaRepository<Member, Long>, MemberRepository {
    @Override // JPQL select m from Member m where m.name=?
    Optional<Member> findByName(String name);
}
```
