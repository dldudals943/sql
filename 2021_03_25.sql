sub6]

cycle 테이블을 이용하여 cid=1인 고객이 애음하는 제픔 중 cid=2인 고객도 애음하는 제품의 애음정보를 조회하는 쿼리를 작성하세요

SELECT *
FROM cycle a
WHERE a.cid=1 AND pid IN (SELECT b.pid
                            FROM cycle b
                            WHERE b.cid = 2)

sub7]
customer, cycle, product 테이블을 이용하여 cid=1인 고객이 애음하는 제품중 cid=2이 고객도 애음하는 제품의 애음정보를
조회하고 고객명과 제품명까지 포함하는 쿼리를 작성하세요
SELECT bb.cid cid, bb.pid pid, bb.day
FROM
(SELECT *
FROM (
        SELECT *
        FROM cycle a
        WHERE a.cid=1 AND pid IN (SELECT b.pid
                                FROM cycle b
                                WHERE b.cid = 2)) aa JOIN customer ON (aa.cid= customer.cid)) bb JOIN product ON (bb.pid = product.pid)
--ANSI로 하려니까 인간적으로 너무 복잡함
                            

SELECT *
FROM cycle, customer, product
WHERE cycle.cid = 1
AND cycle.cid = customer.cid
AND cycle.pid = product.pid
AND cycle.pid IN (SELECT b.pid
            FROM cycle b
            WHERE b.cid = 2)
            
--oracle이 훨씬 낫다

EXISTS 서브쿼리 연산자 : 단항
[NOT] IN : WHERE 컬럼 : EXPRESSION IN (값1, 값2, 값3....)
[NOT] EXISTS : WHERE EXISTS (서브쿼리)
    ==> 서브쿼리의 실행 결과로 조회되는 행이 있으면 TRUE, 없으면 FALSE    
    EXISTS 연산자와 사용되는 서브쿼리는 상호연관, 비상호연관 서브쿼리 둘 다 사용가능하지만 
    행을 제한하기 위해서 상호연관 서브쿼리와 사용되는 경우가 일반적이다   
    
    서브쿼리에서 EXISTS 연산자를 만족하는 행을 하나라도 발견을 하면 더이상 진행하지 않고 효율적으로 일을 끊어버린다
    서브쿼리가 1000건이라 하더라도 10번째 행애서 EXISTS 연산을 만족하는 행을 발견하면 나머지 990건 정도의 데이터는 확인 안 한다.  
    
    
    
연산자 : 몇항
1 + 5  //  ? 
++, --


-- 매니저가 존재하는 직원
SELECT *
FROM emp
WHERE mgr IS NOT NULL;

SELECT *
FROM emp e
WHERE EXISTS (SELECT empno
              FROM emp m    
              WHERE e.mgr = m.empno)
              
--상호연관서브쿼리
                
SELECT *
FROM emp e
WHERE EXISTS (SELECT 'X'
              FROM dual)
--EXISTS 는 행의 존재 여부만 보기 때문에 관습적으로 'X'로 둔다 결과값이 상관이 없기 때문이다.
--EXISTS 연산자는 비상호연관서브쿼리로 사용하는 의미가 거의 없다 ALL OR NOTHING 이기 때문이다.

-----------------
칠거지악
존재 유무를 카운트로 세지마라
SELECT COUNT(*) cnt
FROM emp
WHERE deptno = 10;

if(cnt>0){

}....

SELECT *
FROM dual
WHERE EXISTS (SELECT 'X' FROM emp WHERE deptno = 10);

sub8] - 위에 있어서 안 함

sub9]
cycle, product 테이블을 이용하여 cid=1인 고객이 애음하는 제품을 조회하는 쿼리를 EXISTS 연산자를 이용하여 작성하세요
SELECT cycle.pid, product.pnm
FROM product, cycle
WHERE product.pid = cycle.pid
AND cycle.cid = 1
GROUP BY cycle.pid, product.pnm ; 

SELECT *
FROM product
WHERE EXISTS (SELECT 'X'    
                FROM cycle
                WHERE cid = 1
                AND product.pid = cycle.pid);

---------------------------------------------------------------------------------------------
집합연산
UNION , UNION ALL
UNION : {a,b} U {b,c} = > {a,b,c} 수학에서 이야기하는 일반적인 합집합

