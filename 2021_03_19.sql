function group function 실습 grp3

emp 테이블을 이용하여 다음을 구하시오
grp2에서 작성한 쿼리를 활용하여
deptno 대신 부서명이 나올수 있도록 수정하시오


SELECT MAX(sal), MIN(sal), ROUND(AVG(sal),2), SUM(sal), COUNT(sal), COUNT(mgr), COUNT(*),
        CASE
            WHEN deptno = 10 THEN 'ACCOUNTING'
            WHEN deptno = 20 THEN 'RESEARCH'
            WHEN deptno = 30 THEN 'SALES'
            WHEN deptno = 40 THEN 'OPERATIONS'
            ELSE 'DDIT'
        END DNAME
FROM emp
GROUP BY deptno;

SELECT MAX(sal), MIN(sal), ROUND(AVG(sal),2), SUM(sal), COUNT(sal), COUNT(mgr), COUNT(*)

FROM emp
GROUP BY         
CASE
            WHEN deptno = 10 THEN 'ACCOUNTING'
            WHEN deptno = 20 THEN 'RESEARCH'
            WHEN deptno = 30 THEN 'SALES'
            WHEN deptno = 40 THEN 'OPERATIONS'
            ELSE 'DDIT'
        END 
        
        --음 이건 왜 안되지 가능은한데 이렇게 쓰지는 말자



grp4
emp테이블을 이용하여 다음을 구하시오
직원의 입사 년월별로 몇명의 직원이 입사했는지 조회하는 쿼리를 작성하세요.
SELECT TO_CHAR(hiredate,'YYYYMM') hire_yyyymm, COUNT(*) cnt
FROM emp
GROUP BY TO_CHAR(hiredate,'YYYYMM')
ORDER BY TO_CHAR(hiredate,'YYYYMM');

grp5
SELECT TO_CHAR(hiredate,'YYYY') hire_yyyymm, COUNT(*) cnt
FROM emp
GROUP BY TO_CHAR(hiredate,'YYYY')
ORDER BY TO_CHAR(hiredate,'YYYY');

grp6
회사에 존재하는 부서의 개수는 몇개이지 조회하는 쿼리를 작성하시오.
SELECT count(*) cnt
FROM dept;

grp7
직원이 속한 부서의 개수를 조회하는 쿼리
SELECT count(*) cnt
FROM (SELECT count(*)
        FROM emp
        GROUP BY deptno);

데이터 결합
    JOIN
        RDBMS는 중복을 최소화 하는 형태의 데이터베이스
        다른 테이블과 결합하여 데이터를 조회
        데이터를 결합할 수 있는 방법 중 하나
        
데이터 확장(결합)
1. 컬럼에 대한 확장 : JOIN
2. 행에 대한 확장 : 집합연산자(UNION ALL, UNION(합집합), MINUS(차집합), INTERSECT(교집합)) 

JOIN
    중복을 최소화하는 RDBMS 방식으로 설계한 경우
    emp 테이블에는 부서코드만 존재,
    부서정보를 담은 dept 테이블 별도로 생성
    emp 테이블과 dept 테이블의 연결고리(deptno)로 조인하여 실제 부서명을 조회한다

JOIN
1. 표준 SQL => ANSI SQL
2. 비표준 SQL - DBMS를 만드는 회사에서 만든 고유의 SQL 문법

--이게 더 간결하다고 한다.
--데이터베이스를 바꾸면 힘들다

ANSI : SQL
ORACLE : SQL

ANSI - NATURAL JOIN
 - 조인하고자 하는 테이블의 연결컬럼 명(타입도 동일)이 동일할 경우 (emp.deptno, dept.deptno)
 - 연결 컬럼의 값이 동일할 때(=) 컬럼이 확장된다
 
 SELECT *
 FROM emp NATURAL JOIN dept
 ORDER BY deptno ASC;

SELECT ename, dname
FROM emp NATURAL JOIN dept;

SELECT emp.empno, emp.ename, emp.deptno -- 연결하는 컬럼 키에 해당할 경우 .을 이용해서 불가능
FROM emp NATURAL JOIN dept

SELECT emp.empno, emp.ename, deptno -- 연결하는 컬럼에 해당할 경우 그냥 불러옴
FROM emp NATURAL JOIN dept

