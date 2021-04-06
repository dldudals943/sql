 CREATE [OR REPLACE] SYNONYM 동의어 이름
        FOR 객체명;

CREATE OR REPLACE VIEW V_MAXAMT
AS    
SELECT *
FROM
   (SELECT A.CART_MEMBER 회원번호, B.MEM_NAME 회원명, SUM(PROD_PRICE*CART_QTY) 구매금액합
     FROM CART A, MEMBER B, PROD C
    WHERE A.CART_MEMBER = B.MEM_ID 
      AND A.CART_PROD = C.PROD_ID
 GROUP BY A.CART_MEMBER, B.MEM_NAME
 ORDER BY 3 DESC)
 WHERE ROWNUM = 1

SELECT *
FROM V_MAXAMT


DECLARE
    V_MID V_MAXAMT.회원번호%TYPE;
    V_NAME V_MAXAMT.회원명%TYPE;
    V_AMT V_MAXAMT.구매금액합%TYPE;
    V_RES VARCHAR2(100);
BEGIN
    SELECT 회원번호, 회원명, 구매금액합 INTO V_MID, V_NAME, V_AMT
    FROM V_MAXAMT;
    
    V_RES := V_MID ||', ' || V_NAME || ', ' || TO_CHAR(V_AMT,'99,999,999');
    
    DBMS_OUTPUT.PUT_LINE(V_RES);
END;


(상수사용예)
키보드로 수 하나를 입력 받아 그 값을 반지름으로 하는 원의 넓이를 구하시오

ACCEPT P_NUM PROMPT '원의 반지름 : '
DECLARE
    V_RADIUS NUMBER := TO_NUMBER('&P_NUM');
    V_PI CONSTANT NUMBER := 3.141592;
    V_RES NUMBER := 0;
BEGIN
    V_RES := V_RADIUS * V_RADIUS * V_PI;
    DBMS_OUTPUT.PUT_LINE('원의 너비 = ' || V_RES);
END;


---------------------------------------------------------------------
커서(CURSOR)

    - 커서는 쿼리문의 영향을 받은 행들의 집합
    - 묵시적커서(IMPLICITE), 명시적(EXPLICITE)커서로 구분
    - 커서의 선언은 선언부에서 수행
    - 커서의 OPEN, FETCH, CLOSE는 실행부에서 기술
    1) 묵시적 커서
        - 이름이 없는 커서
        - 항상 CLOSE 상태이기 때문에 커서대로 접근 불가능
        (커서 속성)
    --------------------------------------------------------------------
    속성              의미
    ---------------------------------------------------------------------
    SQL%ISOPEN      커서가 OPEN 되었으면 참(TRUE)반환 묵시적커서는 항상 FALSE
    SQL%NOTFOUND    커서내에 읽을 자료가 없으면 TRUE로 반환
    SQL%FOUND       커서내에 읽을 자료가 남아있으면 TRUE 반환
    SQL%COUNT       커서내 자료의 수 반환
    -------------------------------------------------------------------------
    2) 명시적 커서
        - 이름이 있는 커서
        - 생성 -> OPEN -> FETCH-> CLOSE 순으로 처리해야함(단 FOR문은 예외)
        
    (1) 생성
        (사용형식)
        CURSOR 커서명[(매개변수 list)]
        IS
            SELECT 문:
        사용예) 상품매일테이블(BUYPROD)에서 2005년 3월 상품별 매입현황 (상품코드, 상품명, 거래처명, 매입수량)
            을 출력하는 쿼리를 커서를 사용하여 작성하시요.
            
SELECT *
FROM BUYPROD
ORDER BY BUY_DATE DESC;

DECLARE
    V_PCODE PROD.PROD_ID%TYPE;
    V_PNAME PROD.PROD_NAME%TYPE;
    V_BANME BUYER.BUYER_NAME%TYPE;
    V_AMT NUMBER:=0;
    
    CURSOR CUR_BUY_INFO IS
        SELECT BUY_PROD,
               SUM(BUY_QTY)
          FROM BUYPROD
          WHERE BUY_DATE BETWEEN '20050301' AND '20050331'
          GROUP BY BUY_PROD;
BEGIN

END;

    (2) OPEN 문
    - 명시적 커서를 사용하기 전 커서를 OPEN
    (사용형식)
    OPEN 커서면[(매개변수list)];
    



