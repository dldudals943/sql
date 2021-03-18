FUNCTION
    ROUND(DATE, format)
    TRUNC(DATE, format)
    format에 자르거나 반올림할 목표 포맷을 입력
    
날짜관련 함수
MONTHS_BETWEEN(*) : -- 생각보다 큰 의미가 없다.
인자 - start date, end date, 반환값 : 두 일자 사이의 개월 수

ADD_MONTHS(***)
인자 : date, number 더할 개월수 : date로부터 x개월 뒤의 날짜

date + 90 로 일 수를 더할 수 있는데 각 월마다 일수가 달라서 문제가 생길 수도 있다.

NEXT_DAY(***)
인자 : date, number(weekday, 주간일자)
date 이후의 가장 첫번째 주간일자에 해당하는 date를 반환합니다.

LAST_DAY(***)
인자 : date : date가 속한 월의 마지막 일자를 date로 반환.

MONTHS_BETWEEN
SELECT ename, TO_CHAR(hiredate, 'yyyy/mm/dd HH24:MI:SS') hiredate,
       TRUNC(MONTHS_BETWEEN(SYSDATE, hiredate)) MONTH, --MONTHS_BETWEEN 의 경우 보통 딱 안 떨어져서 소수점을 표현하는데 이걸 쓸 때는 보통 소수점자리를 버리게된다.
       ADD_MONTHS(SYSDATE, 5) ADD_MONTHS,
       ADD_MONTHS(TO_DATE('2021-02-15','YYYY-MM-DD'), -5) ADD_MONTHS2,--당연한 이야기지만 과거로도 갈 수 있다
       NEXT_DAY(SYSDATE, 6) NEXT_FRIDAY, -- 일월화수목금토 -- 1234567
       NEXT_DAY(SYSDATE, 1) NEXT_SUNDAY,
       LAST_DAY(SYSDATE) LAST_DAY,
       /*
       * --SYSDATE를 이용하여 SYSDATE가 속한 월의 첫번째 날짜 구하기
       */
       TO_DATE(TO_CHAR(SYSDATE, 'YYYYMM') || '01','YYYYMMDD') FIRSTDAY
FROM emp;

SELECT TO_DATE('2021','YYYY') -- 이 경우 서버의 현재시간의 월과 그 월에 첫번째 날짜
FROM dual;

SELECT TO_DATE('2021' || '0101' , 'YYYYMMDD')
FROM dual;

FUNCTION (date 종합 실습 fn3)
파라미터로 yyyymm형식의 문자열을 사용하여 (ex: yyyymm = 201912)
해당 년월에 해당하는 일자 수를 구해보세요

yyyymm=201912 -> 31

fn3] LAST_DAY(날짜)
SELECT :yyyymm PARAM, TO_CHAR(LAST_DAY(TO_DATE(:yyyymm,'YYYYMM')),'DD') DT
FROM dual;


typecast
형변환
    - 명시적 형변환
        TO_DATE, TO_CHAR, TO_NUMBER
    - 묵시적 형변환

SELECT *
FROM emp
WHERE empno = '7369'; -- 묵시적형변환

SELECT *
FROM emp
WHERE TO_CHAR(empno) = '7369';

1. 위에서 아래로
2. 단, 들여쓰기 되어있을경우(자식 노드) 자식노드부터 읽는다
3. 별표는 추가적인 데이터가 있다

--조금 어려운거
-- 3 - 2 - 5 - 4 - 1 - 0

function (number)

    NUMBER
        FORMAT
            9 : 숫자
            0 : 강제로 0 표시
            , : 1000자리 표시
            . : 소수점
            L : 화폐단위(사용자 지역)
            $ : 달러 화폐 표시
            
            
SELECT ename, sal, TO_CHAR(sal, 'L0009,999.00') fm_sal --잘 안쓰는 기능
FROM emp;

NULL 처리 함수 : 4가지

NVL(expr1, expr2) :  expr1이 NULL값이 아니면 expr1을 사용하고, expr1이 NULL값이면 expr2를 대체해서 사용한다.
if(expr1 == null)
    System.out.println(expr2)
else
    System.out.println(expr1)

emp 테이블에서 comm 컬러의 값이 NULL 일 경우 0으로 대체해서 조회하기

SELECT empno, sal, comm, sal + comm, sal + NVL(comm, 0) NVL1, NVL(sal+comm , 0) NVL2 
FROM emp;
--NVL1과 NVL2의 차이에 주의! null을 0으로 치환하는 순서가 연산에 있어 중요하다.
-- null의 연산값은 무조건 null이다.

NVL2(expr1, expr2, expr3)
if(expr1 != null)
    System.out.println(expr2);
else
    System.out.println(expr3);

