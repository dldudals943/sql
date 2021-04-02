2021-04-02

01)SEQUENCE 객체

 - 자동으로 증가되는 값을 반환할 수 있는 객체
 - 테이블에 독립적(다수의 테이블에서 동시 참조 가능)
 - 기본키로 설정할 적당한 컬럼이 존재하지 않는 경우 자동으로 증가되는
   컬럼의 속성으로 주로 사용됨
   (사용 형식)
   
   CREATE SEQUENCE 시퀀스명
    [START WITH n]
    [INCREMENT BY n]
    [MAXVALUE n | NOMAXVALUE]
    [MINVALUE n | NOMINVALUE]
    [CYCLE | NOCYCLE]
    [CACHE n | NOCACHE]
    [ORDER | NOORDER]
    
    - START WITH n : 시작 값, 생략하면 MINVALUE
    - INCREMENT BY n : 증감값 생략하면 1로 간주
    - MAXVALUE n : 사용하는 최대값, default는 NOMAXVALUE이고 10^27까지 사용
    - MINVALUE n : 사용하는 최소값, default는 NOMINVALUE이고 1
    - CYCLE : 최대(최소)까지 도달한 후 다시 시작할 것인지 여부 default는 NOCYCLE
    - CACHE n : 생성할 값을 캐시에 미리 만들어 사용 default는 CACHE 20 임
    - ORDER : 정의된대로 시퀀스 생성 강제, default는 NOORDER
    
    나눗셈이 오래 걸림
    주의사항 : 한 번 건너 뛴 숫자를 뒤로 올 수가 없다.
    
** 시퀀스객체 의사(Pseudo Column)컬럼
    1. 시퀀스명.NEXTVAL : '시퀀스'의 다음 값 반환
    2. 시퀀스명.CURRVAL : '시퀀스'의 현재 값 반환
    -- 시퀀스가 생성되고 해당 세션의 첫 번째 명령은 반드시 시퀀스명.NEXTVAL 이어야 함
    
    
    사용예)LPROD 테이블에 다음 자료를 삽입하시오(단, 시퀀스를 이용하시오)
    
    [자료]
    LPROD_ID : 10번부터
    LPROD_GU : P501, P502, P503
    LPROD_NM : 농산물, 수산물, 임산물
    
    1)시퀀스 생성
    CREATE SEQUENCE SEQ_LPROD
        START WITH 10;
    
    SELECT SEQ_LPROD.CURRVAL FROM dual; --아직 세션에서 정의가 되지 않아 값이 존재하지 않는다.
    
    2)자료 삽입
    INSERT INTO LPROD VALUES(SEQ_LPROD.NEXTVAL, 'P501' , '농산물'); - 10 CURRVAL
    INSERT INTO LPROD VALUES(SEQ_LPROD.NEXTVAL, 'P502' , '수산물'); - 11 CURRVAL
    INSERT INTO LPROD VALUES(SEQ_LPROD.NEXTVAL, 'P503' , '임산물'); - 12 CURRVAL
    
    SELECT * FROM LPROD;
    
    SELECT SEQ_LPROD.CURRVAL FROM dual; --아직 세션에서 정의가 되지 않아 값이 존재하지 않는다.
    
    
    사용예] 오늘이 2005년 7월 28일인 경우 'm001'회원이 제품 'P201000004'을
        5개 구입했을때 CART 테이블에 해당 자료를 삽입하는 쿼리를 작성하세요
        --먼저 날짜를 2005년 7월 28일로 변경 후 작성할 것
        
    ** CART_NO 생성
    
    SELECT TO_CHAR(MAX(CART_NO)+1) FROM CART;
    SELECT MAX(CART_NO) FROM CART;    
    SELECT * FROM CART ORDER BY CART_NO DESC;
    
    ** 순번 확인
    SELECT MAX(SUBSTR(CART_NO,9)) FROM CART;
    
    CREATE SEQUENCE SEQ_CART
    START WITH 5;
    
    INSERT INTO CART(CART_MEMBER, CART_NO, CART_PROD, CART_QTY)
    VALUES ('m001' , ('20050728'||
            TRIM(TO_CHAR(SEQ_CART.NEXTVAL,'00000'))),'P201000004',5);
            
            
    SELECT '21212121' || '212'
    FROM dual;
    
    SELECT *
    FROM CART
    ORDER BY CART_NO DESC
    
    - INSERT 에서 실패를 많이 해서 숫자가 3개 정도 넘어가버림
    drop sequence seq_cart; -- 시퀀스 삭제
    -- 시퀀스를 삭제해도 테이블이 남아있네
    
    **시퀀스가 사용되는 곳
        - SELECT 문의 SELECT 절 (서브쿼리는 제외)
        - INSERT 문의 SELECT 절 (서브쿼리), VALUE절
        - UPDATE 문의 SET 절
    
    
    **시퀀스의 사용이 제한되는 곳
        - SELECT, DELETE, UPDATE 문에서 사용되는 Subquery
        - VIEW를 대상으로 사용하는 쿼리
        - DISTINCT가 사용된 SELECT 절
        - GROUP BY / ORDER BY 가 사용된 SELECT 문
        - 집합연산자(UNION, UNION ALL, MINUS, INTERSECT)가 사용된 SELECT 문
        - SELECT 문의 WHERE 절
    
    
    SELECT SEQ_CART.CURRVAL FROM dual;
    오류로 인해 시퀀스가 넘어가면 다시 그 값을 사용할 수가 없어서 조심해야합니다.
    그걸 피하기 위해 NEXTVAL 쿼리를 따로 만들어서 CURRVAL 을 이용해서 INSERT 하면 된다.
    
