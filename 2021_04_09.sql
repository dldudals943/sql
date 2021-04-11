문제] 2005년도 구매금액이 없는 회원을 찾아 회원테이블 (MEMBER)의 삭제여부 컬럼 (MEM_DELETE)
      컬럼(MEM_DELETE)의 값을 'Y'로 변경하는 프로시져를 작성하시오.
     
----------------------------------------------------------------------------------------------

CREATE OR REPLACE PROCEDURE DELETE_MEMBER(
    P_YEAR IN NUMBER)
AS
BEGIN
    FOR AR IN (SELECT MEM_ID
                FROM MEMBER
                WHERE MEM_ID NOT IN (SELECT CART_MEMBER
                                     FROM CART 
                                    WHERE SUBSTR(CART_NO,1,4)=P_YEAR))
    LOOP
    UPDATE MEMBER SET MEM_DELETE = 'Y' WHERE MEM_ID = AR.MEM_ID;
    END LOOP;
            
END;

----------------------------------------------------------------------------------------------

ACCEPT YEAR PROMPT '년도'
BEGIN
    DELETE_MEMBER(&YEAR);
END;

----------------------------------------------------------------------------------------------

-- 선생님 답. 일단 프로시저를 만든다.
CREATE OR REPLACE PROCEDURE PROC_MEM_UPDATE(
    P_MID IN MEMBER.MEM_ID%TYPE)
AS

BEGIN
    UPDATE MEMBER
       SET MEM_DELETE='Y'
     WHERE MEM_ID=P_MID;
     
     COMMIT;
END;

----------------------------------------------------
(구매금액이 없는 회원)
DECLARE
    CURSOR CUR_MID
    IS
        SELECT MEM_ID
          FROM MEMBER
         WHERE MEM_ID NOT IN (SELECT CART_MEMBER
                                FROM CART
                               WHERE CART_NO LIKE '2005%'
                            GROUP BY CART_MEMBER)
BEGIN
    FOR REC_MID IN CUR_MID
    PROC_MEM_UPDATE(REC_MID.MEM_ID);
    END LOOP;
END;

--------------------------------------------------------------------------------------------

USER DEFINED FUNCTION(FUNCTION)
- 사용자가 정의한 함수
- 반환값이 존재
- 자주 사용되는 복잡한 query등을 모듈화 시켜 컴파일한 후 호출하여 사용
(사용형식)
CREATE [OR REPLACE] FUNCTION 함수명[(
    매개변수 [IN|OUT|INOUT] 데이터타입 [(:=|DEFAULT) expr][,]
    
    매개변수 [IN|OUT|INOUT] 데이터타입 [(:=|DEFAULT) expr])
    RETURN 데이터타입
AS|IS
    선언영역; -- 변수, 상수, 커서
BEGIN
    실행문;
    RETURN 변수 | 수식;
    [EXCEPTION
        예외처리문;]
END;

사용예) 장바구니 테이블에서 2005년 6월 5일 판매된 상품코드를 입력 받아
       상품명을 출력하는 함수를 작성하시오.
       1. 함수명 : FN_PNAME_OUTPUT
       2. 매개변수 : 입력용 : 상품코드
       3. 반환값 : 상품명
       
(함수 생성)
CREATE OR REPLACE FUNCTION FN_PNAME_OUTPUT(
    P_CODE IN PROD.PROD_ID%TYPE)
    RETURN VARCHAR2
IS
    V_PNAME PROD.PROD_NAME%TYPE;
BEGIN
    SELECT PROD_NAME INTO V_PNAME
    FROM PROD
    WHERE PROD_ID = P_CODE;
    
    RETURN V_PNAME;
END;

SELECT *
FROM PROD;

SELECT CART_MEMBER, FN_PNAME_OUTPUT(CART_PROD)
FROM CART
WHERE CART_NO LIKE '20050605%'

사용예) 2005년 5월 모든 상품에 대한 매입현황을 조회하시오
        Alias는 상품코드, 상품명, 매입수량, 매입금액
        

SELECT B.PROD_ID AS 상품코드,
       B.PROD_NAME AS 상품명,
       SUM(A.BUY_QTY) AS 매입수량,
       SUM(A.BUY_QTY*B.PROD_COST) AS 매입금액
  FROM BUYPROD A, PROD B
 WHERE A.BUY_PROD(+) = B.PROD_ID 
 AND A.BUY_DATE BETWEEN '20050501' AND '20050531'
 GROUP BY B.PROD_ID, B.PROD_NAME
 
 --WHERE 절에서 일반조건을 AND로 써서 오라클 문법의 아우터 조인이 동작하지 않는다.
 
 
