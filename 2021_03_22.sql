SELECT lprod.lprod_gu, lprod.lprod_nm
FROM prod, lprod
WHERE prod.prod_lgu = lprod.lprod_gu;