UNION ALL : {a,b} U {b,c} = > {a,a,b,c} 중복을 허용하는 합집합

INTERSECT : 교집합

MINUS : 차집합

집합연산
    행(row)를 확장 -> 위 아래
        위 아래 집합의 col의 개수와 타입이 일치해야한다
    join
        열(col)을 확장 -> 양 옆
        
    union
        합집합, 두개의 SELECT 결과를 하나로 합친다
        중복을 제거
    
    union all
        합집합
        중복을 제거 하지 않음 -> union 연산자에 비해 속도가 빠르다
        만약 중복이 나오지 않을 거라고 알고 있다면 이걸 쓰는게 좋다
        
    intersect
        교집합 : 두 집합의 공통된 부분
        
    minus
        차집합 : 한 집합에만 속하는 데이터

SELECT empno, ename
FROM emp
WHERE empno IN ( 7369,7499) 

UNION

SELECT empno, ename
FROM emp
WHERE empno IN ( 7369,7521); 


---------------

SELECT empno, ename, NULL -- 만약에 열의 갯수가 맞지 않으면 null로 가짜 컬럼을 만들어준다.
FROM emp
WHERE empno IN ( 7369,7499) 

UNION

SELECT empno, ename, deptno
FROM emp
WHERE empno IN ( 7369,7521); 

-----------------
UNION ALL : 중복을 허용하는 합집합
            중복제거 로직이 없기 때문에 속도가 빠르다 
            합집합 하라는 집합간 중복이 없다는 것을 알고 있을 경우  UNION 연산자 보다 UNION ALL 연산자가 유리하다

SELECT empno, ename
FROM emp
WHERE empno IN ( 7369,7499) 

UNION ALL

SELECT empno, ename
FROM emp
WHERE empno IN ( 7369,7521); 
--이 쿼리의 경우 위의 UNION 연산과 달리 SMITH 가 겹친다

---------------------------
INTERSECT 두개의 집합중 중복되는 부분만 조회 , 교집합

SELECT empno, ename
FROM emp
WHERE empno IN ( 7369,7499) 

INTERSECT

SELECT empno, ename
FROM emp
WHERE empno IN ( 7369,7521); 

그 결과로 SMITH가 나온다

--------------------------------
MINUS : 한 쪽 집합에서 다른 한 쪽 집합을 제외한 나머지 요소들을 반환

SELECT empno, ename
FROM emp
WHERE empno IN ( 7369,7499) 

MINUS

SELECT empno, ename
FROM emp
WHERE empno IN ( 7369,7521); 

--------------------------------------------
교환 법칙
A U B == B U A (UNION, UNION ALL)
A ^ B == B ^ A (INTERSECT)
A - B != B - A (MINUS) = > 집합의 순서에 따라 결과가 달라질 수 있따. (주의)
--------------------------------------------

집합연산 특징
1. 집합연산의 결과로 조회되는 데이터의 컬럼 이름은 첫번째 집합의 컬럼을 따른다

SELECT empno 번호, ename 이름
FROM emp
WHERE empno IN ( 7369,7499) 

UNION

SELECT empno, ename -- 아래 컬럼의 이름을 바꾸지 않아도 된다.
FROM emp
WHERE empno IN ( 7369,7521); 

2. 집합연산의 결과를 정렬하고 싶으면 가장 마지막 집합 뒤에 ORDER BY를 기술한다.
    - 개별 집합에 ORDER BY를 사용한 경우 에러
    - 단 ORDER BY를 적용한 인라인 뷰를 사용하는 것은 가능

SELECT empno e, ename
FROM emp
WHERE empno IN ( 7369,7499) 

UNION

SELECT empno, ename
FROM emp
WHERE empno IN ( 7369,7521)
ORDER BY e;
-----------------------------------------
SELECT e, ename --이거 아스타리스크로 하면 에러남 어 근데 에러가 왜 나지?
FROM(SELECT empno e, ename
FROM emp
WHERE empno IN ( 7369,7499) 
ORDER BY e)

UNION

SELECT empno, ename
FROM emp
WHERE empno IN ( 7369,7521)
ORDER BY e;

3. 중복은 제거 된다 (예외 UNION ALL)