DECLARE
    V_PCODE PROD.PROD_ID%TYPE;
    V_PNAME PROD.PROD_NAME%TYPE;
    V_BANME BUYER.BUYER_NAME%TYPE;
    V_AMT NUMBER:=0;
    
    CURSOR CUR_BUY_INFO IS
        SELECT BUY_PROD,
               SUM(BUY_QTY) ANT
          FROM BUYPROD
          WHERE BUY_DATE BETWEEN '20050301' AND '20050331'
          GROUP BY BUY_PROD;
BEGIN
    OPEN CUR_BUY_INFO;


END;

    (3) FETCH 문
        - 커서 내의 자료를 읽어오는 명령
        - 보통 반복문 내에 사용
        (사용형식)
        FETCH 커서명 INTO 변수명
        - 커서내의 컬럼값을 INTO 다음 기술된 변수에 할당
        


DECLARE
    V_PCODE PROD.PROD_ID%TYPE;
    V_PNAME PROD.PROD_NAME%TYPE;
    V_BNAME BUYER.BUYER_NAME%TYPE;
    V_AMT NUMBER:=0;
    
    CURSOR CUR_BUY_INFO IS
        SELECT BUY_PROD,
               SUM(BUY_QTY) ANT
          FROM BUYPROD
          WHERE BUY_DATE BETWEEN '20050301' AND '20050331'
          GROUP BY BUY_PROD;
BEGIN
    OPEN CUR_BUY_INFO;
    
    LOOP
        FETCH CUR_BUY_INFO INTO V_PCODE, V_AMT;
        EXIT WHEN CUR_BUY_INFO%NOTFOUND;
            SELECT PROD_NAME, BUYER_NAME INTO V_PNAME, V_BNAME
            FROM PROD, BUYER
            WHERE PROD_ID = V_PCODE
            AND PROD_BUYER = BUYER_ID;
        DBMS_OUTPUT.PUT_LINE('상품 코드 : '  || V_PCODE);
        DBMS_OUTPUT.PUT_LINE('상품명 : '  || V_PNAME);
        DBMS_OUTPUT.PUT_LINE('거래처명 : '  || V_BNAME);
        DBMS_OUTPUT.PUT_LINE('매입수량 : '  || V_AMT);
        DBMS_OUTPUT.PUT_LINE('-----------------------------------');
        DBMS_OUTPUT.PUT_LINE('자료수 : ' || CUR_BUY_INFO%ROWCOUNT);
    END LOOP;
    CLOSE CUR_BUY_INFO;
END;


---------------------------------------------------------------------------------

표준 SQL
SELECT PROD_NAME AS 상품명,
       PROD_COST AS 매입가격,
       PROD_MILEAGE AS 마일리지
FROM PROD
WHERE PROD_LGU ='P102';

(익명블록)
ACCEPT P_LCODE PROMPT '분류코드 : '
DECLARE
    V_PNAME PROD.PROD_NAME%TYPE;
    V_COST PROD.PROD_COST%TYPE;
    V_MILE PROD.PROD_MILEAGE%TYPE;
    
    CURSOR CUR_PROD_COST(P_LGU LPROD.LPROD_GU%TYPE)
    IS          
            SELECT PROD_NAME,
                   PROD_COST,
                   PROD_MILEAGE
            FROM PROD
            WHERE PROD_LGU = P_LGU;

BEGIN
    OPEN CUR_PROD_COST('&P_LCODE');
    DBMS_OUTPUT.PUT_LINE('상품명   '||'     단가       '||'마일리지');
    DBMS_OUTPUT.PUT_LINE('-------------------------------------------');
    LOOP
        FETCH CUR_PROD_COST INTO V_PNAME, V_COST, V_MILE;
        EXIT WHEN CUR_PROD_COST%NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(V_PNAME||'   '||V_COST||'    '||V_MILE);
    END LOOP;
    CLOSE CUR_PROD_COST;
END;

--------------------------------------------------------------------------------
조건문
 - 개발언어의 조건문(IF문)과 동일 기능 제공
 (사용형식)

 IF 조건식 THEN
    명령문1;
 [ELSE
    명령문2;]
 END IF;


 (사용형식2)
 
 IF 조건식 THEN
    명령문1;
 ELSIF 조건식2 THEN
    명령문2;
