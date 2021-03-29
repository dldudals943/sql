SELECT *
FROM emp
ORDER BY ename, job;

job, ename 컬럼으로 구성된 IDX_emp_03 인덱스 삭제

CREATE 객체타입(INDEX, TABLE, SEQUN...) 객체명
DROP 객체타입 객체명;

DROP INDEX IDX_emp_03;

CREATE INDEX idx_emp_04 ON emp (ename, job);

EXPLAIN PLAN FOR
SELECT *
FROM emp
WHERE job = 'MANAGER'
AND ename LIKE 'C%';

SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);

Plan hash value: 4077983371
 
------------------------------------------------------------------------------------------
| Id  | Operation                   | Name       | Rows  | Bytes | Cost (%CPU)| Time     |
------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT            |            |     1 |    87 |     2   (0)| 00:00:01 |
|   1 |  TABLE ACCESS BY INDEX ROWID| EMP        |     1 |    87 |     2   (0)| 00:00:01 |
|*  2 |   INDEX RANGE SCAN          | IDX_EMP_04 |     1 |       |     1   (0)| 00:00:01 |
------------------------------------------------------------------------------------------
 
Predicate Information (identified by operation id):
---------------------------------------------------
 
   2 - access("ENAME" LIKE 'C%' AND "JOB"='MANAGER')
       filter("JOB"='MANAGER' AND "ENAME" LIKE 'C%')
 
Note
-----
   - dynamic sampling used for this statement (level=2)
   

SELECT ROWID, dept.*
FROM dept;
   
CREATE INDEX idx_dept_01 ON dept (deptno);   
   
emp
    1. table full access
    2. idx_emp_01
    3. idx_emp_02
    4. idx_emp_04
    
dept
    1. table full access
    2. idx_dept_01
    
emp(4) => dept(2) : 8가지
dept(2) => emp(4) : 8가지

16가지 응답성을 목표하기 때문에 항상 정답을 맞출 수는 없다
접근방법 * 테이블^개수

EXPLAIN PLAN FOR
SELECT ename, dname, loc
FROM emp, dept
WHERE emp.deptno = dept.deptno
AND emp.empno = 7788;


SELECT *
FROM TABLE(DBMS_XPLAN.DISPLAY);


SELECT dname, loc
FROM dept
WHERE dept.deptno = 20;



응답성 : OLTP (Online Transaction Procssing)
            - 대부분
퍼포먼스 : OLAP (Online Analysis Processing)
            - 은행이자 계산
   

Plan hash value: 951379666
 
---------------------------------------------------------------------------------------------
| Id  | Operation                     | Name        | Rows  | Bytes | Cost (%CPU)| Time     |
---------------------------------------------------------------------------------------------
|   0 | SELECT STATEMENT              |             |     1 |    63 |     3   (0)| 00:00:01 |
|   1 |  NESTED LOOPS                 |             |       |       |            |          |
|   2 |   NESTED LOOPS                |             |     1 |    63 |     3   (0)| 00:00:01 |
|   3 |    TABLE ACCESS BY INDEX ROWID| EMP         |     1 |    33 |     2   (0)| 00:00:01 |
|*  4 |     INDEX RANGE SCAN          | IDX_EMP_01  |     1 |       |     1   (0)| 00:00:01 |
|*  5 |    INDEX RANGE SCAN           | IDX_DEPT_01 |     1 |       |     0   (0)| 00:00:01 |
|   6 |   TABLE ACCESS BY INDEX ROWID | DEPT        |     1 |    30 |     1   (0)| 00:00:01 |
---------------------------------------------------------------------------------------------
4 3 5 2 6 1 0
Predicate Information (identified by operation id):
---------------------------------------------------
 
   4 - access("EMP"."EMPNO"=7788)
   5 - access("EMP"."DEPTNO"="DEPT"."DEPTNO")
 
Note
-----
   - dynamic sampling used for this statement (level=2)

INDEX ACCESS
    - 소수의 데이터를 조회할 때 유리 (응답속도가 필요할 때)
        - index를 사용하는 input/output single block I/O
    - 다량의 데이터를 인덱스로 접근할 경우 속도가 느리다(2~3000건)

TABLE ACCESS
    - 테이블의 모든 데이터를 읽고서 처리를 해야하는 경우 인덱스를 통해 모든 데이터를 테이블로 접근하는 경우보다 빠름
        - I/O 기준이 multi block
   
   
인덱스의 단점
1. 저장공간

테이블에 인덱스가 많다면
1. 테이블의 빈공간을 찾아 데이터를 입력한다
2. 인덱스의 구성 컬럼을 기준으로 정렬된 위치를 찾아 인덱스 저장
3. B*트리 구조 root node 부터 leaf node까지 depth가 항상 같도록 밸런스를 유지
4. 데이터 입력으로 밸런스가 무너질경우 밸런스를 맞추는 추가 작업이 필요
5. 2-4의 과정을 각 인덱스 별로 반복한다

