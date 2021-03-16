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
테이블 : 게시글
제목 컬럼 : 제목
SELECT *
FROM 게시글
WHERE 제목 LIKE '%맥북에어%' OR 내용 LIKE '%맥북에어%';
        
        
        
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

실습 where 4

member 테이블에서 회원의 성이 [신]씨인 사람의 mem_id, mem_name을 조회하는 쿼리를 작성하시오

SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '신%';

실습 where 5 

이름에 [이] 자가 들어가는 모든 사람의 mem_id, mem_name을 조회하는 쿼리를 작성하시오

SELECT mem_id, mem_name
FROM member
WHERE mem_name LIKE '%이%';

IS, IS NOT (NULL 비교)
emp 테이블에서 comm 컬럼의 값이 null 인 사람만 조회
SELECT *
FROM emp
WHERE comm IS NULL;

SELECT *
FROM emp
WHERE comm IS NOT NULL;

emp 테이블에서 매니저가 없는 직원만 조회
SELECT *
FROM emp
WHERE mgr is NULL;

BETWEEN AND, IN, LIKE, IS
논리 연산자 : AND, OR, NOT
AND : 두 가지 조건을 동시에 만족시키는지 확인할 때
    조건1 AND 조건2
OR : 두 가지 조건 중 하나라도 만족시키는지 확인할 때
    조건1 OR 조건2
NOT : 부정형 논리연산자, 특정 조건을 부정
    mgr IS NULL : mgr 컬럼의 값이 NULL인 사람만 조회
    mgr IS NOT NULL : mgr 컬럼의 값이 NULL이 아닌 사람만 조회
    

emp 테이블에서 mgr의 사번이 7698이면서
sal 값이 1000보다 큰 직원만 조회


-- 조건의 순서는 결과와 무관하다
SELECT *
FROM emp
WHERE mgr = 7698
  AND sal > 1000;

SELECT *
FROM emp
WHERE mgr = 7698
   OR sal > 1000;

AND 조건이 많아지면 : 조회되는 데이터 건수는 줄어든다
OR 조건이 많아지면 : 조회되는 데이터 건수는 많아진다

NOT : 부정형 연산자, 다른 연산자와 결합하여 쓰인다
    IS NOT, NOT IN, NOT LIKE ...
    

-- 직원의 부서번호과 30번이 아닌 직원들    
SELECT *
FROM emp
WHERE deptno NOT IN (30);

SELECT *
FROM emp
WHERE deptno != 30;

SELECT *
FROM emp
WHERE ename NOT LIKE 'S%';

NOT IN 연산자 사용시 주의점 : 비교값 중에 NULL이 포함되면 데이터가 조회되지 않는다

SELECT *
FROM emp
WHERE mgr IN (7698,7839,NULL);

==>
    mgr = 1698 or 7839 or mgr = null --oracle의 문제 equal 로 치환하게 되어 null 검색이 안 된다.

SELECT *
FROM emp
WHERE mgr NOT IN (7698,7839,NULL);

==>
    mgr != 7698 and mgr != 7839 and mgr != null --oracle의 문제 equal 로 치환하게 되어 null 검색이 안 된다.

mgr = 7698 ==> mgr != 7698
or         ==> and

mgr != NULL -- <- 이 부분이 항상 거짓으로 나오게 된다.

-- 이 부분은 시험에 나옵니다

where 7

emp 테이블에서 job이 salesman 이고 입사일자가 1981년 6월 1일 이후인 직원의 정보를 다음과 같이 조회하세요

SELECT *
FROM emp
WHERE job = 'SALESMAN' AND hiredate >= TO_DATE('19810601','YYYYMMDD');

SELECT *
FROM emp
WHERE job LIKE 'SALESMAN' AND hiredate >= TO_DATE('19810601','YYYYMMDD');


where 8

emp 테이블에서 부서번호가 10번이 아니고 입사일자가 1981년 6월 1일 이후인 직원의 정보를 다음과 같이 조회 하세요 

SELECT *
FROM emp
WHERE deptno != 10 AND hiredate >= TO_DATE('19810601','YYYYMMDD');

where 9

SELECT *
FROM emp
WHERE deptno NOT IN(10) AND hiredate >= TO_DATE('19810601','YYYYMMDD');

where 10
emp 테이블에서 부서번호가 10번이 아니고 입사일자가 1981년 6월 1일 이후인 직원의 정보를 다음과 같이 조회 하세요
(부서는 10, 20, 30만 있다고 가정하고 IN 연산자 사용)

SELECT *
FROM emp
WHERE deptno IN(20, 30) -- deptno NOT IN(10)
AND hiredate >= TO_DATE('19810601','YYYYMMDD');

where 11
emp 테이블에서 job이 SALESMAN이거나 입사일자가 1981년 6월 1일 이후인 직원의 정보를 다음과 같이 조회 하세요

SELECT *
FROM emp
WHERE job IN 'SALESMAN' OR hiredate >= TO_DATE('19810601','YYYYMMDD');

where 12 풀면 좋고, 못 풀어도 괜찮은 문제
emp 테이블에서 job이 SALESMAN이거나 사원번호가 78로 시작하는 직원의 정보를 다음과 같이 조회하세요

SELECT *
FROM emp
WHERE empno LIKE '78%' OR job = 'SALESMAN';

where 13 풀면 좋고, 못 풀어도 괜찮은 문제
emp 테이블에서 job이 SALESMAN이거나 사원번호가 78로 시작하는 직원의 정보를 다음과 같이 조회하세요 (다만 LIKE를 쓰지 않고)

SELECT *
FROM emp
WHERE empno BETWEEN 78 AND 78 OR
      empno BETWEEN 780 AND 789 OR
      empno BETWEEN 7800 AND 7899 OR job = 'SALESMAN';














