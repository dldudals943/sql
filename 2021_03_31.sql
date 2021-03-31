
COUNT, AVG, MIN, MAX, SUM

SELECT empno, ename, deptno, count(*) OVER (PARTITION BY deptno) cnt
FROM emp

ana2
window function 을 이용하여 모든 사원에 대해 사원번호, 사원이름, 본인급여, 부서번호와 해당 사원이 속한 부서의
급여 평균을 조회하는 쿼리를 작성하세요. (급여 평균은 소수점 둘째 자리까지 구한다.)

SELECT empno, ename, deptno, ROUND(AVG(sal) OVER (PARTITION BY deptno),2) avg
FROM emp;

--해당 부서의 가장 낮은 급여
--해당 부서의 가장 높은 급여


SELECT empno, ename, deptno, ROUND(AVG(sal) OVER (PARTITION BY deptno),2) avg,
        MIN(sal) OVER (PARTITION BY deptno) min, max(sal) OVER (PARTITION BY deptno) max,
        COUNT(*) OVER (PARTITION BY deptno) cnt, SUM(sal) OVER (PARTITION BY deptno) sum
FROM emp;

결과만 필요할 때는 system function 을 사용하는게 올바른 방법은 아니다.
GROUP BY를 이용하여 구하는게 속도적인 이유에서 옳다.

분석함수 / window 함수 (그룹내 행 순서)
LAG(col)
    파티션별 윈도우에서 이전 행의 컬럼 값
LEAD(col)
    파티션별 윈도우에서 이후 행의 컬럼 값
    
자신보다 급여 순위가 한단계 낮은 사람의 급여를 5번째 컬럼으로 생성    
SELECT empno, ename, hiredate, sal, LEAD(sal) OVER (ORDER BY sal DESC, hiredate) lead_sal
FROM emp;

ana5
window function을 이용하여 모든 사원에 대해 사원번호, 사원이름, 입사일자, 급여, 전체 사원 중 급여 순위가
1단계 높은 사람의 급여를 조회하는 쿼리를 작성하세요 (급여가 같을 경우 입사일이 빠른 사람이 높은 순위)

SELECT empno, ename, hiredate, sal, LAG(sal) OVER (ORDER BY sal DESC, hiredate) lag_sal
FROM emp;

ana5_1
window function를 사용하지 않고 모든 사원에 대해 사원번호, 사원이름, 입사일자, 급여, 전체 사원 중 급여 순위가
1단계 높은 사람의 급여를 조회하는 쿼리를 작성하세요 (급여가 같을 경우 입사일이 빠른 사람이 높은 순위)

내 코드

SELECT b.empno, b.ename, b.hiredate,  b.sal, a.sal lag_sal
FROM

(SELECT ROWNUM rn, a.*
FROM
(SELECT empno, ename, hiredate, sal
FROM emp
ORDER BY sal DESC, hiredate) a) a,

(SELECT ROWNUM-1 rn2, b.*
FROM
(SELECT empno, ename, hiredate, sal
FROM emp
ORDER BY sal DESC, hiredate) b) b

WHERE rn(+) = rn2
ORDER BY sal DESC, hiredate

-------------------------------------------------------------
선생님 코드
SELECT a.empno, a.ename, a.hiredate, a.sal, b.sal
FROM

(SELECT  a.*, ROWNUM rn
FROM
(SELECT empno, ename, hiredate, sal
FROM emp
ORDER BY sal DESC, hiredate) a) a,

(SELECT  a.*, ROWNUM rn
FROM
(SELECT empno, ename, hiredate, sal
FROM emp
ORDER BY sal DESC, hiredate) a) b

WHERE a.rn-1 =b.rn(+) --기준이 되는 쪽의 "반대쪽"에다가 +를 붙여준다. 즉 null이 올 것 같은 컬럼쪽에다가 +를 붙여줘서 누락 된 것을 해결한다.
ORDER BY a.sal DESC, a.hiredate

------------------------------------------------------------

ana6
window function을 이용하여 모든 사원에 대해 사원번호 사원이름, 입사일자, 직군(job), 급여 정보와 담당업무 별 급여 순위가 1단계
높은 사람의 급여를 조회하는 쿼리를 작성하세요 (급여가 같을 경우 입사일이 빠른 사람이 높은 순위)

SELECT empno, ename, hiredate, job, sal, LAG(sal) OVER(PARTITION BY job ORDER BY sal DESC, hiredate) lag_sal
FROM emp;

분석함수 OVER([] [] [])

LAG, LEAD 함수의 두번째 인자 : 이전, 이후 몇번째 행을 가져올지 표기
SELECT empno, ename, hiredate, sal, LAG(sal, 2) OVER(ORDER BY sal DESC, hiredate) lag_sal
FROM emp;

no_ana3
모든 사원에 대해 사원번호, 사원이름, 입사일자, 급여를 급여가 낮은순으로 조회해보자, 급여 동일할 경우 사원번호가 빠른사람이 우선순위가 높다
SELECT empno, ename, hiredate, sal
FROM emp

--------------------------------------------------------
내 코드

SELECT a.empno,a.ename,a.hiredate,a.sal, SUM(b.sal) "누적 연봉 합"
FROM
(SELECT  a.*, ROWNUM rn
FROM
(SELECT empno, ename, hiredate, sal
FROM emp
ORDER BY sal DESC, empno) a) a,

