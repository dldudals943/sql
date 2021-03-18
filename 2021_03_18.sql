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
       ADD_MONTHS(SYSDATE, 5),
       ADD_MONTHS(TO_DATE('2021-02-15','YYYY-MM-DD'), 5)
FROM emp;

SELECT TO_DATE('2021','YYYY') -- 이 경우 서버의 현재시간의 월과 그 월에 첫번째 날짜
FROM dual;

SELECT TO_DATE('2021' || '0101' , 'YYYYMMDD')
FROM dual;