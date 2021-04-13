2021-0413-01) 패키지 (Package)

 - 논리적 연관성 있는 PL/SQL타입, 변수, 상수, 함수, 프로시져 등의
    항목들을 묶어 놓은 것
 - 모듈화, 캡슐화 기능 제공
 - 관련성있는 서브프로그램의 집합으로 DISK I/O 이 줄어 효율적
 
 1. Package 구조
    - 서언부와 본문부로 구성
    1) 선언부
        - 패키지에 포함될 변수, 프로시져, 함수 등을 선언
    (사용형식)
    
 CREATE [OR REPLACE] PACKAGE 패키지명
 IS|AS
    TYPE 구문;
    상수[변수] 선언문;
    커서;
    함수|프로시져 프로토타입;
            :
 END 패키지명;
 
    2) 본문부
        - 선언부에서 정의한 서브프로그램의 구현 담당
        (사용형식)
 CREATE [OR REPLACE] PACKAGE 패키지명
 IS|AS
    상수, 커서, 변수 선언;
    
    FUNCTION 함수명(매개변수 list)
        RETURN 타입명
    BEGIN
        PL/SQL 명령(들);
        RETURN expr;
    END 함수명;
        :
    
 END 패키지명;
 
사용예) 상품테이블에 신규 상품을 등록하는 업무를 패키지로 구성하시오
    분류코드확인->상품코드생성->상품테이블에 등록->재고수불테이블 등록
    
패키지 선언부
CREATE OR REPLACE PACKAGE PROD_NEWITEM_PKG
IS
    V_PROD_LGU LPROD.LPROD_GU%TYPE;
    --분류코드 생성
    FUNCTION PROC_INSERT_LPORD(
        P_GU LPROD.LPROD_GU%TYPE,
        P_NM LPROD.LPROD_NM%TYPE)
        RETURN LPROD.LPROD_GU%TYPE;
    --상품코드 생성 및 상품 등록
    PROCEDURE PROC_CREATE_PROD_ID(
        P_GU IN LPROD.LPROD_GU%TYPE,
        P_NAME IN PROD.PROD_NAME%TYPE,
        P_BUYER IN PROD.PROD_BUYER%TYPE,
        P_COST IN NUMBER,
        P_PRICE IN NUMBER,
        P_SALE IN NUMBER,
        P_OUTLINE IN PROD.PROD_OUTLINE%TYPE,
        P_IMG IN PROD.PROD_IMG%TYPE,
        P_TOTALSTOCK IN PROD.PROD_TOTALSTOCK%TYPE,
        P_PROPERSTOCK IN PROD.PROD_PROPERSTOCK%TYPE);
    --재고수불테이블 삽입
    PROCEDURE PROC_INSERT_REMAIN(
        P_YEAR IN VARCHAR2,
        P_ID IN PROD.PROD_ID%TYPE,
        P_AMT IN NUMBER);
        
END PROD_NEWITEM_PKG;

(패키지 본문 생성)
CREATE OR REPLACE PACKAGE PROD_NEWITEM_PKG
IS
    P_LPROD_GU LPROD.LPORD_GU%TYPE;
    P_PROD_ID PROD.PROD_ID%TYPE;
    
    FUNCTION FN_INSERT_LPROD(
        P_GU IN LPROD.LPROD_GU%TYPE,
        P_NM IN LPROD.LPROD_NM%TYPE)
        RETURN LPROD.LPROD_GU%TYPE
    IS
        V_ID NUMBER:=0;
    BEGIN
        SELECT MAX(LPROD
        
-- 이후 필기를 포기합니다.
    