SELECT B.PROD_ID AS 상품코드,
       B.PROD_NAME AS 상품명,
       NVL(SUM(A.BUY_QTY),0) AS 매입수량,
       NVL(SUM(A.BUY_QTY*B.PROD_COST),0) AS 매입금액
  FROM BUYPROD A RIGHT OUTER JOIN PROD B ON (A.BUY_PROD = B.PROD_ID 
                                            AND A.BUY_DATE BETWEEN '20050501' AND '20050531')
 GROUP BY B.PROD_ID, B.PROD_NAME;
 
 (서브쿼리)
 SELECT B.PROD_ID AS 상품코드,
        B.PROD_NAME AS 상품명,
        NVL(A.QAMT,0) AS 구입수량,
        NVL(A.HAMT,0) AS 구입금액
 FROM (SELECT BUY_PROD AS BID,
            SUM(BUY_QTY) AS QAMT,
            SUM(BUY_QTY*BUY_COST) AS HAMT
       FROM BUYPROD 
      WHERE BUY_DATE BETWEEN '20050501' AND '20050531'
   GROUP BY BUY_PROD) A, PROD B
   WHERE A.BID(+) = B.PROD_ID;
   
(함수)
CREATE OR REPLACE FUNCTION FN_BUYPROD_AMT(
    P_CODE IN PROD.PROD_ID%TYPE)
    RETURN VARCHAR2
IS
    V_RES VARCHAR2(100); -- 매입 수량과 매입 금액을 문자열로 변환하여 기억
    V_QTY NUMBER:=0; -- 매입수량 합계
    V_AMT NUMBER:=0; -- 매입금액 합계

BEGIN
    SELECT SUM(BUY_QTY), SUM(BUY_QTY*BUY_COST) INTO V_QTY, V_AMT
    FROM BUYPROD
    WHERE BUY_PROD = P_CODE
    AND BUY_DATE BETWEEN '20050501' AND '20050531';
    
    IF V_QTY IS NULL THEN
       V_RES:='0';
    ELSE
    V_RES := '수량'||TO_CHAR(V_QTY,'9,999')||',  구매금액'||TO_CHAR(V_AMT,'99,999,999');
    END IF;
    RETURN V_RES;
END;
 
SELECT PROD_ID AS 상품코드,
       PROD_NAME AS 상품명,
       FN_BUYPROD_AMT(PROD_ID) AS 구매확인
FROM PROD;

CREATE OR REPLACE FUNCTION FN_BUYPROD_AMT(
    P_CODE IN PROD.PROD_ID%TYPE)
    RETURN VARCHAR2
IS
    V_RES VARCHAR2(100); -- 매입 수량과 매입 금액을 문자열로 변환하여 기억
    V_QTY NUMBER:=0; -- 매입수량 합계
    V_AMT NUMBER:=0; -- 매입금액 합계

BEGIN
    SELECT NVL(SUM(BUY_QTY),0), NVL(SUM(BUY_QTY*BUY_COST),0) INTO V_QTY, V_AMT
    FROM BUYPROD
    WHERE BUY_PROD = P_CODE
    AND BUY_DATE BETWEEN '20050501' AND '20050531';
    
    
    V_RES := '수량'||TO_CHAR(V_QTY,'9,999')||',  구매금액'||TO_CHAR(V_AMT,'99,999,999');
    
    RETURN V_RES;
END;

    SELECT BUY_QTY, BUY_QTY*BUY_COST
    FROM BUYPROD
    WHERE BUY_PROD = 'P101000001'
    AND BUY_DATE BETWEEN '20050501' AND '20050531';

상품코드를 입력 받아 2005년도 평균판매횟수, 전체판매수량, 판매금액합계를
출력할 수 있는 함수를 작성하시오
1. 함수명 : FN_CART_QAVG 평균 판매 횟수,
           FN_CART_QAMT 전체 판매 수량,
           FN_CART_FAMT 판매 금액 합계
2. 매개변수 : 입력 : 상품코드, 년도

나머지는 알아서 해보기


CREATE OR REPLACE FUNCTION FN_CART_QAVG(
    P_CODE IN PROD.PROD_ID%TYPE,
    P_YEAR CHAR)
    RETURN NUMBER
IS
    V_RES NUMBER:=0; -- 매입 수량과 매입 금액을 문자열로 변환하여 기억
    V_QTY NUMBER:=0; -- 매입수량 합계
    V_YEAR CHAR(5):=P_YEAR||'%'; --년도

BEGIN
    SELECT NVL(AVG(BUY_QTY),0) INTO V_QTY
    FROM BUYPROD
    WHERE BUY_PROD = P_CODE
    AND BUY_DATE LIKE V_YEAR;
    
    V_RES := V_QTY;
    
    RETURN V_RES;
END;

SELECT PROD_ID AS 상품코드,
       PROD_NAME AS 상품명,
       FN_BUYPROD_AMT(PROD_ID) AS "2005년 5월 구매확인",
       FN_CART_QAVG(PROD_ID,'2005') AS "2005년 평균판매횟수"       
FROM PROD;

------------------------------------------------------------------------


CREATE OR REPLACE FUNCTION FN_CART_QAVG(
    P_CODE IN PROD.PROD_ID%TYPE,
    P_YEAR CHAR)
    RETURN NUMBER
