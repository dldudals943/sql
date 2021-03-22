join 8  erd 다이어그램을 참고하여 countries, regions테이블을 이용하여
지역별 소속 국가를 다음과 같은 결과가 나오도록 쿼리를 작성해보세요 (지역은 유럽만 한정)

SELECT *
FROM countries

SELECT *
FROM regions

SELECT regions.region_id, regions.region_name, countries.country_name
FROM countries, regions
WHERE countries.region_id = regions.region_id AND region_name = 'Europe';
--문제 join 8 완료


join 9 erd 다이어그램을 참고하여 countries, regions, locations 테이블을 이용하여
지역별 소속 국가, 국가에 소속된 도시 이름을 다음과 같은 결과가 나오도록 쿼리를 작성해보세요 
(지역은 유럽만 한정)


SELECT regions.region_id, regions.region_name, countries.country_name, locations.city
FROM countries, regions, locations
WHERE countries.region_id = regions.region_id AND countries.country_id = locations.country_id AND region_name = 'Europe';
--문제 join 9 완료

join 10 erd 다이어그램을 참고하여 countries, regions, locations, departments  테이블을 이용하여
지역별 소속 국가, 국가에 소속된 도시 이름 및 도시에 있는 부서를 다음과 같은 결과가 나오도록 쿼리를 작성해보세요 
(지역은 유럽만 한정) 

SELECT regions.region_id, regions.region_name, countries.country_name, locations.city, departments.department_name
FROM countries, regions, locations, departments
WHERE countries.region_id = regions.region_id
    AND countries.country_id = locations.country_id
    AND locations.location_id = departments.location_id
    AND region_name = 'Europe';
--join 10 완료    
    
join11 erd 다이어그램을 참고하여 countries, regions, locations, departments,  employees 테이블을 이용하여
지역별 소속 국가, 국가에 소속된 도시 이름 및 도시에 있는 부서, 부서에 소속된 직원 정보를 다음과 같은 결과가 나오도록 쿼리를 작성해보세요 
(지역은 유럽만 한정) 

SELECT regions.region_id, regions.region_name, countries.country_name, locations.city, departments.department_name,
employees.first_name ||employees.last_name name 
FROM countries, regions, locations, departments, employees
WHERE countries.region_id = regions.region_id
    AND countries.country_id = locations.country_id
    AND locations.location_id = departments.location_id
    AND employees.department_id = departments.department_id
    AND region_name = 'Europe';

--join 11 완료

SELECT *
FROM jobs

SELECT *
FROM employees

SELECT employees.employee_id, employees.first_name || employees.last_name name, jobs.job_id, jobs.job_title 
FROM jobs, employees
WHERE jobs.job_id = employees.job_id

--join 12 완료

join 13 erd 다이어그램을 참고하여 employees, jobs 테이블을 이용하여
직원의 담당업무 명칭, 직원의 매니저 정보 포함하여 다음과 같은 결과가 나오도록 쿼리를 작성해보세요

SELECT e.manager_id, m.first_name || m.last_name mgr_name , e.employee_id, e.first_name || e.last_name name, jobs.job_id, jobs.job_title 
FROM jobs, employees e, employees m
WHERE jobs.job_id = e.job_id
    AND e.manager_id = m.employee_id


--join13 완료

SELECT e.manager_id, m.first_name || m.last_name mgr_name , e.employee_id, e.first_name || e.last_name name, jobs.job_id, jobs.job_title 
FROM jobs, employees e, employees m
WHERE jobs.job_id = e.job_id
    AND e.manager_id = m.employee_id(+)
    
--만약 상사가 없는 null에 해당하는 사람까지 해서 106 + 1 명을 표시하고 싶다면 위와같이 하면된다 