(SELECT  a.*, ROWNUM rn
FROM
(SELECT empno, ename, hiredate, sal
FROM emp
ORDER BY sal DESC, empno) a) b

WHERE a.rn BETWEEN 1 AND b.rn
GROUP BY a.empno, a.ename, a.hiredate, a.sal
ORDER BY sal DESC, empno;

------------------------------------------------
선생님 코드
1. ROWNUM
2. INLINE VIEW
3. NON-EQUI-JOIN
4. GROUP BY

SELECT a.empno,a.ename,a.hiredate,a.sal, SUM(b.sal)
FROM
(SELECT  a.*, ROWNUM rn
FROM
(SELECT empno, ename, hiredate, sal
FROM emp
ORDER BY sal, empno) a) a,

(SELECT  a.*, ROWNUM rn
FROM
(SELECT empno, ename, hiredate, sal
FROM emp
ORDER BY sal, empno) a) b

WHERE a.rn >= b.rn --이렇게 기호를 쓰면 a가 기준인가 b가 기준인가 헷갈릴 수 있다.
GROUP BY a.empno, a.ename, a.hiredate, a.sal
ORDER BY a.sal DESC, empno;

------------------------------------------------------
분석함수() OVER ([PARTITION BY] {ORDER} [WINDOWING])
WINDOWING : 윈도우함수의 대상이 되는 행을 지정
UNBOUNDED PRECEDING : 특정 행을 기준으로 모든 이전행(LAG)
    n PRECEDING : 특정 행을 기준으로 N행 이전행(LAG)
CURRENT ROW : 현재행
UNBOUNDED FOLLOWING : 특정 행을 기준으로 모든 이후행(LEAD)
    n FOLLOWING : 특정 행을 기준으로 n행 이후행(LEAD)

SELECT  empno, ename, sal,
        SUM(sal) OVER (ORDER BY sal, empno ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) c_sum,
        SUM(sal) OVER (ORDER BY sal, empno ROWS UNBOUNDED PRECEDING) c_sum --CURRENT ROW 가 기본값
FROM emp
ORDER BY sal, empno


SELECT  empno, ename, sal,
        SUM(sal) OVER (ORDER BY sal, empno ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) c_sum
FROM emp
ORDER BY sal, empno

ana7
사원번호, 사원이름, 부서번호, 급여 정보를 부서별로 급여, 사원번호 오름차순으로 정렬했을 때, 자신의 급여와
선행하는 사원들의 급여 합을 조회하는 쿼리를 작성하세요

SELECT  empno, ename, deptno, sal,
        SUM(sal) OVER (PARTITION BY deptno ORDER BY sal, empno ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) c_sum
FROM emp

WINDOWING 범위 설정
ROWS
    물리적인 row
RANGE
    논리적인 값의 범위
    같은 값을 하나로 본다
    
SELECT  empno, ename, sal,
        SUM(sal) OVER (ORDER BY sal ROWS UNBOUNDED PRECEDING) rows_c_sum, 
        SUM(sal) OVER (ORDER BY sal RANGE UNBOUNDED PRECEDING) range_c_sum,
        SUM(sal) OVER (ORDER BY sal) no_win_c_sum, --order by 이후 윈도윙 없을 경우 기본 설정 : RANGE UNBOUNDED PRECEDEING
        SUM(sal) OVER () no_ord_c_sum
FROM emp
ORDER BY sal, empno

ROWS 의 경우 한 칸 씩 내려간다
RANGE 의 경우 같은 값이면 다른 값이 나올 때까지 내려간다
ORDER BY를 사용할경우 RANGE가 기본값이 들어간다


수업시간에 다루지 않은 분석함수

RATIO_TO_REPORT
PERCENT_RANK
CUME_DIST
NTILE

남은 시간에 책 소개
수업을 잘 이해했다는 전제조건
지금 볼 내용이 아닐 수도 있다

SQL(SQLD)
기초를 잡는데 괜찮은
sql 전문가 가이드 2020 에디션
전문가로 가는 지름길 오라클 실습 - 15장이후 한글 사이즈 차이가 나서 늘려줘서 문제풀면 됨 17장은 안해도 됨
SQL 자격검정 실전문제
하루 10분 sql <- 크게 의미 x

불친절한 SQL 프로그래밍 <- 사는건 추천하지 않음 개념 정리는 잘 되어있음

data modeling
관계형 데이터 모델링 프리미엄 가이드 - 김기창 지음

DB(DBMS 내부원리 -> (자격증)SQLP/DAP)
    컨설팅
        encore
            대용량 데이터베이스 솔루션(조강원, 인터파크) - 어둠의 경로에 동영상이 있음
        b2en
        dbian
        
        open made
        
    성능 측정도구
        exem

    책 
    새로쓴 대용량 데이터 베이스 솔루션 vol.1
    오라클 성능 고도화 원리와 해법 1, 2
        이거 3권 정도는 이해할 수 있어야 -> sql 전문가 가이드를 볼 수 있다.

교양
    나는 프로그래머다
    
필수 각각 게시판 작성        JSP/Servlet - Spring
SI/SM 업무의 베이스는 데이터          SQL
언제까지 시키는 것만 할텐가         Modeling
스스로의 길을 찾으세요(도망가!!!)    관심사항

수업목표 : 설계도를 보고 주어진 조건을 만족하는 SQL을 작성할 수 있다.
        java프로그램을 통해 sql을 실행할 수 있다.
        
t-academy
datasience