(4. 9i 이전버전 그룹연산을 하게되면 기본적으로 오름차순으로 정렬되어 나온다
    이후버전 ==> 정렬을 보장하지 않음)

8i - internet
----------------
9i - internet
10g - grid
11g - grid
12c - cloud

집합연산 끝

DML
    - SELECT
    - 데이터 신규 입력 : INSERT
    - 기존 데이터 수정 : UPDATE
    - 기존 데이터 삭제 : DELETE
    
INSERT 문법
INSERT INTO 테이블명 (컬럼명1, 컬럼명2, 컬럼명3......)   
            VALUES (값1, 값2, 값3, ...)
            
            
만약 테이블에 존재하는 모든 컬럼에 데이터를 입력하는 경우 컬럼명은 생략 가능하고
값을 기술하는 순서를 테이블에 정의된 컬럼 순서와 일치시킨다

INSERT INTO 테이블명 VALUES (값1, 값2, 값3);

INSERT INTO 테이블명 [(((column),))] VALUES {(value, )}

INSERT INTO dept VALUES (99, 'ddit', 'daejeon')
INSERT INTO dept (deptno, dname, loc)
            VALUES (99, 'ddit', 'daejeon');

SELECT *
FROM dept
중복을 허용하지 않으려면 추가적인 설정이 필요한데 지금은 활성화시켜놓지 않았다

DESC dept

DESC emp

INSERT INTO emp (ename, job) VALUES ('brown','RANGER');
desc 를 해보면 empno 컬럼에 not null이라는 조건이 있다
 cannot insert NULL into ("LEE"."EMP"."EMPNO") 그래서 이런 오류가 뜨고 실행되지 않는다
            
INSERT INTO emp (empno, ename, job, hiredate, sal, comm)
        VALUES (9999, 'sally','RANGER', TO_DATE('2021-03-24','YYYY-MM-DD'), 1000, NULL);            
이건 삽입이 된다

여러건을 한번에 입력하기
INSERT INTO 테이블명
SELECT 쿼리

INSERT INTO dept
SELECT 90, 'DDIT', '대전' FROM dual UNION ALL
SELECT 80, 'DDITS', '대전' FROM dual            

ROLLBACK
SELECT *
FROM dept

-----------------------------------

UPDATE : 테이블에 존재하는 기존 데이터의 값을 변경

UPDATE 테이블명 SET 컬럼명1 = 값1, 컬럼명2=값2, 컬럼명3=값3......
WHERE 

SELECT *
FROM dept

부서번호 99번 부서 정보를 부서명 = 대덕IT로, loc = 영민빌딩으로 변경

UPDATE dept SET dname = '대덕IT', loc = '영민빌딩'
WHERE deptno = 99

WHERE 절이 누락 되있는지 확인
WHERE 절이 누락 된 경우 테이블의 모든 행에 대해 업데이트를 진행
(mysql 같은 경우 기본 설정이 auto commit 이라서 난리남 오라클은 한 번의 기회가 있음)
(데이터 날려버릴수도 있음 주의가 꼭 필요함)

선생님도 한 번 실수한 적이 있음

사용자 : 여사님(12-13000), 영업점(600) <- 가상의 조직 주민번호가 없음 null, 운영팀 직원(20)

UPDATE 사용자 SET 비밀번호 = 주민번호뒷자리컬럼;

WHERE 절 기술을 안 해서 영업점 비밀번호가 다 null이됨

WHERE 사용자구분 = '여사님';

SELECT *
FROM 사용자;

그래서 어케했냐면 영업점 코드로 비밀버호 변경


UPDATE 사용자 SET 비밀번호 = 사용자아이디;
WHERE 사용자구분 = '영업점';

공지띄우고 바꿨지만 전화하루종일받으셨다고함

다른 동료 실수 예제

ERP (enterpise resource planning)

DBA 데이터 복구 하는 직군
SAP ERP : 20000 테이블 삭제 프로그램
OSTEM : 7년치 실적을 날려버림
복구가 간단하진 않음 DBA 회사와 3일 계약을 함

NOT NULL 설정을 잘 하는게 좋긴한데... 요구사항이 이상하다면...
고객이 하는 말을 그대로 들으면 안 됨 말하는거랑 진짜 원하는게 다른 경우가 태반이다




