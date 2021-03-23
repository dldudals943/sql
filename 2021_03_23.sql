월별실적
                반도체     핸드폰     냉장고
2021년 1월 :      500     300         400
2021년 2월 :      null       null     null <- null  어쩌구가아니라 애초에 테이블이 없을 수 있음
2021년 3월 :      500     300         400
-
-
-
2021년 12월 :     500      300         400


테이블 : 
outerjoin1

SELECT buy_date, buy_prod, prod_id, prod_name, NVL(buy_qty, 0)
FROM buyprod, prod
WHERE buyprod.buy_prod(+) = prod.prod_id
AND buy_date = TO_DATE('2005/01/25' , 'yyyy/mm/dd')

outerjoin2
SELECT  NVL(buy_date,'2005/01/25'), buy_prod, prod_id, prod_name, NVL(buy_qty, 0)
FROM buyprod, prod
WHERE buyprod.buy_prod(+) = prod.prod_id
AND buy_date(+) = TO_DATE('2005/01/25' , 'yyyy/mm/dd')

outerjoin3
SELECT  NVL(buy_date,'2005/01/25'), buy_prod, prod_id, prod_name, NVL(buy_qty, 0)
FROM buyprod, prod
WHERE buyprod.buy_prod(+) = prod.prod_id
AND buy_date(+) = TO_DATE('2005/01/25' , 'yyyy/mm/dd')

outerjoin4
SELECT *
FROM cycle;

SELECT product.pid, pnm, NVL(cid, 1), NVL(day,0), NVL(cnt,0)
FROM cycle, product
WHERE cycle.pid(+) = product.pid AND cid(+) = 1
--오라클 방법 우리는 product를 master로 잡았으니 cycle 컬럼에 다 +를 붙여야 아래 코드와 같은 방식이 된다.

SELECT product.pid, pnm, NVL(cid, 1) cid, NVL(day,0) day, NVL(cnt,0) cnt
FROM product LEFT OUTER JOIN cycle ON (product.pid = cycle.pid AND cid = 1)
--ANSI 방법

SELECT product.pid, pnm, NVL(cid, :cid) cid, NVL(day,0) day, NVL(cnt,0) cnt
FROM product LEFT OUTER JOIN cycle ON (product.pid = cycle.pid AND cid = :cid)
--고객 id를 변수로 지정

outerjoin5 과제
outerjoin4를 바탕으로 고객 이름 컬럼 추가하기
SELECT pid, pnm, cid, cnm, day, cnt
FROM(SELECT product.pid, pnm, NVL(cid, 1) cid1, NVL(day,0) day, NVL(cnt,0) cnt
FROM product LEFT OUTER JOIN cycle ON (product.pid = cycle.pid AND cid = 1)) join customer ON(customer.cid = cid1)
--과제완료

-----------------------------------------------------------

WHERE, GROUP BY(그룹핑), JOIN

JOIN
문법
: ANSI / ORACLE
논리적 형태
: SELF JOIN, NON-EQUI-JOIN <==> EQUI-JOIN
연결조건 성공 실패에 따라 조회여부 결정
: OUTERJOIN <==> INNERJOIN : 연결이 성공적으로 이루어진 행에 대해서만 조회가 되는 조인

SELECT *
FROM dept INNER JOIN emp ON (dept.deptno = emp.deptno)

CROSS JOIN
    - 별도의 연결 조건이 없는 조인
    - 묻지마 조인
    - 두 테이블의 행간 연결가능한 모든 경우의 수로 연결
    ==> CROSS JOIN의 결과는 두 테이블의 행의 수를 곱한값과 같은 행이 반환된다
    - 데이터 복제를 위해 사용
    - 나중에 고급 sql들어가면 꼭 나온다고 합니다.
    
    
SELECT *
FROM emp, dept;


crossjoin1
customer, product테이블을 이용하여 고객이 애음가능한 모든 제품의 정보를 결합하여 다음과 같이 조회되도록 쿼리를 작성하세요
SELECT *
FROM customer, product