ORACLE join : 
1. FROM 절에 조인할 테이블을 (,)콤마로 구분하여 나열
2. WHERE : 조인할 테이블의 연결조건을 기술

SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno;
--오라클 join의 유일한 방법

7369 smith, 7902 내 상사 찾기
이럴때 테이블 별칭을 써야한다.

SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e, emp m
WHERE e.mgr = m.empno;

--where 절 조건 충족이 안 돼서 킹이 안나옴 mgr이 없어서

ANSI SQL : JOIN WITH USING
조인 하려고하는 테이블의 컬럼명과 타입이 같은 컬럼이 두 개 이상인 상황에서
두 컬럼을 모두 조인 조건으로 참여시키지 않고, 개발자가 원하는 특정 컬럼으로만 연결을 시키고 싶을 때 사용

SELECT *
FROM emp JOIN dept USING(deptno);

--다만 실습 테이블이 두 개이상 겹치는게 존재하지 않아서 일단 하나만 겹치는걸로 실행
--잘 안 쓰므로 모르면 넘어가도 괜찮음

SELECT *
FROM emp, dept
WHERE emp.deptno=dept.deptno;

JOIN WITH ON : NATURAL JOIN, JOIN WITH USING을 대체할 수 있는 보편적인 문법
조인 컬럼을 조건을 개발자가 임의로 지정


SELECT *
FROM emp JOIN dept ON (emp.deptno = dept.deptno)

--사원 번호, 사원 이름, 해당 사원의 상사 사번, 해당 사원의 상사 이름 : JOIN WITH ON을 이용하여 쿼리 작성


SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e JOIN emp m ON (e.mgr = m.empno);

-- 위와 동일한 조건에서 단 사원의 번호 7369에서 7698 사원만 조회

SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e JOIN emp m ON (e.mgr = m.empno)
WHERE e.empno BETWEEN 7369 AND 7698;

-- java와 달리 먼저 기술했다고 먼저 읽지 않음
-- OPTIMIZER
-- RULE BASE OPTIMIZER (1~15)
-- COST BASE OPTIMIZER 위를 기본으로하여 비용이 더 적게 들법한 방법으로

SELECT e.empno, e.ename, m.empno, m.ename
FROM emp e ,emp m
WHERE (e.mgr = m.empno) AND 
e.empno BETWEEN 7369 AND 7698;


논리적인 조인 형태
--암기는 아니고 자연스럽게 받아들이면 됨

1. SELF JOIN : 조인 테이블이 같은 경우
    - 계층구조
2. NONEQUI-JOIN : 조인 조건이 =(equals)가 아닌 조인

SELECT *
FROM emp, dept
WHERE emp.deptno = dept.deptno;

SELECT *
FROM emp, dept
WHERE emp.deptno != dept.deptno --논이퀄 조인
ORDER BY ename ASC;

-- 이거 시험에 나옵니다 중요****
-- grade, losal, hisal
SELECT *
FROM salgrade;


--salgrade를 이용하여 직원의 급여 등급 구하기
-- ansi , oracle


SELECT empno, ename, sal, grade
FROM emp, salgrade
WHERE emp.sal BETWEEN salgrade.losal AND salgrade.hisal;

SELECT empno, ename, sal, grade
FROM emp JOIN salgrade ON(emp.sal BETWEEN salgrade.losal AND salgrade.hisal)

--엑셀에 데이터 붙여놓고 생각해보기

SELECT *
FROM emp

SELECT *
FROM salgrade

join 0
emp, dept 테이블을 이용하여 다음과 같이 조회되도록 쿼리를 작성하세요
SELECT empno, ename, emp.deptno, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno
ORDER BY deptno ASC;


SELECT empno, ename, deptno, dname -- 내츄럴 에서는 이렇게 써도 되는데 오라클 문법에서는 안 된다 deptno를 .써줘야됨
FROM emp, dept
WHERE emp.deptno = dept.deptno
ORDER BY deptno ASC;

join 0_1
SELECT empno, ename, emp.deptno, dname
FROM emp, dept
WHERE emp.deptno = dept.deptno AND emp.deptno in(10,30)
ORDER BY deptno ASC;