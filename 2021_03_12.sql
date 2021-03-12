Lee 계정에 있는 prod 테이블의 모든 컬럼을 조회하는 SELECT 쿼리(SQL) 작성

SELECT *
FROM prod;

Lee 계정에 있는 prod 테이블의 prod_id, prod_name 컬럼을 조회하는 SELECT 쿼리(SQL) 작성

SELECT prod_id, prod_name
FROM prod;



[ SELECT1 ]

lprod 테이블에서 모든 데이터를 조회하는 쿼리를 작성하세요
    
SELECT *
FROM lprod
    
buyer 테이블에서 buyer_id, buyer_name 컬럼만 조회하는 쿼리를 작성하세요
    
SELECT buyer_id, buyer_name
FROM buyer

cart 테이블에서 모든 데이터를 조회하는 쿼리를 작성하세요
    
SELECT *
FROM cart

member 테이블에서 mem_id, mem_pass, mem_name 컬러만 조회하는 쿼리를 작성하세요
    
SELECT mem_id, mem_pass, mem_name
FROM member
    
컬럼 정보를 보는 방법
1. SELECT * ==> 컬럼의 이름을 알 수 있다
2. SQL DEVELOPER의 테이블 객체를 클릭하여 정보확인
3. DESC 테이블명; //DESCRIBE 설명하다

DESC emp
    
데이터 타입 ( 문자, 숫자, 날짜)

empno : number ;
empno + 10 => expression

ALIAS : 컬럼의 이름을 변경
    컬럼 : EXPRESSION ( as) 컬럼명
    
    NULL 널을 포함한 연산은 결과가 항상  0
    => NULL 값을 다른 값으로 치환해주는 함수
    
[ SELECT2 ]

    prod 테이블에서 prod_id, prod_name 두 컬럼을 조회하는 쿼리를 작성하시오
    (단 pord_id -> id, prod_name -> name 으로 컬럼 별칭을 지정)
    
SELECT prod_id AS id, prod_name AS name
FROM prod
    
    
    lprod 테이블에서 lprod_gu, lprod_nm 두 컬럼을 조회하는 쿼리를 작성하시오
    (ks lprod_gu -> gu, lprod_nm -> nm 으로 컬럼 별칭을 지정)
    
SELECT lprod_gu AS gu, lprod_nm AS nm
FROM lprod
    
    buyer 테이블에서 buyer_id, buyer_name 두 컬럼을 조회하는 쿼리를 작성하시오.
    (단 buyer_id -> 바이어아이디, buyer_name -> 이름으로 컬럼 별칭을 지정)

SELECT buyer_id AS 바이어아이디, buyer_name AS 이름
FROM buyer
    