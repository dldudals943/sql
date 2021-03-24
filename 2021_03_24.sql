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
WHERE deptno = (SELECT deptno
                FROM emp
                WHERE ename ='SMITH');

DESC emp;