[ELSIF 조건식3 THEN
    명령문3;
    :
    :
 ELSE
    명령문 n;]
 END IF;
 
 (사용형식3)
 
 IF 조건식1 THEN
    명령문 1;
    IF 조건식2 THEN
        명령문2;
    ELSE
        명령문3;
    END IF;
 ELSE
    명령문 4;
 END IF;
 
사용예) 상품테이블에서 'P201'분류에 속한 상품들의 평균단가를 구하고
       해당 분류에 속한 상품들의 판매단가를 비교하여
       같으면 '평균가격 상품',
       적으면 '평균가격 이하 상품',
       많으면 '평균가격 이상 상품'을 출력하시오
       출력은 상품코드, 상품명, 가격, 비교이다.
       
DECLARE
    V_PCODE PROD.PROD_ID%TYPE;
    V_PNAME PROD.PROD_NAME%TYPE;
    V_PRICE PROD.PROD_PRICE%TYPE;
    V_REMARKS VARCHAR2(50);
    V_AVG_PRICE PROD.PROD_PRICE%TYPE;
    
    CURSOR CUR_PROD_PRICE
    IS
        SELECT PROD_ID, PROD_PRICE
        FROM PROD
        WHERE PROD_LGU = 'P201';
    
BEGIN
    SELECT ROUND(AVG(PROD_PRICE)) INTO V_AVG_PRICE
    FROM PROD
    WHERE PROD_LGU='P201';
    
    OPEN CUR_PROD_PRICE;
    LOOP
        FETCH CUR_PROD_PRICE INTO V_PCODE, V_PRICE;
        EXIT WHEN CUR_PROD_PRICE%NOTFOUND;
        IF V_PRICE > V_AVG_PRICE THEN
            V_REMARKS := '평균가격 이상 상품';
        ELSIF V_PRICE < V_AVG_PRICE THEN
            V_REMARKS := '평균가격 이하 상품';
        ELSE
            V_REMARKS := '평균가격 상품';
        END IF;
    DBMS_OUTPUT.PUT_LINE(V_PCODE||', '||V_PNAME||', '||V_PRICE||', '||V_REMARKS);
    END LOOP;
    CLOSE CUR_PROD_PRICE;
END;


---------------------------------------------------------------------------------------

2. CASE 문
    - JAVA의 SWITCH CASE문과 유사기능 제공
    - 다방향 분기 기능 제공
    (사용형식)
    
    CASE 변수명|수식
        WHEN 값 THEN
            명령1;
        WHEN 값 THEN
            명령2;
            :
            :
        ELSE
            명령n;
    END CASE;
    
    
    CASE WHEN 조건식1 
            THEN 명령1;
         WHEN 조건식2 
            THEN 명령2;
            :
            :
         ELSE
                 명령n;
     END CASE;
     
사용예) 수도요금 계산
        톤당 단가
        1 - 10 : 350원
       11 - 20 : 550원
       21 - 30 : 900원
        그 이상 : 1500원
    
        하수도 사용료
        사용량 * 450원
26톤 사용시 요금
    (10 * 350) + (10 * 550) + (6 * 900) + (26 * 450) = 
    26 * 450 은 하수도 사용료 나머지는 수도 요금이다
    
    
    
ACCEPT P_AMOUNT PROMPT '물 사용량'
DECLARE
    V_AMT NUMBER := TO_NUMBER('&P_AMOUNT');
    V_WA1 NUMBER := 0; -- 물사용요금
    V_WA2 NUMBER := 0; -- 하수도사용료
    V_HAP NUMBER := 0; -- 요금합계
BEGIN
    CASE WHEN V_AMT BETWEEN 1 AND 10 THEN
              V_WA1:=V_AMT*350;
         WHEN V_AMT BETWEEN 11 AND 20 THEN
              V_WA1:=(V_AMT-10)*550 + 10*350;
         WHEN V_AMT BETWEEN 21 AND 30 THEN
              V_WA1:=(V_AMT-20)*950+ 10*550 + 10*350;
         WHEN V_AMT > 30 THEN
              V_WA1:=(V_AMT-30)*1500 + 10*950 + 10*550 + 10*350;
    END CASE;
    
    V_WA2 := V_AMT*450;
    V_HAP := V_WA1+V_WA2;
    
    DBMS_OUTPUT.PUT_LINE(V_HAP);
END;
    
    