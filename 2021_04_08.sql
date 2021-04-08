2021-04-08

저장프로시져(STORED PROCEDURE: PROCEDURE)

    - 특정 결과를 산출하기 위한 코드의 집합(모듈)
    - 반환값이 없음
    - 컴파일되어 서버에 보관(실행속도를 증가, 은닉성, 보안성)
    (사용형식)

CREATE [OR REPLACE] PROCEDURE 프로시져명[(
        매개변수명 [IN | OUT | INOUT] 데이터타입 [[:= | DEFAULT] expr],
        매개변수명 [IN | OUT | INOUT] 데이터타입 [[:= | DEFAULT] expr],
        :
        :
        매개변수명 [IN | OUT | INOUT] 데이터타입 [[:= | DEFAULT] expr])]
    AS | IS
        선언영역;
    BEGIN
        실행영역;
    END;
    
사용예) 오늘이 2005년 1월 31일이라고 가정하고 오늘까지 발생된 상품입고 정보를 이용하여
    재고 수불테이블을 update하는 프로시져를 생성하시오
    
    1. 프로시저명 : PROC_REMAIN_IN
    2. 매개변수 : 상품코드, 매입수량
    3. 처리 내용 : 해당 상품코드에 대한 입고수량, 현재고수량, 날짜 UPDATE;
    
**  1. 2005년 상품별 매입수량 집계 -- 프로시져 밖에서 처리
    2. 1의 결과 각 행을 PROCEDURE에 전달
    3. PROCEDURE에서 재고 수불테이블 UPDATE
    
(PROCEDURE 생성)

CREATE OR REPLACE PROCEDURE PROC_REMAIN_IN(
    P_CODE IN PROD.PROD_ID%TYPE,
    P_CNT IN NUMBER)
IS
BEGIN
    UPDATE REMAIN
       SET (REMAIN_I, REMAIN_J_00, REMAIN_DATE) = (SELECT REMAIN_I + P_CNT,
                                                   REMAIN_J_00 + P_CNT,
                                                  TO_DATE('20050131')
                                                     FROM REMAIN
                                                    WHERE REMAIN_YEAR = '2005'
                                                      AND PROD_ID = P_CODE)
     WHERE REMAIN_YEAR = '2005'
       AND PROD_ID = P_CODE;     
END;
    
SELECT *
FROM remain;

(테이블 컬럼명 변경)
ALTER TABLE 테이블명
    RENAME COLUMN 변경대상컬럼명 TO 변경컬럼명;
EX) TEMP 테이블의 ABC를  QAZ라는 컬럼명으로 변경
    ALTER TABLE TEMP
        RENAME COLUMN ABC TO QAZ;
        
(컬럼 데이터타입(크기) 변경
ALTER TABLE 테이블명
    MODIFY 컬럼명 데이터타입(크기);
EX) TEMP 테이블의 ABC 컬럼을 NUMBER(10)으로 변경하는 경우
ALTER TABLE TEMP
    MODIFY ABC NUMBER(10);
    -- 해당 컬럼의 내용을 모두 지워야 변경 가능    

프로시져 실행명령
    EXEC|EXECUTE 프로시져명[(매개변수 list)];
    
    -단, 익명블록 등 또 다른 프로시져나 함수에서 프로시져 호출시 'EXEC|EXECUTE'는 생략
    
2005년 1월 상품별 매입집계)
SELECT BUY_PROD,
        SUM(BUY_QTY)
FROM BUYPROD
WHERE BUY_DATE BETWEEN '20050101' AND '20050131'
GROUP BY BUY_PROD;

----------------------------------------------
DECLARE
CURSOR CUR_BUY_AMT
IS
    SELECT BUY_PROD BCODE,
           SUM(BUY_QTY) BAMT
      FROM BUYPROD
     WHERE BUY_DATE BETWEEN '20050101' AND '20050131'
  GROUP BY BUY_PROD;

BEGIN
    FOR REC01 IN CUR_BUY_AMT LOOP
        PROC_REMAIN_IN(REC01.BCODE, REC01.BAMT);
    END LOOP;
END;

**REMAIN 테이블의 내용을 VIEW로 구성
CREATE OR REPLACE VIEW V_REMAIN01
AS
    SELECT * FROM REMAIN;

SELECT *
FROM V_REMAIN01;

SELECT *
FROM REMAIN;

사용예) 회원아이디를 입력 받아 그 회원의 이름, 주소와 직업을 반환하는
    프로시져를 작성하시오
    1. 프로시져명 : PROc_MEM_INFO
    2. 매개변수 : 입력용 : 회원아이디
                 출력용 : 이름, 주소, 직업
                 
