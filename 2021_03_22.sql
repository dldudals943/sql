SELECT prod_id, prod_name, lprod_gu, lprod_nm
FROM prod, lprod
WHERE prod.prod_lgu = lprod.lprod_gu;

erd 다이어그램을 참고하여 buyer, prod 테이블을 조인하여
buyer별 담당하는 제품 정보를 다음과 같은 결과가 나오도록 쿼리를 작성해보세요

SELECT buyer_id, buyer_name, prod_id, prod_name
FROM buyer, prod
WHERE prod.prod_buyer = buyer.buyer_id;

erd 다이어그램을 참고하여 member, cart, prod 테이블을 조인하여
회원별 장바구니에 담은 제품 정보를 다음과 같은 결과가 나오는 쿼리를 작성해보세요

SELECT *
FROM member
SELECT *
FROM cart
SELECT *
FROM prod

SELECT mem_id, mem_name, prod_id, prod_name, cart_qty
FROM member, cart, prod
WHERE member.mem_id = cart.cart_member AND cart.cart_prod = prod.prod_id;
--오라클 방법


SELECT mem_id, mem_name, prod_id, prod_name, cart_qty
FROM member JOIN cart ON (member.mem_id = cart.cart_member)
            JOIN prod ON (cart.cart_prod = prod.prod_id);
--ANSI 방법

실습 join4
 
SELECT customer.cid, cnm, pid, day, cnt
FROM customer, cycle
WHERE customer.cid = cycle.cid and customer.cnm IN('brown', 'sally')
 
 
실습 join5
SELECT customer.cid, cnm, cycle.pid, pnm, day, cnt
FROM customer, cycle, product
WHERE customer.cid = cycle.cid AND cycle.pid = product.pid AND customer.cnm in('brown', 'sally')


실습 join6
SELECT customer.cid, cnm, cycle.pid, pnm, sum(cnt)
FROM customer, cycle, product
WHERE customer.cid = cycle.cid AND cycle.pid = product.pid
GROUP BY customer.cid, cnm, cycle.pid, pnm
--그룹핑에 없는 컬럼을 설렉트 절에 쓸 수 없어서 그룹핑에 4개의 컬럼을 다 씀

실습 join7
SELECT cycle.pid, product.pnm, SUM(cycle.cnt) cnt
FROM cycle, product
WHERE cycle.pid = product.pid
GROUP BY cycle.pid, product.pnm;


---------------------------------------------------------------
여기서부터는 hr 계정 실습에 해당함

SELECT *
FROM jobs;

-------------------------------------------------------

OUTER JOIN : 컬럼 연결이 실패해도 (기준)이 되는 테이블 쪽의 컬럼 정보는 나오도록 하는 조인
LEFT OUTER JOIN : 기준이 왼쪽에 기술한 테이블이 되는 OUTER JOIN
RIGHT OUTER JOIN : 기준이 오른쪽에 기술한 테이블이 되는 OUTER JOIN
FULL OUTER JOIN : LEFT OUTER + RIGHT OUTER - 중복 데이터 제거


테이블1 JOIN 테이블2
테이블1 LEFT OUTER JOIN 테이블2
~~
테이블2 RIGHT OUTER JOIN 테이블1


직원의 이름, 직원의 상사 이름 두개의 컬럼이 나오도록 join query 작성
SELECT e.ename, m.ename
FROM emp e, emp m 
WHERE e.mgr = m.empno

SELECT e.ename, m.ename
FROM emp e JOIN emp m ON(e.mgr = m.empno)
-- 13건

SELECT e.ename, m.ename
FROM emp e LEFT OUTER JOIN emp m ON(e.mgr = m.empno)
-- 14건

SELECT e.ename ename, m.ename mgr
FROM emp e, emp m 
WHERE e.mgr = m.empno(+)
--oracle 문법에서는 레프트 라이트 아우터 없이 데이터가 null이 뜰 곳에 (+)를 붙여서 아우터를 처리한다.
--14건

SELECT e.ename, m.ename, m.deptno
FROM emp e LEFT OUTER JOIN emp m ON(e.mgr = m.empno AND m.deptno = 10);

SELECT e.ename, m.ename
FROM emp e LEFT OUTER JOIN emp m ON(e.mgr = m.empno)
WHERE m.deptno = 10;
--언뜻 같은 sql같아보이나 서로 결과가 다르다

SELECT e.ename ename, m.ename mgr
FROM emp e, emp m 
WHERE e.mgr = m.empno(+) 
  AND m.deptno(+) = 10

SELECT e.ename ename, m.ename mgr
FROM emp e, emp m 
WHERE e.mgr = m.empno(+) 
  AND m.deptno = 10
-- 위아래도 결과가 다르다


SELECT e.ename, m.ename
FROM emp e RIGHT OUTER JOIN emp m ON(e.mgr = m.empno)


SELECT e.ename, m.ename
FROM emp e FULL OUTER JOIN emp m ON(e.mgr = m.empno)

SELECT e.ename ename, m.ename mgr
FROM emp e, emp m 
WHERE e.mg(+)r = m.empno(+) 
--오라클 문법에서는 full을 지원하지 않는단

outerjoin1)
SELECT *
FROM buyprod;

SELECT count(*)
FROM prod

SELECT *
FROM buyprod
WHERE buy_date = TO_DATE('2005/01/25', 'YYYY/MM/DD');

모든 제품을 다 보여주고, 실제 구매가 있을 때는 구매수량을 조회, 없을 경우는 null로 표현
제품 코드 : 수량
buypord 테이블에 구매일자가 2005년 1월 25인 데이터는 3품목밖에 없다 모든 품목이 나올수 있도록 쿼리를 작성

SELECT buy_date, buy_prod, prod_id, prod_name, buy_qty
FROM buyprod RIGHT OUTER JOIN prod ON(buy_prod = prod_id AND buy_date = TO_DATE('2005/01/25', 'YYYY/MM/DD'))
--ANSI

SELECT buy_date, buy_prod, prod_id, prod_name, buy_qty
FROM buyprod , prod  
WHERE buy_prod(+) = prod_id AND buy_date(+) = TO_DATE('2005/01/25', 'YYYY/MM/DD')