인덱스가 많아질 경우 위 과정이 인덱스 개수 만큼 반복되기 때문에 UPDATE, INSERT, DELETE 시 부하가 커진다
인덱스는 SELECT 실행시 조회 성능개선에 유리하지만 데이터변경시 부하가 생긴다
테이블에 과도한 수의 인덱스를 생성하는 것은 바람직하지 않음
하나의 쿼리를 위한 인덱스 설계는 쉬움
시스템에서 실행되는 모든 쿼리를 분석하여 적절한 개수의 최적의 인덱스를 설계하는 것이 힘듬

일반적으로는 (=) 조건을 사용하는 것을 먼저 오게하게 인덱스를 만든다

(index 주문 / 상담 일자 인덱스 : 데이터의 특성상 우하향으로 트리가 성장)
(index 주문 / 상담 일자 인덱스 : B 트리, 트리가 성장함에 따라 밸런스를 조정)

--------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------
도전 실습과제

index 실습 idx3
시스템에서 사용하는 쿼리가 다음과 같다고 할 때 적절한 emp 테이블에 필요하다고 생각되는 인덱스 생성 스크립트를 만들어 보세요.
--이건 좀 어려운듯


--------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------



뜬금없게 달력을 만들어본다고 한다. 이 정도만 할 줄 알면 실무에서 쿼리로 고생할 일이 없다고 한다.

배우고자 하는 것
데이터의 행을 열로 바꾸는 방법
레포트 쿼리에서 활용 할 수 있는 예제 연습

예제 시나리오
    주어진 상황
        년월 : 201905
        
    하고싶은 것
        해당 년월의 일자를 달력 형태로 출력


달력만들기
    주어진 것 : 년월 6자리 문자열( ex202103)
    만들 것 : 해당 년월에 해당하는 달력 (7칸짜리 테이블)
    
20210301 - 날짜, 문자열
20210302
20210303
.
.
.
.
.
20210331

YYYY
MM
DD
HH, HH24
MI
SS
주차 : IW
주간 요일 : D



--(LEVEL은 1부터 시작)
SELECT dummy, level
FROM dual
CONNECT BY LEVEL <= 10;

커넥트 바이 레벨이라는 걸 쓰면 설렉트절에서 레벨이라는 걸 넣을 수 있다

SELECT TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')), 'DD')
FROM dual;