--comm이 null이 아니면 sal+comm을 반환,
--comm이 null이면 sal 반환

SELECT NVL2(comm, sal+comm, sal) NVL2
FROM emp;

NULLIF(expr1, expr2)
if(expr1 == expr2)
    System.out.println(null)
else
    System.out.println(expr1)
    

SELECT empno, sal, NULLIF(sal, 1250) -- 실제 쓸 일이 거의 없음
FROM emp;
    
COALESCE(expr1, expr2, expr3....) -- null이 아닌게 나올때까지 retry 재귀함수 리컨시브 콜?
인자들 중에 가장 먼저 등장하는 null이 아닌 인자를 반환

if(expr1 != null)
    System.out.println(expr1);
else
    COALESCE(expr2, expr3....);
    
function ( null 실습 fn4)
emp 테이블의 정보를 다음과 같이 조회되도록 쿼리를 작성하세요

SELECT empno, ename, mgr, NVL(mgr, 9999) MGR_N, NVL2(mgr, mgr, 9999) MGR_N_1, COALESCE(mgr, 9999) MGR_N_2
FROM emp;

function ( null 실습 fn5)
    users 테이블의 정보를 다음과 같이 조회되도록 쿼리를 작성하세요
    reg_dt가 null일 경우 sysdate를 적용
    
SELECT userid, usernm, NVL(reg_dt, SYSDATE)
FROM users
WHERE userid in('cony','sally','james','moon');

조건분기
1. CASE 절
    CASE expr1 비교식(참거짓을 판단 할수 있는 수식) THEN 사용할 값 => if
    CASE expr2 비교식(참거짓을 판단 할수 있는 수식) THEN 사용할 값 => else if
    CASE expr3 비교식(참거짓을 판단 할수 있는 수식) THEN 사용할 값 => else if
    ELSE 사용할 값4                                            => else
   END


2. DECODE 함수 => COALESCE 함수 처럼 가변인자 사용
    DEOCDE(expr1,
                search1, return1,
                search2, return2,
                search3, return3,
                ......[, DEFAULT])
                
if (expr1 == search1)
    System.out.println(return1)
else if(expr1 == search2)
    System.out.println(retrun2)
else if(expr1 == search2)
    System.out.println(retrun2)
else
    System.out.println(DEFAULT)
--대소비교가 아니라 무조건 동등하다. 대소비교는 DECODE절로는 불가능. 근데 보통 동등비교를 많이 씀



직원들의 급여를 인상하려고 한다.
job이 SALESMAN 이면 현재 급여에서 5%를 인상
job이 MANAGER 이면 현재 급여에서 10%를 인상
job이 PRESIDENT 이면 현재 급여에서 20%를 인상
그 이외의 직군은 현재 급여를 유지

SELECT ename, job, sal,  --, 인상된 급여
    CASE
        WHEN job = 'SALESMAN' THEN sal * 1.05
        WHEN job = 'MANAGER' THEN sal * 1.10
        WHEN job = 'PRESIDENT' THEN sal * 1.20
        ELSE SAL * 1.0
    END SAL_BONUS,
    DECODE(job, 'SALESMAN', sal * 1.05,
                'MANAGER', sal * 1.10,
                'PRESIDENT', sal * 1.20,
                sal * 1.0) sal_bonus_decode
FROM emp;

condition 실습 cond1

emp 테이블을 이용하여 deptno에 따라 부서명으로 변경해서 다음과 같이 조회되는 쿼리를 작성하세요
SELECT empno, ename, deptno,
        CASE
            WHEN deptno = 10 THEN 'ACCOUNTING'
            WHEN deptno = 20 THEN 'RESEARCH'
            WHEN deptno = 30 THEN 'SALES'
            WHEN deptno = 40 THEN 'OPERATIONS'
            ELSE 'DDIT'
        END DNAME
FROM emp
ORDER BY deptno ASC;

condition 실습 cond2
    emp 테이블을 이용하여 hiredate에 따라 올해 건강보험 검진 대상자인지 조회하는 쿼리를 작성하세요.
    (생년을 기준으로 하나 여기서는 입사년도를 기준으로 한다)
    
SELECT empno, ename, TO_CHAR(hiredate, 'YY/MM/DD') hiredate,
    DECODE(MOD(TO_NUMBER(TO_CHAR(hiredate,'YYYY')), 2) , MOD(TO_NUMBER(TO_CHAR(SYSDATE,'YYYY')), 2), '건강검진 대상자', '건강검진 비대상자')
    CONTACT_TO_DOCTOR
FROM emp;
--TO_CHAR까지만하고 바로 MOD를 해도 묵시적형변환을 해서 나눠진다 TO_NUMBER 안해도 됨

















    



