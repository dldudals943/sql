2021-03-12 복습
조건에 맞는 데이터 조회 : WHERE 절 - 기술한 조건을 참(TRUE)으로 만족하는 행들만 조회한다(FILTER)

--- row 14개, col : 8개
SELECT *
FROM emp;
WHERE 1 = 1;

SELECT *
FROM emp
WHERE deptno = deptno;

int a = 20;
String a ='20'

SELECT table_name
FROM user_tables;

SELECT 'SELECT * FROM ' || table_name || ';'
FROM user_tables;

TO_DATE('81/03/01','YY/MM/DD')

--입사일자가 1982년 1월 1일 이후인 모든 직원 조회 하는 SELECT 쿼리를 작성하세요.
SELECT *
FROM emp
WHERE hiredate >= TO_DATE('1982/01/01' , 'YYYY/MM/DD');

WHERE 절에서 사용 가능한 연사자
(비교 = != > < ...)
a+b

비교대상 BETWEEN과 비교대상의 허용 시작값 AND 빅대상의 허용 종료값

16번에서 20번 사이의 사원들만 조회
SELECT *
FROM emp
WHERE deptno between 16 AND 20;

emp 테이블에서 급여(sal)가 1000보다 크거나 같고 2000보다 작거나 같은 직원들만 조회
SELECT *
FROM emp
WHERE sal between 1000 AND 2000;

SELECT *
FROM emp
WHERE sal >=1000 AND sal <= 2000;

실습 where 1
emp 테이블에서 입사 일자가 1982년 1월 1일 이후부터 1983년 1월 1일 이전인 사원의 ename, hiredate를 조회하는 쿼리를 작성하시오
SELECT ename, hiredate
FROM emp
WHERE hiredate between TO_DATE('1982/01/01','YYYY/MM/DD') AND TO_DATE('1983/01/01','YYYY/MM/DD');

실습 where 2
SELECT ename, hiredate
FROM emp
WHERE hiredate >= TO_DATE('1982/01/01','YYYY/MM/DD') AND hiredate <= TO_DATE('1983/01/01','YYYY/MM/DD');

BETWEEN AND : 포함(이상, 이하)
              초과, 미만의 개념을 적용하려면 비교연산자를 사용하여야한다.


IN 연산자
대상자 IN (대상자와 비교할 값1, 대상자와 비교할 값2, ... ) <- 제한 1000개 까지

SELECT *
FROM emp
WHERE deptno IN (10, 20);

SELECT *
FROM emp
WHERE deptno = 10 OR deptno = 20;


SELECT *
FROM emp
WHERE 1O IN (10, 20);

10은 10과 같거나 10은 20과 같다
TRUE OR FALSE = TRUE

실습 WHERE3

SELECT userid 아이디, usernm 이름, alias 별명 -- AS를 써도 되고 안 해도 됨. 별칭에 공백이 들어갈경우 ""로 묶어줘야한다.
FROM users
WHERE userid IN ('brown', 'cony', 'sally');


-- AS를 써도 되고 안 해도 됨. 별칭에 공백이 들어갈경우 ""로 묶어줘야한다.
SELECT userid 아이디, usernm 이름, alias 별명
FROM users
WHERE userid = 'brown' OR userid = 'cony' OR userid = 'sally';

LIKE 연산자 : 문자열 매칭 조회
게시글 : 제목 검색, 내용 검색
        제목에 [맥북에어]가 들어가는 게시글만 조회

        1. 얼마 안 된 맥북에어 팔아요
        2. 맥북에어 팔아요
        3. 팝니다 맥북에어
% : 0 개 이상의 문자
_ : 1 개 이상의 문자
c% < - ? 


userid가 c로 시작하는 모든 사용자
SELECT *
FROM users
WHERE userid LIKE 'c%';

userid가 c로 시작하면서 c 이후에 3개의 글자가 오는 사용자
SELECT *
FROM users
WHERE userid LIKE 'c___'; --underbar 가 3개


userid에 l이 들오가는 모든 사용자 조회
SELECT *
FROM users
WHERE userid LIKE '%l%';

