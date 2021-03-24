SELECT 'TEST' || mgr
FROM emp;

SELECT 'TEST' || dummy
FROM dual;

select *
from user_tab_columns;

select * from user_constraints;

select *
from emp;


SELECT LAST_DAY(SYSDATE) + 55
FROM dual;

-- 잠깐 시험 복습

SMITH 가 속한 부서에 있는 직원들을 조회하기
지금까지 배운 내용으로 하려면 쿼리가 두 번 필요하다

1. SMITH가 속한 부서 이름을 알아낸다
2. 1번에서 알아낸 부서번호로 해당 부서에 속하는 직원을 emp 테이블에서 검색한다

1.
SELECT deptno
FROM emp
WHERE ename ='SMITH'

2.
SELECT *
FROM emp
WHERE deptno = 20;


SUBQUERY를 활용해서 풀기
SELECT *
FROM emp 
WHERE deptno = (SELECT deptno, ename
                FROM emp 
                WHERE ename ='SMITH');
--하나만 정해줘야함

SELECT *
FROM emp m
WHERE deptno IN (SELECT deptno
                FROM emp s
                WHERE ename ='SMITH' OR ename = 'ALLEN');

--하지만 이렇게 하면 두개도 됨. 서브쿼리를 쓸 때 문법에 주의하자.

SUBQUERY : 쿼리의 일부로 사용되는 쿼리
1. 사용위치에 따른 분류
    - SELECT : 스칼라(단일의) 서브 쿼리 - 서브쿼리의 실행결과가 하나의 행, 하나의 컬럼을 반환하는 쿼리
    - FROM : 인라인 뷰
    - WHERE : 서브쿼리
                - 메인쿼리의 컬럼을 가져다가 사용할 수 있다
                - 반대로 서브쿼리의 컬럼을 메인쿼리에 가져가서 사용할 수 없다

2. 반환 값에 따른 분류 (행, 컬럼의 개수에 따른 분류)
        - 행-다중행, 단일행, 컬럼 - 단일컬럼, 복수컬럼
    - 다중행 단일 컬럼
    - 다중행 복수 컬럼
    - 단일행 단일 컬럼
    - 단일행 복수 컬럼
    
3. main-sub query의 관계에 따른 분류
    - 상호 연관 서브 쿼리 (correlated subquery) - 메인 쿼리의 컬럼을 서브 쿼리에서 가져다 쓴 경우
        ==> 메인쿼리가 없으면 서브쿼리만 독자적으로 실행 불가능
    - 비상호 연관 서브 쿼리 (non-correlated subquery)- 메인 쿼리의 컬럼을 서브 쿼리에서 가져다 쓰지 않은 경우
        ==> 메인쿼리가 없어도 서브쿼리만 실행가능
        
서브쿼리

--SMITH 사원이 속한 부서의 모든 사원 정보

sub1] 평균 급여보다 높은 급여를 받는 직원의 수를 조회하세요
SELECT count(*)
FROM emp
WHERE sal >= (SELECT AVG(sal)
FROM emp);

sub2] 평균 급여보다 높은 급여를 받는 직원의 정보를 조회하세요
SELECT *
FROM emp
WHERE sal >= (SELECT AVG(sal)
FROM emp);

sub3] smith와 ward 사원이 속한 부서의 모든 사원 정보를 조회하는 쿼리를 다음과 같이 작성하세요
SELECT m.*
FROM emp m
WHERE deptno IN (SELECT deptno
                FROM emp s
                WHERE s.ename ='SMITH' OR ename = 'WARD');
                
MULTI ROW 연산자
    IN : = + OR
    비교연산자 ANY
    비교연산자 ALL
    
SELECT *
FROM emp e
WHERE sal < ANY(
                SELECT s.sal
                FROM emp s
                WHERE s.ename IN('SMITH','WARD')
                )
직원중에 급여값이 SMITH(800)나 WARD(1250)의 급여보다 작은 직원을 조회
        ==> 직원중에 급여값이 1250보다 작은 직원 조회
        
