적절한 인덱스 만들기

idx3

SELECT *
FROM EMP
WHERE empno = :empno;
SELECT *
FROM EMP
WHERE ename = :ename;
SELECT *
FROM EMP
WHERE sal BETWEEN :st_sal AND :ed_sal
AND deptno = :deptno;
SELECT *
FROM EMP, DEPT
WHERE EMP.deptno = DEPT.deptno
AND EMP.deptno = :deptno
AND EMP.empno LIKE :empno || '%';
SELECT B.*
FROM EMP A, EMP B
WHERE A.mgr = B.empno
AND A.deptno= :deptno;
SELECT deptno, TO_CHAR(hiredate, ‘yyyymm’),
 COUNT(*) cnt
FROM EMP
GROUP BY deptno, TO_CHAR(hiredate, ‘yyyymm’)


-----------------------------------------------------------

idx4

SELECT *
FROM EMP
WHERE empno = :empno;
SELECT *
FROM DEPT
WHERE deptno = :deptno;
SELECT *
FROM EMP
WHERE sal BETWEEN :st_sal AND :ed_sal
AND deptno = :deptno;
SELECT *
FROM EMP, DEPT
WHERE EMP.deptno = DEPT.deptno
AND EMP.deptno = :deptno
AND EMP.empno LIKE :empno || '%'; SELECT *
FROM EMP, DEPT
WHERE EMP.deptno = DEPT.deptno
AND EMP.deptno = :deptno
AND DEPT.loc = :loc;


--------------------------------------------------------------
FROM -> [START WITH] -> WHERE -> GROUP BY -> SELECT -> ORDER BY

SELECT
FROM
WHERE
START WITH
CONNECT BY
GROUP BY
ORDER BY

가지치기 : Pruning branch

SELECT empno, LPAD(' ', (LEVEL - 1)*4) || ename ename, mgr, deptno, job
FROM emp
WHERE job != 'ANALYST'
START WITH mgr IS NULL
CONNECT BY PRIOR empno = mgr;

계층구조를 다 만들고 애널리스트를 제외

SELECT empno, LPAD(' ', (LEVEL - 1)*4) || ename ename, mgr, deptno, job
FROM emp
START WITH mgr IS NULL
CONNECT BY PRIOR empno = mgr AND job!='ANALYST';

애널리스트를 제외하면서 계층구조를 만듬
애널리스트 밑에 애널리스트가 아닌 행이 있어도 연결하지 않음

계층 쿼리와 관련된 특수 함수
1. CONNECT_BY_ROOT(컬럼) : 해당 컬럼의 취상위 노드의 해당 컬럼 값
2. SYS_CONNECT_BY_PATH(컬럼, '구분자문자열') : 최상위 행부터 현재 행까지의 해당 컬럼의 값을 구분자로 연결한 문자열
3. CONNECT_BY_ISLEAF : CHILD가 없는 leaf node 여부 0 = false(no leaf node) / 1 = true(leaf node)


SELECT empno, LPAD(' ', (LEVEL - 1)*4) || ename ename, CONNECT_BY_ROOT(ename) root_ename,
        LTRIM(SYS_CONNECT_BY_PATH(ename, '-'),'-') path_ename,
        CONNECT_BY_ISLEAF
FROM emp
START WITH mgr IS NULL
CONNECT BY PRIOR empno = mgr AND job!='ANALYST';


1. 제목
    --2 답글
3. 제목
    --4 답글


SELECT *
FROM board_test;

SELECT seq, parent_seq, LPAD(' ', (LEVEL-1)*4) || title title
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq
ORDER siblings BY seq DESC;

START WITH 와 CONNECT BY 는 오라클에서만 지원하는 기능이다

시작(ROOT)는 글의 작성 순서의 역순으로
답글은 작성 순서대로 정렬

계층쿼리 (생각해볼거리 실습 h9)
    일반적인 게시판을 보면 최상위글은 최신 글이 먼저 오고, 답글의 경우 작성한 순서대로 정렬이 된다.
    어떻게 하면 최상위글은 최신글 순(DESC)으로 정렬하고, 답글은 순차(ASC)적으로 정렬할 수 있을까?

1 방법

SELECT *
FROM
(SELECT gn, CONNECT_BY_ROOT(seq) root_seq, seq, parent_seq, LPAD(' ', (LEVEL-1)*4) || title title
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq)
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq
ORDER siblings BY root_seq DESC, seq ASC;
--이제 된다 해결됨 siblings를 잘 쓰자
2 방법

SELECT gn, CONNECT_BY_ROOT(seq) root_seq, seq, parent_seq, LPAD(' ', (LEVEL-1)*4) || title title
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq
ORDER siblings BY gn DESC, seq ASC;


SELECT ename, job, sal
FROM emp
ORDER BY job, sal

시작글부터 관련 답글까지 그룹번호를 부여하기 위해 새로운 컬럼 추가

ALTER TABLE board_test ADD( gn NUMBER);
DESC board_test;

UPDATE board_test SET gn = 1
WHERE seq IN (1,9);


UPDATE board_test SET gn = 2
WHERE seq IN (2,3);


UPDATE board_test SET gn = 4
WHERE seq NOT IN (1,2,3,9);

pagesize : 5
page : 2

SELECT *
FROM
(SELECT ROWNUM rn, a.*
FROM(SELECT gn, CONNECT_BY_ROOT(seq) root_seq, seq, parent_seq, LPAD(' ', (LEVEL-1)*4) || title title
FROM board_test
START WITH parent_seq IS NULL
CONNECT BY PRIOR seq = parent_seq
ORDER siblings BY gn DESC, seq ASC) a )
WHERE rn between 6 AND 10;

