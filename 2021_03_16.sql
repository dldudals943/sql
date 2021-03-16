--시험에 나오는거 트랜잭션 NOT IN
-- sql 연산자 우선순위
-- 산술연산자
-- 

연산자 우선순위 (AND가 OR보다 우선순위가 높다)
==> 헷갈리면 ()를 사용하여 우선순위를 조정하자

SELECT *
FROM emp
WHERE ename = 'SMITH' OR ename = 'ALLEN' AND job = 'SALESMAN'

==> 직원의 이름이 ALLEN 이면서 job이 SALESMAN 이거나
    직원의 이름이 SMITH인 직원 정보를 조회

SELECT *
FROM emp
WHERE (ename = 'SMITH' OR ename = 'ALLEN') AND job = 'SALESMAN'
        
==> 직원의 이름이 ALLEN 이거나 SMITH 이면서
    job이 SALESMAN인 직원을 조회

where 14
emp 테이블에서
1. job이 SALESMAN이거나
2. 사원번호가 78로 시작하면서 입사일자가 1981년 6월 1일 이후인
직원의 정보를 다음과 같이 조회하세요

SELECT *
FROM emp
WHERE empno LIKE '78%' AND hiredate >= TO_DATE('19810601','YYYYMMDD') OR job = 'SALESMAN';

테이블 객체는 데이터를 저장 조회시 순서를 보장하지 않음
보편적으로 입력된 순서대로 조회됨
데이터가 항상 동일한 순서로 조회되는 것을 보장하지 않음
데이터가 삭제되고, 다른 데이터가 들어올 수도 있음

8kb 단위로 블럭으로 저장

-- https://okky.kr/ -- 개발자 사이트

데이터 정렬 (ORDER BY)

    ORDER BY
        ASC : 오름차순 (기본)
        DESC : 내림차순 
        
데이터 정렬이 필요한 이유?

1. table 객체는 순서를 보장하지 않는다
    ==> 오늘 실행한 쿼리를 내일 실행할 경우 동일한 순서로 조회가 되지 않을 수도 있다
    입력에는 강점이 있고 출력에는 단점이 있다
2. 현실세계에서는 정렬된 데이터가 필요한 경우가 있다
    ==> 게시판의 게시글은 보편적으로 가장 최신글이 처음에 나오고, 가장 오래된 글이 맨 밑에 있다


SQL 에서 정렬 : ORDER BY ==> SELECT -> FROM -> [WHERE] -> ORDER BY
정렬 방법 : ORDER BY 컬럼명 : 컬럼인덱스(순서) | 별칭 [정렬순서]
정렬 순서 : 기본 ASC(오름 차순) DESC(내림차순)

SELECT *
FROM emp
ORDER BY ename DESC;
A - > B -> C -> [D] -> ... -> [Z]
1 -> 2 -> 3 -> ... -> 100 : 오름차순 (ASC => DEFAULT)
또는
100 -> 99 -> ... -> 1 : 내림차순 (DESC)

SELECT *
FROM emp
ORDER BY job ASC;

SELECT *
FROM emp
ORDER BY job DESC, sal ASC, ename;


정렬 : 컬럼명이 아니라 SELECT 절의 컬럼 순서(index)
SELECT empno, job, mgr AS M
FROM emp
ORDER BY 2; -- 2번째 컬럼을 기준으로 정렬 ( SELECT 절에서 지정한 컬럼이 될 수도 있고 지정하지 않으면 데이터의 두 번째 컬럼으로 정렬하는데 추천하지 않는 방법이다)

SELECT empno, job, mgr AS M
FROM emp
ORDER BY M; -- 별칭을 지정하면 별칭으로도 지정하는게 가능하다

데이터 정렬 (ORDER BY 실습 orderby1)

dept 테이블의 모든 정보를 부서이름으로 오름차순 정렬로 조회되도록 쿼리를 작성하세요

dept 테이블의 모든 정보를 부서위치로 내림차순 정렬로 조회되도록 쿼리를 작성하세요

컬럼명을 명시하지 않았습니다. 올바른 컬럼을 찾아보세요

SELECT *
FROM dept
ORDER BY dname;

SELECT *
FROM dept
ORDER BY loc DESC;

orderby2

emp 테이블에서 상여(comm)정보가 있는 사람들만 조회하고,
상여(comm)를 많이 받는 사람이 먼저 조회되도록 정렬하고,
상여가 같을 경우 사번으로 내림차순 정렬하세요.
상여가 0인 사람은 상여가 없는 것으로 간주

SELECT *
FROM emp
WHERE comm IS NOT NULL AND comm != 0
ORDER BY comm DESC, empno DESC

SELECT *
FROM emp
WHERE comm > 0 -- 정보가 null인 경우는 대소비교에서 무조건 false기 때문에 같은 결과가 나온다.
ORDER BY comm DESC, empno DESC

orderby3

emp 테이블에서 관리자가 있는 사람들만 조회하고, 직군(job)순으로 오름차순 정렬하고,
직군이 같을 경우 사번이 큰 사원이 먼저 조회되도록 쿼리를 작성하세요

SELECT *
FROM emp
WHERE mgr IS NOT NULL
ORDER BY job, empno DESC;