SELECT *
FROM emp e
WHERE sal <     (
                SELECT MAX(s.sal)
                FROM emp s
                WHERE s.ename IN('SMITH','WARD')
                )
                --max 함수를 사용하여 대체가능
ANY 나 ALL 은 잘 사용하지 않는다

SELECT *
FROM emp e
WHERE sal < ALL(
                SELECT s.sal
                FROM emp s
                WHERE s.ename IN('SMITH','WARD')
                )

직원의 급여가 800보다 작고 1250보다 작은 직원 조회
==> 직원의 급여가 800보다 작은 직원 조회

SELECT *
FROM emp e
WHERE sal <     (
                SELECT MIN(s.sal)
                FROM emp s
                WHERE s.ename IN('SMITH','WARD')
                )

함수 MIN을 이용하여 동일한 연산을 수행할 수 있다
일단 결과값은 SMITH 가 최저 sal이라서 안 나온다

subquery 사용시 주의점 NULL 값
IN ()
NOt IN ()

SELECT *
FROM emp
WHERE deptno IN(10,20,NULL)
==> deptono = 10 OR deptono = 20 OR deptono = NULL
==> OR 이기 때문에 null 연산이 FALSE가 되어도 문제가 없을 수 있다.

SELECT *
FROM emp
WHERE deptno NOT IN(10,20,NULL)
==> 문제는  NOT IN의 경우 논리적으로 AND 이기 때문에 != NULL 에서 FALSE가 떠서 아무것도 조회되지 않는다.
==> !(deptono = 10 OR deptono = 20 OR deptono = NULL) <<<< 전부 FALSE

TRUE AND TRUE AND TRUE - > TRUE
TRUE AND TRUE AND FALSE - > FALSE

SELECT *
FROM emp
WHERE empno NOT IN (SELECT mgr
                    FROM emp)
mgr 값에 NULL이 있기 때문에 NOT IN 에서 막혀버린다
NULL이 눈에 보이지 않기 때문에 NOT IN에서 막힌게 보이지 않을 수 있다. 주의!

SELECT *
FROM emp
WHERE empno NOT IN (SELECT NVL(mgr, 9999)
                    FROM emp)
NOT IN 문제는 두번째 시험이 있다면 나올 것입니다.

--------------------------------------
FAIR WISE : 순서쌍

SELECT *
FROM emp
WHERE mgr IN (SELECT mgr
                FROM emp
                WHERE empno IN(7499,7782))
AND deptno IN (SELECT deptno
                 FROM emp
                WHERE empno IN(7499,7782));


--ALLEN(30,7699), CLARK(10,7839)
SELECT mgr, deptno
FROM emp
WHERE empno IN(7499,7782)

SELECT *
FROM emp
WHERE mgr IN(7698,7839)
AND deptno IN (10,30);

mgr, deptno
(7698,10),(7698,30),(7839,10),(7839,30)

요구사항 : ALLEN 또는 CLARK의 소속 부서번호와 같으면서 상사도 같은 직원들을 조회
SELECT *
FROM emp
WHERE (mgr, deptno) IN
                    (SELECT mgr, deptno
                    FROM emp
                    WHERE ename IN ('ALLEN','CLARK'))
FAIRWISE 순서쌍의 문법과 개념 알고가기 나중에 할거임 실무에서 나올 수 있음

DISTINCT -
    1. 설계가 잘못된 경우
    2. 개발자가 sql을 잘 작성하지 못하는 사람인 경우
    3. 요구사항이 이상한 경우
    
스칼라 서브쿼리 : SELECT 절에 사용된 쿼리, 하나의 행, 하나의 컬럼을 반환하는 서브쿼리(스칼라 서브쿼리)

SELECT empno, ename, SYSDATE
FROM emp;

SELECT SYSDATE
FROM dual;

SELECT empno, ename, (SELECT SYSDATE FROM dual)
FROM emp;
--문법적인 사용방법을 가르쳐주기 위한 쿼리
--일단 이건 비상호 연관쿼리임
SELECT empno, ename, (SELECT SYSDATE, SYSDATE FROM dual)
FROM emp;
--하나의 행, 하나의 컬럼을 반환해야하기 때문에 이건 에러가 난다