거래종목        날짜    시가      종가      저가      고가        전일대비
삼성전자        3.30   81700     81600    81000     81700      +100(종가기준)

그 사람이 누군데?
SELECT *
FROM emp
WHERE deptno =10
AND sal = ( SELECT MAX(sal)
            FROM emp
            WHERE deptno = 10);

분석함수(window 함수)
    SQL에서 행간 연산을 지원하는 함수
    
    해당 행의 범위를 넘어서 다른 행과 연산이 가능
    - SQL의 약점 보완
    - 이전행의 특정 컬럼을 참조
    - 특정 범위의 행들의 컬럼의 합
    - 특정 범위의 행중 특정 컬럼을 기준으로 순위, 행번호 부여
    
    - SUM, COUNT, AVG, MAX, MIN
    - RANK, LEAD, LAG....
    
분석함수 / window함수 (도전해보기 실습 ana0)

사원의 부서별 급여(sal)별 순위 구하기
emp 테이블 활용

되긴 하는데 더 쉬운 방법이 있을듯
1.

SELECT ROWNUM rank, a.*
FROM 
(SELECT emp.*
FROM emp
WHERE deptno = 10
ORDER BY sal DESC) a

UNION ALL

SELECT ROWNUM rank, a.*
FROM 
(SELECT emp.*
FROM emp
WHERE deptno = 20
ORDER BY sal DESC) a

UNION ALL

SELECT ROWNUM rank, a.*
FROM 
(SELECT emp.*
FROM emp
WHERE deptno = 30
ORDER BY sal DESC) a
--동일임금 동일랭크가 불가능함 포기

2.

SELECT ename, sal, deptno, RANK() OVER(PARTITION BY deptno ORDER BY sal DESC) rank
FROM emp
ORDER BY deptno, sal DESC


SELECT ename, sal, deptno, RANK() OVER(PARTITION BY deptno ORDER BY sal DESC) rank
FROM emp

--order by를 하지 않아도 괜찮음

RANK() over (PARTITION BY deptno ORDER BY sal DESC) sal_rank
PARTITION BY deptno : 같은 부서코드를 갖는 row를 그룹으로 묶는다
ORDER BY sal : 그룹내에서 sal로 row의 순서를 정한다
RANK() : 파티션 단위안에서 정렬 순서대로 순위를 부여한다

----------------------------------------------

SELECT rank, sal, ename, deptno
FROM
(SELECT ROWNUM rn, a.*
FROM
(SELECT ename, sal, deptno
FROM emp
ORDER BY deptno, sal DESC) a) a,


(SELECT ROWNUM rn, rank
FROM
(SELECT a.rn rank
FROM
(SELECT ROWNUM rn
FROM emp) a,

(SELECT deptno, COUNT(*) cnt
FROM emp
GROUP BY deptno) b

WHERE a.rn <=b.cnt
ORDER BY b.deptno, a.rn)) b

WHERE a.rn = b.rn

---------------------------------------------

SELECT window_funtion([arg])
    OVER ([PARTITION BY col] [ORDER BY col] [WINDOWING])
    
순위 관련된 함수 (중복값을 어떻게 처리하는가)
RANK : 동일 값에 대해 동일 순위 부여하고, 후순위는 동일값만 건너뛴다
        1등 2명이면 그 다음 순위는 3위
DENSE_RANK : 동일 값에 대해 동일 순위 부여하고, 후순위는 이어서 부여한다
        1등 2명이면 그 다음 순위는 2위
ROW_NUMBER : 중복 없이 행에 순차적인 번호를 부여(ROWNUM)


SELECT ename, sal, deptno, RANK() OVER(PARTITION BY deptno ORDER BY sal DESC) rank,
DENSE_RANK() OVER(PARTITION BY deptno ORDER BY sal DESC) sal_dense_rank,
ROW_NUMBER() OVER(PARTITION BY deptno ORDER BY sal DESC) sal_row_number
FROM emp

SELECT WINDOW_FUNCTION([인자]) OVER ( [PARTITION BY 컬럼] [ORDER BY 컬럼] )
FROM ----

PARTITION BY : 영역 설정
ORDER BY (ASC/DESC) : 영역 안에서의 순서 정하기

ana1 사원의 전체 급여 순위를 구하는데 급여가 동일할 경우 사번이 빠른 사람이 높은 순위가 되도록 설정하세요

SELECT ename, sal, deptno, RANK() OVER(ORDER BY sal DESC, empno ) rank,
DENSE_RANK() OVER(ORDER BY sal DESC, empno) sal_dense_rank,
ROW_NUMBER() OVER(ORDER BY sal DESC, empno) sal_row_number
FROM emp

분석함수 window 함수 실습 no_ana2
기존의 배운 내용을 활용하여
모든 사원에 대해 사원번호, 사원이름, 해당 사원이 속한 부서의 사원 수를 조회하는 쿼리를 작성하세요.

SELECT ename, sal, deptno, RANK() OVER(PARTITION BY deptno ORDER BY sal DESC) rank,
DENSE_RANK() OVER(PARTITION BY deptno ORDER BY sal DESC) sal_dense_rank,
ROW_NUMBER() OVER(PARTITION BY deptno ORDER BY sal DESC) sal_row_number
FROM emp

SELECT empno, ename, emp.deptno, cnt
FROM
emp,
(SELECT count(*) cnt, deptno
FROM emp
GROUP BY deptno) a
WHERE emp.deptno = a.deptno
ORDER BY deptno

SELECT empno, ename, deptno, count(*) OVER (PARTITION BY deptno) cnt
FROM emp

