Lee 계정에 있는 prod 테이블의 모든 컬럼을 조회하는 SELECT 쿼리(SQL) 작성

SELECT *
FROM prod;

Lee 계정에 있는 prod 테이블의 prod_id, prod_name 컬럼을 조회하는 SELECT 쿼리(SQL) 작성

SELECT prod_id, prod_name
FROM prod;



[ SELECT1 ]

lprod 테이블에서 모든 데이터를 조회하는 쿼리를 작성하세요
    
SELECT *
FROM lprod
    
buyer 테이블에서 buyer_id, buyer_name 컬럼만 조회하는 쿼리를 작성하세요
    
SELECT buyer_id, buyer_name
FROM buyer

cart 테이블에서 모든 데이터를 조회하는 쿼리를 작성하세요
    
SELECT *
FROM cart

member 테이블에서 mem_id, mem_pass, mem_name 컬러만 조회하는 쿼리를 작성하세요
    
SELECT mem_id, mem_pass, mem_name
FROM member
    
컬럼 정보를 보는 방법
1. SELECT * ==> 컬럼의 이름을 알 수 있다
2. SQL DEVELOPER의 테이블 객체를 클릭하여 정보확인
3. DESC 테이블명; //DESCRIBE 설명하다

DESC emp
    
데이터 타입 ( 문자, 숫자, 날짜)

empno : number ;
empno + 10 => expression

ALIAS : 컬럼의 이름을 변경
    컬럼 : EXPRESSION ( as) 컬럼명
    
    NULL 널을 포함한 연산은 결과가 항상  0
    => NULL 값을 다른 값으로 치환해주는 함수
    
[ SELECT2 ]

    prod 테이블에서 prod_id, prod_name 두 컬럼을 조회하는 쿼리를 작성하시오
    (단 pord_id -> id, prod_name -> name 으로 컬럼 별칭을 지정)
    
SELECT prod_id AS id, prod_name AS name
FROM prod
    
    
    lprod 테이블에서 lprod_gu, lprod_nm 두 컬럼을 조회하는 쿼리를 작성하시오
    (ks lprod_gu -> gu, lprod_nm -> nm 으로 컬럼 별칭을 지정)
    
SELECT lprod_gu AS gu, lprod_nm AS nm
FROM lprod
    
    buyer 테이블에서 buyer_id, buyer_name 두 컬럼을 조회하는 쿼리를 작성하시오.
    (단 buyer_id -> 바이어아이디, buyer_name -> 이름으로 컬럼 별칭을 지정)

SELECT buyer_id AS 바이어아이디, buyer_name AS 이름
FROM buyer

AS 를 써도 되고 안 써도 됨
그리고 한글로 컬럼명을 할 수도 있지만 잘 안 씀

literal : 값 자체
literal 표기법 : 언어마다 다르다

SELECT empno, ename || ', World',
CONCAT(ename, ', World') -- 두개의 문자열을 입력받아 결합하고 결합된 문자열을 반환 해준다
FROM emp;

SELECT '아이디 : ' || userid
FROM USERS


SELECT  CONCAT('아이디 : ', userid)
FROM USERS

Literal Character, Conctenation(문자열 결합 실습 sel_con1)

SELECT 'SELECT * FROM ' || table_name || ';' QUERY,
CONCAT(CONCAT('SELECT * FROM ', table_name), ';') QUERY
FROM user_tables

SELECT * FROM BONUS;
SELECT * FROM EMP;
SELECT * FROM DEPT;
SELECT * FROM SALGRADE;
SELECT * FROM LPROD;
SELECT * FROM BUYER;
SELECT * FROM PROD;
SELECT * FROM BUYPROD;
SELECT * FROM MEMBER;
SELECT * FROM CART;
SELECT * FROM RANGER;
SELECT * FROM RANGERDEPT;
SELECT * FROM USERS;

조건에 맞는 데이터 조회하기
WHERE 절 조건연산자
연산자 의미
= 같은 값
!=, <> 다른 값
> 클때
>= 크거나 같음
< 작을때
<= 작거나 같음


--부서번호가 10인 직원들만
SELECT *
FROM emp
WHERE deptno = 10 ;

--uwers 테이블에서 userid 컬럼의 값이 brown인 사용자만 조회
--SQL 키워드는 대소문자를 가리지 않지만 데이터 값은 대소문자를 가린다
SELECT *
FROM users
WHERE userid = 'brown' ;

--emp 테이블에서 부서번호가 20번보다 큰부서에 속한 직원 조회
SELECT *
FROM emp
WHERE deptno > 20;

--emp 테이블에서 부서번호가 20번 부서에 속하지 않은 모든 직원 조회
SELECT *
FROM emp
WHERE deptno != 20;

WHERE : 기술한 조건을 참(TRUE)로 만족하는 행들만 조회한다(FILTER)

SELECT *
FROM emp
WHERE 20 = 20;

SELECT *
FROM emp
WHERE 0 = 20;

SELECT empno, ename, hiredate
FROM emp
WHERE hiredate > '81/03/01'

yyyy/mm/dd korea
mm/dd/yy USA

국가에 따라 날짜 표기가 달라서 저렇게 하면 좀 위험할 수 있음
문자열이 아니라 날짜로 하는게 좋다

TO_DATE('날짜 문자열', 날짜 문자열의 포맷팅)
TO_DATE('1981/03/01', 'YYYY/MM/DD')

SELECT empno, ename, hiredate
FROM emp
WHERE hiredate > TO_DATE('1981/03/01', 'YYYY/MM/DD');

--이렇게 날짜로 하는게 안전하다

4자리 표기법으로 RRRR,YYYY 로 하는게 확실하고 안전하다
2자리는 좀 그렇다




