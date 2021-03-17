--1교시 시작

WHERE 조건1 : 10건

WHERE 조건1: 
AND 조건2 : 10건을 넘을 수 없음

WHERE deptno = 10
    AND sal > 500
    
table 객체의 특징은 순서가 바뀔 수 있다.
집합적 개념

페이징 처리를 못하는 웹페이지는 있을 수가 없다.

가상컬럼 ROWNUM 
    ROWNUM 유의점 
    WHERE 절에서도 사용가능하나
    1번부터 읽지 않으면 조회가 안 됨 <- 중요
    
    ROWNUM 유의점
        ORDER BY절은 SELECT 이후에 실행 된다

SELECT ROWNUM empno, ename
FROM emp
ORDER BY sal; -- 원하는 결과가 안 나옴

FROM - WHERE - SELECT - ORDER BY - 순서로 읽게 된다

-- 트랜잭션, NOT IN, 페이징 이거 세 문제 내신다고 합니다

FUNCTION
    SINGLE ROW FUNCTION
        단일 행을 기준으로 작업하고, 행당 하나의 결과를 반환
        특정 컬럼의 문자열 길이 : LENGTH(ename)
        
    MULTI ROW FUNCTION
        여러 행을 기준으로 작업하고 하나의 결과를 반환
        그룹함수
            COUNT, SUM, AVG
    
INPUT (X) -> FUNCTION F: -> OUTPUT F(X)

SELECT COUNT(*)
FROM emp;

함수명을 보고
1. 파라미터가 어떤게 들어갈까?
2. 몇 개의 파라미터가 들어갈까?
3. 반환되는 값은 무엇일까?

FUNCTION
    CHARACTER
        대소문자
        LOWER 입력값은 문자고 들어가는 갯수는 한개임 반환은 입력받은 값을 소문자로
        UPPER 입력값은 문자고 들어가는 갯수는 한개임 반환은 입력받은 값을 대문자로
        INITCAP 입력값은 문자고 첫 글자를 대문자로 나머지를 소문자로
        

SELECT * | {column | expression}

SELECT ename, LOWER(ename), UPPER(ename), INITCAP(ename), LOWER('TEST'), SUBSTR(ename, 1, 3), SUBSTR(ename, 2)
FROM emp;

FUNCTION
    문자열조작
        CONCAT 입력값은 문자열 두 개 반환은 입력받은 값들을 합침
        SUBSTR 인자가 두 개거나 세 개
        LENGTH
        INSTR
        LPAD | RPAD
        TRIM
        REPLACE

SELECT REPLACE(ename, 'S', 'T')
FROM emp;

    DUAL table
        sys 계정에 있는 테이블
        누구나 사용 가능
        DUMMY 컬럼 하나만 존재하며 값은 'X'이며 데이터는 한 행만 존재
        
        사용용도
            데이터와 관련 없이
                함수 실행
                시퀀스 실행
            merge 문에서
            데이터 복제시(connect by level) -- 이 용도로 많이 씀
            
SELECT LOWER(dummy)
FROM dual;

SELECT LENGTH('TEST')
FROM emp; --총 행이 14개라 14번 실행


SELECT LENGTH('TEST')
FROM dual; -- 행이 1개라 한 번만 실행

SELECT *
FROM dual
CONNECT BY level <= 10; -- 10회 실행

SINGLE ROW FUNCTION : WHERE 절에서도 사용 가능
emp 테이블에 등록된 직원들 중에 직원의 이름이 길이가 5글자를 초과하는 직원만 조회

SELECT *
FROM emp
WHERE LENGTH(ename) > 5;

SELECT *
FROM emp
WHERE LOWER(ename) = 'smith'; -- 아래와 결과 동일 다만 이 경우 함수의 호출 횟수가 많습니다. 이렇게 쓰지 마세요.

SELECT *
FROM emp
WHERE ename = UPPER('smith'); -- 위와 결과 동일 이 경우 함수의 횟수가 1회라서 훨씬 낫습니다.

--SQL 칠거지악 (엔코아 회사가 잘나갈 때 발표함)
--엔코아:오라클 DB를 잘 고쳤던 회사
--엔코아 ==> 엔코아_부사장 : b2en ==> b2en 대표컨설턴트 : dbian ;

ORACLE 문자열 함수

SELECT 'HELLO' || ',' || 'WORLD' 연결연산자, CONCAT('HELLO', CONCAT(',' , 'WORLD')) CONCAT,
        SUBSTR('HELLO, WORLD',1,5) SUBSTR,
        LENGTH('HELLO, WORLD') LENGTH,
        INSTR('HELLO, WORLD', 'O') INSTR, -- O가 있는 첫 번째 위치 반환
        INSTR('HELLO, WORLD', 'O' ,6) INSTR2, -- 6번째 글자부터 찾아서 O의 위치 반환
        -- ('XX회사-개발본부-개발부-개발팀-개발파트') 계층쿼리
        LPAD('HELLO, WORLD', 15, '*') LPAD,
        RPAD('HELLO, WORLD', 15, '*') RPAD,
        REPLACE('HELLO, WORLD', 'O', 'X') REPLACE,
        TRIM('         HELLO, WORLD         ') TRIM, -- 공백을 제거, 문자열의 앞과, 뒷부분에 있는 공백만
        TRIM('D' FROM 'HELLO, WORLD') TRIM_D
