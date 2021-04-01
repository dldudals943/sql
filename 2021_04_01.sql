오늘부터 선생님 바뀜

view는 table과 유사한 객체
view는 독립적으로 테이블처럼 존재

view를 이용하는 경우
    필요한 정보가 한 개에 테이블에 있지 않고, 여러 개의 테이블에 분산
    자료의 일부분만 필요
    특정 자료에 대한 접근을 제한하고자 할 경우(보안)
    
CREATE 생성
DROP 삭제

index파일은 적당히 만들어야함

    - table과 유사한 기능 제공
    - 보안, query 실행의 효율성, table의 은닉성을 위하여 사용
    (사용형식)
    
    CREATE [OR REPLACE][FORCE | NOFORCE] VIEW 뷰이름[(컬럼LIST)]
    AS
        SELECT 문;
        [WITH CHECK OPTION;]
        [WITH READ ONLY;]

 -'OR REPLACE' :  뷰가 존재하면 대치되고 없으면 신규로 생성
 -'FORCE' : 원본 테이블의 존재하지 않아도 뷰를 생성(FORCE), 생성불가(NOFORCE)
 -'컬럼LIST' : 생성된 뷰의 컬럼명
 -'WITH CHECK OPTION' : SELECT문의 조건절에 위배되는 DML명령 실행 거부
 -'WITH READ ONLY' : 읽기전용 뷰 생성
 
 with check option 과 with read only를 동시에 사용할 수 없다
 
 사용예) 사원테이블에서 부모부서코드가 90번부서에 속한 사원정보를 조회하시오.
    조회할 데이터 : 사원번호, 사원명, 부서명, 급여
    
 사용예) 회원테이블에서 마일리지가 3000이상인 회원의 회원번호, 회원명, 직업, 마일리지를
    조회하시오
    
    SELECT mem_id 회원번호, mem_name 회원명, mem_job 직업, mem_mileage 마일리지
    FROM member
    WHERE mem_mileage >= 3000
 

=> 뷰생성
    CREATE OR REPLACE VIEW V_MEMBER01
    AS
        SELECT mem_id 회원번호, mem_name 회원명, mem_job 직업, mem_mileage 마일리지
          FROM member
         WHERE mem_mileage >= 3000;
 
 SELECT *
 FROM V_MEMBER01
 
 (신용환회원의 자료 검색)
 SELECT MEM_NAME, MEM_JOB, MEM_MILEAGE
   FROM MEMBER
  WHERE UPPER(MEM_ID) = 'C001'; --칠거지악
 
 (MEMBER 테이블에서 신용환의 마일리지를 10000으로 변경)
 UPDATE MEMBER
 SET MEM_MILEAGE=10000
 WHERE MEM_NAME = '신용환';
 
 (V_MEMBER01 테이블에서 신용환의 마일리지를 10000으로 변경)
 UPDATE V_MEMBER01
 SET 마일리지=500
 WHERE 회원명 = '신용환';
 

 table에서 수정한건 view에서도 반영됨
 view에서 수정한 것도 table에도 반영됨
 view업데이트 결과도 view의 조건을 반영되어 업데이트됨
 
 모델링이 어렵다
 창(W)에서 팩토리 설정으로 초기화 누르면 윈도우 초기화됨
 
CREATE OR REPLACE VIEW V_MEMBER01(MID,MNAME,MJOB,MILE)
     AS
        SELECT mem_id 회원번호, mem_name 회원명, mem_job 직업, mem_mileage 마일리지
          FROM member
         WHERE mem_mileage >= 3000
WITH CHECK OPTION
--WITH READ ONLY; --SQL command not properly ended

ROLLBACK;

SELECT *
FROM MEMBER;

SELECT *
FROM V_MEMBER01

VIEW를 생성할때, view 에서 컬럼명을 만들어 주는게 1순위, 원본 테이블의 별칭이 2순위, 원본 테이블 컬럼명이 3순위이다.

(뷰 V_MEMBER01 에서 신용환 회원의 마일리지를 2000으로 변경)
UPDATE V_MEMBER01
SET MILE = 2000
WHERE UPPER(MID) = 'C001';

WITH CHECK OPTION 에 걸려서 3000밑으로 떨어뜨릴 수가 없다.

UPDATE MEMBER
SET MEM_MILEAGE = 2000
WHERE UPPER(MEM_ID) = 'C001';

하지만 테이블의 변경은 자유롭다.

SELECT *
FROM V_MEMBER01;

테이블 변경 후, 뷰에 적용된다.

CREATE OR REPLACE VIEW V_MEMBER01(MID,MNAME,MJOB,MILE)
     AS
        SELECT mem_id 회원번호, mem_name 회원명, mem_job 직업, mem_mileage 마일리지
          FROM member
         WHERE mem_mileage >= 3000
WITH READ ONLY; 

ROLLBACK;


SELECT *
FROM V_MEMBER01;

롤백을 했는데도 변경자료 결과가 유지되어있다.

UPDATE V_MEMBER01 SET MILE = 5700
WHERE MID = 'k001'

당연하게도 WITH READ ONLY(읽기전용) 라고 했기 때문에 뷰에서는 수정이 불가능하다.

------------------------------hr 계정에 있는 테이블 사용--------------------------------

SELECT HR.DEPARTMENTS.DEPARTMENT_ID, DEPARTMENT_NAME
FROM HR.DEPARTMENTS;

-------------------------- 권한가지고 귀찮게구니까 그냥 hr 계정으로 하는 걸 추천----------
---아니면 그냥 grant 하던지-----------------------------------------------------------

문제 01-02
HR계정의 사원테이블 employees에서 50번 부서에 속한 사원 중 급여가
5000이상이 사원번호,사원명,입사일,급여 읽기 전용 뷰로 생성
뷰 이름은 v_emp_sal01이고 컬럼명은 원본 테이블을 사용
뷰가 생성된 후 해당 사원의 사원번호 사원명 직무명 급여를 출력

CREATE SYNONYM DEPARTMENTS FOR HR.DEPARTMENTS -- 이걸 하게 되면 별칭을 지정하여 hr계정이 아닌 다른 계정에서도 좀 편하게 불러올 수 있습니다.
----------------

CREATE OR REPLACE VIEW v_emp_sal01
AS
SELECT employee_id, first_name, last_name, hire_date, salary
FROM hr.employees
WHERE salary >= 5000 AND department_id=50
WITH READ ONLY

---------------------------------------------------------------------------------------

사원번호는 employee_id
사원명은 first_name(이름), last_name(성)
입사일은 hire_date

SELECT *
FROM hr.employees

SELECT v_emp_sal01.employee_id, v_emp_sal01.first_name, v_emp_sal01.last_name, v_emp_sal01.hire_date,  employees.job_id, jobs.job_title, v_emp_sal01.salary
  FROM v_emp_sal01, employees, jobs
 WHERE v_emp_sal01.employee_id = employees.employee_id
   AND employees.job_id = JOBS.JOB_ID;

----------------------------------------------------------------------------------------