SELECT dt, d, iw
FROM
(SELECT TO_DATE(:YYYYMM,'YYYYMM') + (level - 1) dt,
TO_CHAR(TO_DATE(:YYYYMM,'YYYYMM') + (level - 1),'D') d,
TO_CHAR(TO_DATE(:YYYYMM,'YYYYMM') + (level - 1),'IW') iw
FROM dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')), 'DD'));
--MAX , MIN 뭘 써도 null은 연산에서 제외되기 때문에 상관없으나
--오라클에서 MIN이 더 빠르다고 해서 MIN으로 쓴다.
SELECT decode(d, 1,iw+1, iw),
    MIN(DECODE(D,1,dt,null)) son,
    MIN(DECODE(D,2,dt,null)) mon,
    MIN(DECODE(D,3,dt,null)) tue,
    MIN(DECODE(D,4,dt,null)) wed,
    MIN(DECODE(D,5,dt,null)) thu,
    MIN(DECODE(D,6,dt,null)) fri,
    MIN(DECODE(D,7,dt,null)) sat
FROM
(SELECT TO_DATE(:YYYYMM,'YYYYMM') + (level - 1) dt,
TO_CHAR(TO_DATE(:YYYYMM,'YYYYMM') + (level - 1),'D') d,
TO_CHAR(TO_DATE(:YYYYMM,'YYYYMM') + (level - 1),'IW') iw
FROM dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')), 'DD'))
GROUP BY decode(d, 1,iw+1, iw)
ORDER BY decode(d, 1,iw+1, iw);

--일요일이 한칸 올라가있음 iw는 주의 시작을 일요일이 아니라 월요일로 보고 있는 날짜 포맷이다. 국제 표준이라고 한다.
--그래서 일요일의 주차를 하나 더해야한다.
--ISO 표준 주차의 기준은 해당 주일의 목요일을 기준으로 한다.
--즉 2019년 12월 30,31일의 경우 해당 주의 목요일인 20200102이 2020년이기 때문에 1주차가 된다


오라클은 계층쿼리 BOM을 잘 지원한다 다른 DBMS보다 파워풀하다.

계층쿼리 - 조직도, BOM(Bill of Material), 게시판(답변형 게시판)
        - 데이터의 상하 관계를 나타내는 쿼리
SELECT empno, ename, mgr
FROM emp;

사용방법 : 1. 시작위치를 설정
          2. 행과 행의 연결 조건을 기술
          
SELECT empno, LPAD(' ', (LEVEL-1)*4) || ename, mgr, LEVEL
FROM emp
START WITH empno = 7839
CONNECT BY PRIOR empno = mgr;

내가 지금 읽은 행의 사번 = 앞으로 읽을 행의 MGR 컬럼
KING의 사번  = mgr 컬럼의 값이 KING 의 사번인 사원
empno = mgr
PRIOR - 이전의, 사전의, 이미 읽은 데이터

SELECT LPAD('TEST', 10, ' ') lp 
FROM dual

-- 3번째 값 안 쓰면 자동으로 공백이 된다. 

계층쿼리 방향에 따른 분류
상향식 : 최하위 노드(leaf node)
하향식 : 최상위 노드(root node)에서 모든 자식 노드를 방문하는 형태

상향식 쿼리
SMITH 부터 시작하여 노드의 부모를 따라가는 계층형 쿼리 작성


SELECT empno, LPAD(' ', (LEVEL-1)*4) || ename, mgr, LEVEL
FROM emp
START WITH empno = 7369
CONNECT BY empno = PRIOR mgr;
--상향식 쿼리

SELECT *
FROM dept_h;

SELECT deptcd, LPAD(' ', (LEVEL-1)*4) || deptnm deptnm, LEVEL
FROM dept_h
START WITH p_deptcd IS NULL
CONNECT BY PRIOR deptcd = p_deptcd;

//PSUEDO CODE - 가상코드
CONNECT BY 현재행의 deptcd = 앞으로 나올 p_deptcd

h_2
정보시스템부 하위의 부서계층 구조를 조회하는 쿼리를 작성하세요

SELECT  LEVEL, deptcd, LPAD(' ', (LEVEL-1)*4) || deptnm deptnm, p_deptcd
FROM dept_h
START WITH deptcd = 'dept0_02'
CONNECT BY PRIOR deptcd = p_deptcd;

계층쿼리 : oracle 계층 쿼리의 탐색 순서는?

pre-order

하고 싶은 것
개발 본부의 소속 인원은 james 한명이지만 하위 조직인 개발 1,2 팀의 인원까지 포함한 누적합 5명까지 출력


--------------------------------------------------------------

SELECT

    min(DECODE(D,1,dt,null)) son,
    min(DECODE(D,2,dt,null)) mon,
    min(DECODE(D,3,dt,null)) tue,
    min(DECODE(D,4,dt,null)) wed,
    min(DECODE(D,5,dt,null)) thu,
    min(DECODE(D,6,dt,null)) fri,
    min(DECODE(D,7,dt,null)) sat
FROM
(SELECT
    CASE
    WHEN decode(d, 1, iw+1, iw)=1 AND MM='12' THEN TO_NUMBER(iwx+1)
    ELSE TO_NUMBER(decode(d, 1, iw+1, iw))
    END iwn,xxx.*
FROM
(SELECT TO_DATE(:YYYYMM,'YYYYMM') + (level - 1) dt,
TO_CHAR(TO_DATE(:YYYYMM,'YYYYMM') + (level - 1),'D') d,
TO_CHAR(TO_DATE(:YYYYMM,'YYYYMM') + (level - 1),'IW') iw,
TO_CHAR(TO_DATE(:YYYYMM,'YYYYMM') + (level - 1 - 7),'IW') iwx,
TO_CHAR(TO_DATE(:YYYYMM,'YYYYMM') + (level - 1),'MM') MM

FROM dual
CONNECT BY LEVEL <= TO_CHAR(LAST_DAY(TO_DATE(:YYYYMM, 'YYYYMM')), 'DD')) xxx)
GROUP BY iwn
ORDER BY iwn;
---------------------------------------------------------------------------------

-------------------------------------------------------------

h_3
디자인팀에서 시작하는 상향식 계층 쿼리를 작성하세요
SELECT  LEVEL, deptcd, LPAD(' ', (LEVEL-1)*4) || deptnm deptnm, p_deptcd
FROM dept_h
START WITH deptcd = 'dept0_00_0'
CONNECT BY deptcd = PRIOR p_deptcd;

h_4
s_id : 노드 아이디, ps_id : 부모 노드 아이디, value : 노드 값
SELECT LPAD(' ', (LEVEL-1)*4) || s_id s_id, value
FROM H_SUM
START WITH s_id = '0'
CONNECT BY prior s_id = ps_id;
--인덱스 컬럼은 비교되기 전에 변형이 일어나면 인덱스를 사용할 수 없다