FROM dual;

FUNCTION
    숫자 조작
        ROUND
            반올림
        TRUNC
            내림
        MOD
            나눗셈의 나머지

SELECT MOD(10, 3)
FROM dual;

SELECT *
FROM emp
WHERE ename = 'SMITH';

-- emp 테이블의 컬럼의 이름이 시험문제로 나옵니다

SELECT ROUND(105.54, 1) round1, -- 반올림 결과가 소수점 첫번째 자리까지 나오도록 : 둘째자리에서 반올림 105.5
       ROUND(105.55, 2) round2, -- 반올림 결과가 소수점 두번째 자리까지 나오도록 : 셋째자리에서 반올림 105.55
       ROUND(105.54, 0) round0, -- 반올림 결과가 첫번째 자리까지 나오도록 : 첫째자리에서 반올림 106
       ROUND(105.54, -1) round_minus1, -- 반올림 결과가 두번째 자리수까지 나오도록 : 정수 첫째자리에서 반올림 110
       ROUND(105.54) round
FROM dual;

SELECT TRUNC(105.54, 1) TRUNC1, -- 절삭 결과가 소수점 첫번째 자리까지 나오도록 : 둘째자리에서 절삭 105.5
       TRUNC(105.55, 2) TRUNC2, -- 절삭 결과가 소수점 두번째 자리까지 나오도록 : 셋째자리에서 절삭 105.55
       TRUNC(105.54, 0) TRUNC0, -- 절삭 결과가 첫번째 자리까지 : 첫째자리에서 절삭 105
       TRUNC(105.54, -1) TRUNC_minus1, -- 절삭 결과가 두번째 자리까지 : 정수 첫째자리에서 절삭 100
       TRUNC(105.54) TRUNC
FROM dual;

SELECT empno, ename, sal, TRUNC(sal/1000) AS 몫, MOD(sal, 1000) AS 나머지
FROM emp;

날짜 <--> 문자
서버의 현재시간 : SYSDATE
SELECT SYSDATE + 1 -- 하루가 늘어남
FROM dual;

SELECT SYSDATE + 1/24 -- 한 시간이 늘어남
FROM dual;

SELECT SYSDATE + 1/24/60 -- 1분이 늘어남
FROM dual;

SELECT SYSDATE + 1/24/60/60 -- 1초가 늘어남
FROM dual;

Function (date 실습 fn1)

1. 2019년 12월 31일을 date형으로 표현
3. 2019년 12월 31일을 date형으로 표현하고 5일 이전 날짜
3. 현재 날짜
4. 현재 날짜에서 3일 전 값

위 4개 컬럼을 생성하여 다음과 같이 조회하는 쿼리를 작성하세요
SELECT TO_DATE('20191231' ,'YYYYMMDD') LASTDAY, TO_DATE('20191231' ,'YYYYMMDD')-5 LASTDAY_BEFORE5, SYSDATE NOW, SYSDATE-3 NOW_BEFORE3
FROM dual;

TO_DATE : 인자 - 문자, 문자의 형식
TO_CHAR : 인자 - 날짜, 문자의 형식


NLS : YYYY/MM/DD/HH24:MI:SS
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD'), TO_CHAR(SYSDATE, 'MI:SS'), TO_CHAR(SYSDATE, 'DD/HH24:MI:SS')
FROM dual;

-- 52-53
-- 주간요일(D) (0-일요일, 1-월요일, 2-화요일, ... 6-토요일)

SELECT SYSDATE, TO_CHAR(SYSDATE, 'IW'), TO_CHAR(SYSDATE, 'D')
FROM dual;

date 
    FORMAT
        YYYY : 4자리 년도
        MM : 2자리 월
        DD : 2자리 일자
        D : 주간 일자(1~7)
        IW : 주차 (1~53)
        HH, HH12 : 2자리 시간(12시간 표현)
        HH24 : 2자리 시간(24시간 표현)
        MI : 2자리 분
        SS : 2자리 초

Function (date 실습 fn2)

오늘 날짜를 다음과 같은 포맷으로 조회하는 쿼리를 작성하시오
1. 년-월-일
2. 년-월-일 시간(24)-분-초
3. 일-월-년

SELECT TO_CHAR(SYSDATE,'YYYY-MM-DD') DT_DASH, TO_CHAR(SYSDATE,'YYYY-MM-DD HH24-MI-SS') DT_DASH_WITH_TIME, TO_CHAR(SYSDATE,'DD-MM-YYYY') DT_DD_MM_YYYY
FROM dual;

SELECT TO_DATE(TO_CHAR(SYSDATE,'YYYY-MM-DD'), 'YYYY/MM/DD') DT_DASH
FROM dual;

'2021-03-17' ==> '2021-03-17 12:41:00'
SELECT TO_CHAR(TO_DATE('2021-03-17' , 'YYYY-MM-DD'),'YYYY-MM-DD HH24:MI:SS') time
FROM dual;

SELECT SYSDATE,TO_DATE(TO_CHAR(SYSDATE-5, 'YYYYMMDD'), 'YYYY/MM/DD') BEFORE5
FROM dual;