IS
    V_RES NUMBER:=0; -- 매입 수량과 매입 금액을 문자열로 변환하여 기억
    V_QTY NUMBER:=0; -- 매입수량 합계
    V_YEAR CHAR(5):=P_YEAR||'%'; --년도

BEGIN
    SELECT NVL(AVG(CART_QTY),0) INTO V_QTY
    FROM CART
    WHERE CART_PROD = P_CODE
    AND CART_NO LIKE V_YEAR;
    
    V_RES := V_QTY;
    
    RETURN V_RES;
END;

SELECT FN_CART_QAVG('P201000018', '2005')
FROM CART
WHERE CART_PROD = 'P201000018'

-------------------------------------------------------------------------------------------------------

[문제] 2005년 2~3월 제품별 매입수량(BUYPROD)을 구하여 재고수불테이블(REMAIN)을 UPDATE하시오
        처리일자는 2005년 3월 마지막일임-함수이용
        
    SELECT BUY_PROD , SUM(BUY_QTY)
    FROM BUYPROD
    WHERE BUY_DATE BETWEEN '20050201' AND '20050331'
    GROUP BY BUY_PROD;
    
    SELECT *
    FROM REMAIN
    
    UPDATE REMAIN SET REMAIN_J_00 = REMAIN_J_00 
    
DECLARE
    CURSOR REMAIN_UPDATE
    IS
    SELECT BUY_PROD A, SUM(BUY_QTY) B
    FROM BUYPROD
    WHERE BUY_DATE BETWEEN '20050201' AND '20050331'
    GROUP BY BUY_PROD;
    TEMP REMAIN_UPDATE%ROWTYPE;
BEGIN
    OPEN REMAIN_UPDATE;
    LOOP
    FETCH REMAIN_UPDATE INTO TEMP;
    EXIT  WHEN REMAIN_UPDATE%NOTFOUND;
    UPDATE REMAIN SET REMAIN_J_99 = REMAIN_J_99 + REMAIN_J_00 + TEMP.B,
                      REMAIN_I = REMAIN_I + TEMP.B,
                      REMAIN_DATE = LAST_DAY(TO_DATE('200503','YYYYMM'))
    WHERE PROD_ID = TEMP.A;
    DBMS_OUTPUT.PUT_LINE(TEMP.A || '에' || TEMP.B ||'만큼 제품 입고처리 완료');
    END LOOP;
    CLOSE REMAIN_UPDATE;
END;

SELECT LAST_DAY(TO_DATE('200503','YYYYMM'))
FROM DUAL;

SELECT *
FROM REMAIN;

ROLLBACK;


---------------------------------------------------------------------------------
트리거
    -   어떤 이벤트가 발생하면 그 이벤트의 발생 전, 후로 자동적으로 실행되는 코드블록 ( 프로시져의 일종)
    (사용형식)
    CREATE TRIGGER 트리거명
        (TIMING)BEFORE|AFTER (EVENT)INSERT|UPDATE|DELETE
        ON 테이블명
        [FOR EACH ROW]
        [WHEN 조건]
    [DECLARE
        변수, 상수, 커서;
    ]
    BEGIN
        명령문(들);--트리거 처리문
        [EXCEPTION
            예외처리문;
        ]
    END;
    
    'TIMING' : 트리거처리문 수행 시점 (BEFORE : 이벤트 발생전, AFTER : 이벤트 발생후)
    'EVENT' : 트리거가 발생될 원인 행위 (OR로 연결 사용 가능,ex) INSERT OR UPDATE OR DELETE)
    '테이블명' : 이벤트가 발생되는 테이블이름
    'FOR EACH ROW' : 행단위 트리거 발생, 생략되면 문장단위 트리거 발생
    WHEN 조건 : 행단위 트리거에서만 사용 가능, 이벤트가 발생될 세부 조건 추가 설정
    
rollback
commit;


select *
from emp


drop function FN_PANEM_OUTPUT;
commit;

SELECT *
FROM TB_JDBC_BOARD

DESC TB_JDBC_BOARD

--UPDATE EMP01 SET DEPTNO=30;
--INSERT INTO COMPANY_TABLE (COMPANY_CODE, COMPANY_NAME, SECTORS) 
--VALUES (1, '삼성전자', 'IT')
--DELETE FROM 테이블명
--WHERE 조건;

INSERT INTO TB_JDBC_BOARD (NO, USERS, TITLE, CONTENTS, DATETIME)
VALUES (1, 'LEE', 'START', 'CONTENTS IS BLANK', TO_DATE('2021-04-10','YYYY-MM-DD'));

INSERT INTO TB_JDBC_BOARD (NO, USERS, TITLE, CONTENTS, DATETIME)
VALUES (2, 'LEE', 'START', 'CONTENTS IS BLANK', TO_DATE('2021-04-11','YYYY-MM-DD'));

COMMIT;

UPDATE TB_JDBC_BOARD SET USERS = 'LEE'
WHERE NO = 2;

DELETE FROM TB_JDBC_BOARD
WHERE NO = 3;

DELETE FROM TB_JDBC_BOARD;

SELECT SYSDATE
FROM DUAL;