02) SYNONYM 객체
    - 동의어 의미
    - 오라클에서 생성된 객체에 별도의 이름을 부여
    - 긴 이름의 객체를 쉽게 사용하기 위한 용도로 주로 사용
    (사용형식)
    CREATE [OR REPLACE] SYNONYM 동의어 이름
        FOR 객체명;
    
        
        -'객체'에 별도의 이름인 '동의어 이름'을 부여
    (사용예) HR 계정에 REGIONS테이블의 내용을 조회
    
    (테이블 별칭을 사용한 경우)
    SELECT HR.REGIONS.REGION_ID AS 지역코드,
    HR.REGIONS.REGION_NAME AS 지역명
    FROM HR.REGIONS A;
    
    (동의어를 사용한 경우)
    CREATE OR REPLACE SYNONYM REG FOR HR.REGIONS;
    
    SELECT A.REGION_ID AS 지역코드, A.REGION_NAME AS 지역명
    FROM REG A;
    
    2021-0402-03) INDEX 객체
    - 데이터 검색 효율을 증대 시키기위한 도구
    - DBMS의 부하를 줄여 전체 성능향상
    - 별도의 추가공간에 INDEX FILE을 위한 PROCESS가 요구됨
    
    1) 인덱스가 요구되는 곳
    - 자주 검색되는 컬럼
    - 기본키(자동 인덱스 생성)와 외래키
    - SORT, GROUP의 기본 컬럼
    - JOIN 조건에 사용되는 컬럼
    
    2) 인덱스가 불필요한 곳
    - 컬럼의 도메인이 적은 경우(성별, 나이 등) -- 도메인 : 컬럼에 올 수 있는 값의 종류
    - 검색조건으로 사용했으나 데이터의 대부분이 반환되는 경우 -- 검색 조건에 해당하는 행이 많다면 굳이 필요하지 않다는 이야기다.
    - SELECT보다 DML명령의 효율성이 중요한 경우
    
    3) 인덱스의 종류
    (1) Unique
        - 중복 값을 허용하지 않는 인덱스
        - NULL 값을 가질 수 있으나 이것도 중복해서는 안 됨
        - 기본키, 외래키 인덱스가 이에 해당 -- 기본키 : 데이터에서 중복을 허용하지 않아 행을 정확히 구분할 수 있는 컬럼이다.
        --인조키, 의미상 주어에 대한 건 나중에 찾아보자
        
    (2) NON Unique
        - 중복 값을 허용하는 인덱스
        
    (3) Normal Index
        - default INDEX
        - 트리 구조로 구성 (동일 검색 횟수 보장) 
        - 컬럼 값과 ROWID (물리적 주소)를 기반으로 저장
        
    (4) Function-Based Normal Index
        - 조건절에 사용되는 함수를 이용한 인덱스 (어떤 값을 함수에 넣어서 그 결과에 따라 인덱스에 저장한다는 이야기임)
        
    (5) Bitmap Index
        - ROWID와 컬럼 값을 이진으로 변환하여 이를 조합한 값을 기반으로 저장
        - 추가, 삭제, 수정이 빈번히 발생되는 경우 비효율적
    
    
SELECT *
FROM hr.employees
WHERE department_id IS NULL
    
    