emp 테이블에서 10번 부서(deptno)혹은 30번 부서에 속하는 사람중 급여(sal)가 1500이 넘는
사람들만 조회하고 이름으로 내림차순 정렬되도록 쿼리를 작성하세요

SELECT *
FROM emp
WHERE deptno IN(10, 30) AND sal > 1500
ORDER BY ename DESC;

페이징 처리 : 전체 데이터를 조회하는게 아니라 페이지 사이즈가 정해졌을 때 원하는 페이지의 데이터만 가져오는 방법
1. (400건을 다 조회하고 필요한 20것만 사용하는 방법) --> 전체조회 (400)
2. 400건의 데이터 중 원하는 페이지의 20건만 조회 --> 페이징처리 (20)
페이징 처리 (게시글) ==> 정렬의 기준이 뭔데? (일반적으로는 게시글의 작성일시 역순)
페이징 처리시 고려할 변수 : 페이지 번호, 페이지 사이즈

ROWNUM : 행번호를 부여하는 특수 키워드(오라클에서만 제공)
    *제약사항
     ROWNUM은 WHERE 절에서도 사용 가능하다
     단 ROWNUM의 사용을 1부터 사용하는 경우에만 사용 가능
     WHERE ROWNUM BETWEEN 1 AND 5 ==> O
     WHERE ROWNUM BETWEEN 6 AND 10 ==> X
     WHERE ROWNUM 1; ==> O
     WHERE ROWNUM 2; ==> X
     WHERE ROWNUM < 10; ==> O
     WHERE ROWNUM > 10; ==> X
     
     SQL 절은 다음의 순서로 실행된다
     FROM => WHERE => SELECT => ORDER BY
     ORDER BY와 ROWNUM을 동시에 사용하면 정렬된 기준으로 ROWNUM이 부여되지 않는다.
     (SELECT 절이 먼저 실행되므로 ROWNUM이 부여된 상태에서 ORDER BY 절에 의해 정렬이 된다)
     
     
     
전체 데이터 : 14건
페이지사이즈 : 5건
1번째 페이지 : 1~5
2번째 페이지 : 6~10
3번째 페이지 : 11~15(14)
     
     
     
     
인라인 뷰
ALIAS

SELECT ROWNUM, empno, ename
FROM emp
WHERE ROWNUM BETWEEN 6 AND 10;

SELECT ROWNUM, empno, ename
FROM emp
WHERE ROWNUM < 15;
//됨

SELECT ROWNUM, empno, ename
FROM emp
WHERE ROWNUM > 15;
//안 됨

SELECT ROWNUM, empno, ename
FROM emp
ORDER BY ename;
//ROWNUM 의 정렬이 안 되어있음

FROM => SELECT => ORDER BY 순서로 이루어짐

SELECT ROWNUM, empno, ename
FROM emp


SELECT empno, ename
FROM emp;

SELECT *
FROM
(SELECT ROWNUM rn, empno, ename
FROM (SELECT empno, ename -- 인라인 뷰
      FROM emp
      ORDER BY ename))
WHERE rn BETWEEN (:page-1)*:pageSize+1 AND :page*:pageSize; -- 바인딩 변수 방식


WHERE rn BETWEEN 1 AND 15;
WHERE rn BETWEEN 1 AND 5;
WHERE rn BETWEEN 6 AND 10;

pageSize : 5건
1 page : rn BETWEEN 1 AND 5;
2 page : rn BETWEEN 6 AND 10;
3 page : rn BETWEEN 11 AND 15;
n page : rn BETWEEN n*5-4 AND n*5 ;
n page : rn BETWEEN n*(pageSize)-(pageSize - 1) AND n*(pageSize);

n page : rn BETWEN (page-1)*pageSize+1 AND page*pageSize;

row_1
emp 테이블에서 ROWNUM 값이 1~10인 값만 조회하는 쿼리를 작성해보세요
(정렬없이 진행하세요, 결과는 화면과 다를 수 있습니다.)
SELECT *
FROM(SELECT ROWNUM rn, empno, ename
FROM emp)
WHERE rn BETWEEN 1 AND 10;

SELECT ROWNUM rn, empno, ename
FROM emp
WHERE ROWNUM BETWEEN 1 AND 10;

row_2
ROWNUM 값이 11~20(11~14)인 값만 조회하는 쿼리를 작성해보세요
SELECT *
FROM
(SELECT ROWNUM rn, empno, ename
FROM emp)
WHERE rn BETWEEN 11 AND 20

row_3
emp 테이블의 사원 정보를 이름컬럼으로 오름차순 적용 했을 때의 11~14번째 행을 다음과 같이 조회하는 쿼리를 작성해보세요
SELECT a.*
FROM(SELECT ROWNUM rn, empno, ename
FROM(SELECT empno, ename FROM emp ORDER BY ename)) a
WHERE rn BETWEEN 11 AND 14;

rownum 용도
    페이징 처리
    다른 행과 구분되는 유일한 가상의 컬럼 생성/활용
    튜닝시
        inline view 안에서 rownum 사용시 view merging이 일어나지 않는다
        
SELECT ROWNUM rn, emp.* --에러
FROM emp e;



SELECT ROWNUM rn, e.empno
FROM emp e, emp m, dept; -- 테이블 명에 별칭을 붙일 때는 AS 라고 쓸 수가 없다

SELECT empno || 'yeah' A
FROM emp -- 잠깐 ALIAS 복습