SELECT STORECATEGORY
FROM BURGERSTORE
WHERE SIDO = '대전'
GROUP BY STORECATEGORY;


도시 발전 지수 : (kfc + 맥도날드 + 버거킹 ) / 롯데리아 

대전 중구 2
SELECT sido, sigungu, kmbc/lc "도시발전지수"
FROM(SELECT count(*) kmbc
FROM BURGERSTORE
WHERE SIDO = '대전' AND SIGUNGU = '중구' AND storecategory NOT IN('LOTTERIA')) kmb,

(SELECT count(*) lc
FROM BURGERSTORE
WHERE SIDO = '대전' AND SIGUNGU = '중구' AND storecategory IN('LOTTERIA')) l,

(SELECT sido, sigungu
FROM burgerstore
GROUP BY SIDO, SIGUNGU
HAVING SIDO = '대전' AND SIGUNGU = '중구' ) city;

-------------------------------------------------------------
SELECT sido, sigungu, kmbc/lc "도시발전지수"
FROM(SELECT count(*) kmbc
FROM BURGERSTORE
WHERE SIDO = :sido AND SIGUNGU = :sigungu AND storecategory NOT IN('LOTTERIA')) kmb,

(SELECT count(*) lc
FROM BURGERSTORE
WHERE SIDO = :sido AND SIGUNGU = :sigungu AND storecategory IN('LOTTERIA')) l,

(SELECT sido, sigungu
FROM burgerstore
GROUP BY SIDO, SIGUNGU
HAVING SIDO = :sido AND SIGUNGU = :sigungu ) city;
--변수입력할때는 문자열의 경우 ''를 쓰면 안 됨 

----------------
SELECT kmb.sido, kmb.sigungu, kmbcount/lcount "도시발전지수"
FROM
(SELECT SIDO, SIGUNGU, count(storecategory) kmbcount
FROM burgerstore
WHERE sido = '대전' AND sigungu = '중구' AND storecategory NOT IN('LOTTERIA')
GROUP BY sido, sigungu) kmb,
(SELECT SIDO, SIGUNGU, storecategory, count(storecategory) lcount
FROM burgerstore
WHERE sido = '대전' AND sigungu = '중구' AND storecategory IN('LOTTERIA')
GROUP BY storecategory, sido, sigungu) l;

---------------------
SELECT kmb.sido, kmb.sigungu, kmbcount/lcount "도시발전지수"
FROM
(SELECT SIDO, SIGUNGU, count(storecategory) kmbcount
FROM burgerstore
WHERE sido = :sido AND sigungu = :sigungu AND storecategory NOT IN('LOTTERIA')
GROUP BY sido, sigungu) kmb,
(SELECT SIDO, SIGUNGU, storecategory, count(storecategory) lcount
FROM burgerstore
WHERE sido = :sido AND sigungu = :sigungu AND storecategory IN('LOTTERIA')
GROUP BY storecategory, sido, sigungu) l;



----------중복이 발생해 distinct 를 사용하게 되면 코딩이 잘못되었을 확률이 높다

-- 어려운 테크닉의 정답

-- 행을 컬럼으로 변경(pivot)

--위 문제에 정답에 해당한다

SELECT sido,sigungu, storecategory,
    case
        WHEN storecategory = 'BURGER KING' THEN 1
        ELSE 0
    END bk
FROM burgerstore;

--나누는 수가 0이 되는지에 대한 체크가 필요함

SELECT sido,sigungu,
    ROUND(SUM(DECODE(storecategory, 'BURGER KING', 1, 0)) +
    SUM(DECODE(storecategory, 'KFC', 1, 0)) +
    SUM(DECODE(storecategory, 'MACDONALD', 1, 0)) /
    DECODE(SUM(DECODE(storecategory, 'LOTTERIA', 1, 0)),0,1,SUM(DECODE(storecategory, 'LOTTERIA', 1, 0))),2) idx
FROM burgerstore
GROUP BY sido, sigungu
ORDER BY idx DESC;
--이거 시험봐요











