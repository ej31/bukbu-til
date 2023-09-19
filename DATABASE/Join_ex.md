### SQL  Join 실습 (230915)
<br>


``` SQL
create table usertbl (
	user_id int primary key,
    user_name varchar(20),
    user_phone int,
    dog_name varchar(20)
);
```

``` SQL
create table dog(
	user_id int primary key,
    dog_name varchar(20),
    dog_age int,
    dog_breed varchar(50)
);
```
<br>

dummy data for user

``` SQL
insert into usertbl value(1, '박지은', 1234, '오월');
insert into usertbl value(2, '최진우', 5678, '초코');
insert into usertbl value(3, '김대현', 9999, '루비');
insert into usertbl value(5, '제프', 9552, null);
```
<br>

dummy data for dog
``` SQL
insert into dog value(1, ' 오월', 3, '토이푸들');
insert into dog value(2, '초코', 1, '리트리버');
insert into dog value(3, '루비', 2, '진돗개');
insert into dog value(4, '쿠키', 8, '치와와');
```
<br><br>

- Inner join
    - Inner join 실습
    ```SQL
    select * from usertbl
    inner join dog 
    on usertbl.user_id = dog.user_id;
    ```

    - 유저이름, 강아지이름, 강아지종류, 강아지나이를 출력하세요.
    ``` SQL
    select usertbl.user_name, dog.dog_name, dog.dog_breed, dog.dog_age
    from usertbl
    inner join dog 
    on usertbl.user_id = dog.user_id;
    ```
<br><br>

- left outer join
    - left outer join 실습
    ``` SQL
    select * from usertbl
    left outer join dog
    on usertbl.user_id = dog.user_id;
    ```
    - 유저아이디, 유저이름, 강아지이름, 강아지종류를 출력하세요. (유저는 모두 나오게 출력, 유저이름순으로 정렬)
    ```SQL
    select u.user_id, u.user_name, d.dog_name, d.dog_breed
    from usertbl u
    left outer join dog d
    on u.user_id = d.user_id
    order by u.user_name
    ```
<br><br>

- right outer join
    - rigth outer join
    ```SQL
    
    ```
    - 유저 아이디, 유저 이름, 강아지이름, 강아지 종류를 출력하는데 dog테이블은 모두 나오게 출력하세요. (유저 이름순으로 정렬)
    ```SQL
    select u.user_id, u.user_name, d.dog_name, d.dog_breed
    from usertbl u
    right outer join dog d
    on u.user_id = d.user_id
    order by u.user_name;
    ```
<br><br>

- full outer join
    - full outer join은 MySQL에서 지원하지 않는다.
    - 따라서 left, rigth join을 해서 union을 해줘야한다.
    ```SQL
    select * from usertbl left outer join dog on usertbl.user_id = dog.user_id
    union
    select * from usertbl right outer join dog on usertbl.user_id = dog.user_id;
    ```

<br><br>

- cross join
    ```SQL
    select * from usertbl cross join dog;
    ```
    - cross join의 경우 모든 경우의 수 즉 usertbl테이블 row개수 x dog테이블 row개수 만큼의 row를 출력하게 된다.

<br><br>

- self join은 한 테이블 내의 row끼리 어떤 계산을 할 때 유용하게 쓰인다.