(프로시져 생성)
CREATE OR REPLACE PROCEDURE PROC_MEM_INFO(
    P_ID IN MEMBER.MEM_ID%TYPE,
    P_NAME OUT MEMBER.MEM_NAME%TYPE,
    P_ADDR OUT VARCHAR2,
    P_JOB OUT MEMBER.MEM_JOB%TYPE)
AS
BEGIN
    SELECT MEM_NAME, MEM_ADD1 ||' '||MEM_ADD2, MEM_JOB
    INTO P_NAME, P_ADDR,P_JOB
    FROM MEMBER
    WHERE MEM_ID=P_ID;
END;

SELECT *
FROM MEMBER;

(실행)

ACCEPT PID PROMPT '회원아이디 : '
DECLARE
    V_NAME MEMBER.MEM_NAME%TYPE;
    V_ADDR VARCHAR2 (200);
    V_JOB MEMBER.MEM_JOB%TYPE;
BEGIN
    PROC_MEM_INFO(LOWER('&PID'), V_NAME, V_ADDR, V_JOB);
    DBMS_OUTPUT.PUT_LINE('회원아이디 : ' || '&PID');
    DBMS_OUTPUT.PUT_LINE('회원이름 : ' || V_NAME);
    DBMS_OUTPUT.PUT_LINE('회원주소 : ' || V_ADDR);
    DBMS_OUTPUT.PUT_LINE('회원직업 : ' || V_JOB);
END;


SELECT *
FROM MEMBER

SELECT *
FROM CART

SELECT *
FROM
(SELECT CART_MEMBER, MEMBER.MEM_NAME, SUM(CART.CART_QTY*PROD.PROD_PRICE)
FROM PROD, CART, MEMBER
WHERE SUBSTR(CART_PROD,0,4)=PROD_LGU
AND CART_MEMBER = MEMBER.MEM_ID
AND SUBSTR(CART_NO,0,4) = '2005'
GROUP BY CART.CART_MEMBER, MEMBER.MEM_NAME
ORDER BY SUM(CART.CART_QTY*PROD.PROD_PRICE) DESC)
WHERE ROWNUM = 1;



문제] 년도를 입력 받아 해당연도에 구매를 가장 많이한 회원이름과 구매액을
    반환하는 프로시져를 작성하시오.
    
    1. 프로시져명 : PROC_MEM_PTOP
    2. 매개변수 : 입력용 : 년도
                 출력용 : 회원명, 구매액
                 
CREATE OR REPLACE PROCEDURE PROC_MEM_PTOP(
    P_YEAR IN NUMBER,
    P_NAME OUT VARCHAR2,
    P_AMT OUT NUMBER)
AS
BEGIN
    SELECT NAME1, AMT INTO P_NAME, P_AMT 
    FROM
    (SELECT CART_MEMBER ID1, MEMBER.MEM_NAME NAME1, SUM(CART.CART_QTY*PROD.PROD_PRICE) AMT
    FROM PROD, CART, MEMBER
    WHERE CART_PROD=PROD_ID
    AND CART_MEMBER = MEMBER.MEM_ID
    AND SUBSTR(CART_NO,1,4) = P_YEAR
    GROUP BY CART.CART_MEMBER, MEMBER.MEM_NAME
    ORDER BY SUM(CART.CART_QTY*PROD.PROD_PRICE) DESC)
    WHERE ROWNUM = 1;
    
END;
    
DECLARE
    P_NAME VARCHAR2(10);
    P_AMT NUMBER:=0;
BEGIN
    PROC_MEM_PTOP(2005, P_NAME, P_AMT);
    dbms_output.put_line(P_NAME || ' : ' ||P_AMT);
END;

**2005년도 회원별 구매금액을 계산
SELECT C.CART_MEMBER, SUM(C.CART_QTY*P.PROD_PRICE)
FROM CART C, PROD P
WHERE C.CART_PROD = P.PROD_ID
GROUP BY C.CART_MEMBER
ORDER BY 2 DESC;


----------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------

문제] 2005년도 구매금액이 없는 회원을 찾아 회원테이블 (MEMBER)의 삭제여부 컬럼 (MEM_DELETE)
     컬럼(MEM_DELETE)의 값을 'Y'로 변경하는 프로시져를 작성하시오.
     
----------------------------------------------------------------------------------------------

SELECT MEM_ID
FROM MEMBER
WHERE MEM_ID NOT IN (SELECT CART_MEMBER
                      FROM CART 
                     WHERE SUBSTR(CART_NO,1,4)=2005)

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