emp 테이블에는 해당 직원이 속한 부서번호는 관리하지만 해당 부서명 정보는 dept 테이블에만 있다
해당 직원이 속한 부서 이름을 알고 싶으면 dept 테이블과 조인을 해야한다.

SELECT *
FROM emp;

SMITH : SELECT dname FROM dept WHERE deptno=20;
ALLEN : SELECT dname FROM dept WHERE deptno=30;
CLARK : SELECT dname FROM dept WHERE deptno=10;

상호연관 서브쿼리는 항상 메인 쿼리가 먼저 실행된다. 실행 순서가 보장된다.
SELECT empno, ename, deptno,
    (SELECT dname FROM dept WHERE dept.deptno = emp.deptno)
FROM emp;
근데 상호연관 쿼리는 메인 쿼리의 행의 개수만큼 실행을 해야한다
그래서 데이타가 많으면 굉장히 오래 걸릴 수 있다
결론은 좋은 방법은 아니다
비상호연관 서브쿼리는 메인쿼리가 먼저 실행될 수도 있고
                   서브쿼리가 먼저 실행 될 수도 있다
                   ==>성능측면에서 유리한 쪽으로 오라클이 선택
스칼라 서브쿼리는 상호연관쿼리가 자주쓰인다.

인라인 뷰 : SELECT QUERY
    - inline : 해당 위치에 직접 기술함
    - inline view : 해당 위치에 직접 기술한 view
        view : QUERY(O) ==> view table (X)
        table 은 물리적인 데이터를 저장한 건데
        view 는 데이터를 정제한 것
SELECT *
FROM
(SELECT deptno , ROUND(AVG(sal),2) avg_sal FROM emp GROUP BY deptno)

아래 쿼리는 전체 직원의 급여 평균보다 높은 급여를 받는 직원을 조회하는 쿼리
SELECT *
FROM emp
WHERE sal >= (SELECT AVG(sal)
              FROM emp);


직원이 속한 부서의 급여 평균보다 높은 급여를 받는 직원을 조회 + 그 직원이 속한 부서의 평균 급여도 출력
SELECT empno, ename, e.sal, e.deptno, (SELECT AVG(a.sal) avg_sal
FROM emp a
WHERE a.deptno = e.deptno)
FROM emp e
WHERE e.sal > (SELECT AVG(a.sal) avg_sal
FROM emp a
WHERE a.deptno = e.deptno)
상호연관으로 할 수밖에 없다.

20번 부서의 급여 평균 2175
SELECT AVG(sal)
FROM emp
WHERE deptno = 20

10번 부서의 급여 평균 2916
SELECT AVG(sal)
FROM emp
WHERE deptno = 10

SELECT AVG(sal)
FROM emp
GROUP BY deptno

서브쿼리
상호 연관 서브 쿼리와 비상호 연관 서브 쿼리 서로간에 우위는 없다
굳이 우위를 두자면 가능하면 비상호 연관 서브 쿼리가 좋긴하다.

그러나 억지로 쓰려고하기보다는 요구사항에 맞추는게 낫다

--
deptno, dname, loc
INSERT INTO dept VALUES (99, 'ddit', 'daejeon'); 
COMMIT;
--행이 추가되었다


SELECT *
FROM dept;

10, 20, 30, 40, 99
10, 20, 30

SELECT *
FROM emp;

sub4
dept 테이블에는 신규 등록된 99번 부서에 속한 사람은 없음
직원이 속하지 않은 부서를 조회하는 쿼리를 작성해보세요

SELECT *
FROM dept
WHERE deptno NOT IN(SELECT deptno
                    FROM emp
                    GROUP BY deptno);

SELECT mgr
FROM emp
GROUP BY mgr
ORDER BY mgr;

** 서브 쿼리에서 불러온 테이블을 메인 쿼리에서 조회할 수 없다 **

sub5]
cycle, product 테이블을 이용하여 cid=1인 고객이 애음하지 않는 제품을 조회하는 쿼리를 작성하세요
SELECT *
FROM cycle

SELECT *
FROM product
WHERE pid NOT IN (SELECT pid
                    FROM cycle
                    WHERE cid = 1)
