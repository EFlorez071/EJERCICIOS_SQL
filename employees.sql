 -- 1. Conteo General: ¿Cuántos empleados hay en total en la base de datos?

SELECT COUNT(emp_no) FROM employees;

-- 2. Salarios Extremos: ¿Cuál es el salario más alto y el salario más bajo que se ha pagado en la historia de la empresa?

SELECT max(salary) as high_salary, min(salary) As Low_salary from salaries;

-- 3. Promedio Salarial: ¿Cuál es el salario promedio de todos los empleados?

SELECT salary, avg(salary) AS round_salary FROM salaries;

-- 4. Agrupación por Género: Genera un reporte que muestre cuántos empleados hay de cada género (M y F).

SELECT gender, COUNT(*) AS genders FROM employees GROUP BY gender;

-- 5. Conteo de Cargos: ¿Cuántos empleados han ostentado cada cargo (title) a lo largo del tiempo? Ordena los resultados del cargo más común al menos común.

SELECT title, COUNT(*) AS Charge FROM titles GROUP BY title ORDER BY title DESC;

-- 6. Filtro de Grupos con HAVING: Muestra los cargos que han sido ocupados por más de 75,000 personas.

SELECT title, COUNT(*) AS people FROM titles GROUP BY title HAVING COUNT(*) > 75000;

-- 7. Agrupación Múltiple: ¿Cuántos empleados masculinos y femeninos hay por cada cargo?

SELECT t.title, e.gender, COUNT(*) AS total_empleados
FROM titles AS t 
JOIN employees AS e ON t.emp_no = e.emp_no
GROUP BY t.title, e.gender
ORDER BY t.title, e.gender;

-- 8. Nombres de Departamentos: Muestra una lista de todos los empleados (emp_no, first_name) junto al nombre del departamento en el que trabajan actualmente.

SELECT e.emp_no, e.first_name, d.dept_name
FROM employees AS e
JOIN dept_emp AS de ON e.emp_no = de.emp_no
JOIN departments AS d ON de.dept_no = d.dept_no
ORDER BY e.emp_no;
   
-- 9. Empleados de un Departamento Específico: Obtén el nombre y apellido de todos los empleados que trabajan en el departamento de "Marketing".

SELECT e.first_name, e.last_name
FROM employees AS e
JOIN dept_emp AS de ON e.emp_no = de.emp_no
JOIN departments AS d ON de.dept_no = d.dept_no
WHERE d.dept_name = 'Marketing'
ORDER BY e.first_name, e.last_name;

-- 10. Gerentes Actuales: Genera una lista de los gerentes de departamento (managers) actuales, mostrando su número de empleado, nombre completo y el nombre del departamento que dirigen.

SELECT e.emp_no, e.first_name, e.last_name, d.dept_name
FROM employees AS e
JOIN dept_manager AS dm ON e.emp_no = dm.emp_no
JOIN departments AS d ON dm.dept_no = d.dept_no
ORDER BY d.dept_name;

-- 11. Salario por Departamento: Calcula el salario promedio actual para cada departamento. El reporte debe mostrar el nombre del departamento y su salario promedio.

SELECT d.dept_name, AVG (s.salary) AS average_salary 
FROM salaries AS s 
JOIN dept_emp AS de ON s.emp_no = de.emp_no
JOIN departments AS d ON de.dept_no =d.dept_no
GROUP BY d.dept_name ORDER BY d.dept_name;

-- 12. Historial de Cargos de un Empleado: Muestra todos los cargos que ha tenido el empleado número 10006, junto con las fechas de inicio y fin de cada cargo.

SELECT e.emp_no, e.first_name, e.last_name, t.title, t.from_date, t.to_date
FROM employees AS e
JOIN titles AS t ON e.emp_no = t.emp_no
WHERE e.emp_no = '10006'
ORDER BY t.title;

-- 13. Departamentos sin Empleados (LEFT JOIN): ¿Hay algún departamento que no tenga empleados asignados? (Esta consulta teórica te ayudará a entender LEFTJOIN).

SELECT d.dept_name
FROM departments AS d
LEFT JOIN employees AS e ON d.dept_name = e.emp_no
WHERE d.dept_name IS NULL;

-- 14. Salario Actual del Empleado: Obtén el nombre, apellido y el salario actual de todos los empleados.

SELECT e.first_name, e.last_name, s.salary 
FROM employees AS e 
JOIN salaries AS s ON e.emp_no = s.emp_no; 

-- 15. Salarios por Encima del Promedio: Encuentra a todos los empleados cuyo salario actual es mayor que el salario promedio de toda la empresa.

SELECT s.salary, e.first_name, e.last_name
FROM salaries AS s
JOIN employees AS e ON s.emp_no = e.emp_no 
where s.salary > (SELECT avg(salary) FROM salaries);

-- 16. Nombres de los Gerentes: Usando una subconsulta con IN, muestra el nombre y apellido de todas las personas que son o han sido gerentes de un departamento.

SELECT first_name, last_name 
FROM employees 
WHERE emp_no IN (SELECT emp_no FROM dept_manager);

-- 17. Empleados que no son Gerentes: Encuentra a todos los empleados que nunca han sido gerentes de un departamento, usando NOT IN.

SELECT first_name, last_name
FROM employees
WHERE emp_no NOT IN (SELECT emp_no FROM dept_manager);

-- 18. Último Empleado Contratado: ¿Quién es el último empleado que fue contratado? Muestra su nombre completo y fecha de contratación.

SELECT *
FROM employees
where hire_date = (select max(hire_date) AS ultimo_contratado FROM employees);

-- 19. Jefes del Departamento de "Development": Obtén los nombres de todos los gerentes que han dirigido el departamento de "Development".

SELECT e.first_name, e.last_name 
FROM employees AS e 
JOIN dept_manager AS dm ON e.emp_no = dm.emp_no 
JOIN departments AS d ON dm.dept_no = d.dept_no 
where d.dept_name = 'Development'; 

-- 20. Empleados con el Salario Máximo: Encuentra al empleado (o empleados) que tiene el salario más alto registrado en la tabla de salarios.

SELECT max(salary) as high_salary from salaries;

-- 21. Nombres Completos: Muestra una lista de los primeros 100 empleados con su nombre y apellido combinados en una sola columna llamada nombre_completo.

SELECT concat(first_name,' ', last_name) as nombre_completo
FROM employees 
ORDER BY first_name LIMIT 100;

-- 22. Antigüedad del Empleado: Calcula la antigüedad en años de cada empleado (desde hire_date hasta la fecha actual). Muestra el número de empleado y su antigüedad.

SELECT emp_no, hire_date, curdate(),
TIMESTAMPDIFF(YEAR, hire_date, CURDATE()) AS antiguedad_en_años
FROM employees;

-- 23. Categorización de Salarios con CASE: Clasifica los salarios actuales de los empleados en tres categorías:
-- o 'Bajo': si es menor a 50,000.
-- o 'Medio': si está entre 50,000 y 90,000.
-- o 'Alto': si es mayor a 90,000.

SELECT salary,
CASE 
WHEN salary < 50000 THEN 'BAJO'
WHEN salary > 50000 and salary < 90000 THEN 'MEDIO'
WHEN salary > 90000 THEN 'ALTO'
END AS Salarios_Actuales
from salaries

-- 24. Mes de Contratación: Genera un reporte que cuente cuántos empleados fueron contratados en cada mes del año (independientemente del año)

SELECT MONTH(hire_date) AS mes, COUNT(*) as cantidad_empleados
FROM employees
GROUP BY MONTH(hire_date)
ORDER BY mes;

-- 25. Iniciales de Empleados: Crea una columna que muestre las iniciales de cada empleado (por ejemplo, para 'Georgi Facello' sería 'G.F.').

SELECT first_name, last_name, CONCAT(SUBSTRING(first_name, 1, 1), SUBSTRING(last_name, 1, 1)) AS iniciales
FROM employees;

-- 26. Departamento con el Mejor Salario Promedio: ¿Qué departamento tiene el salario promedio actual más alto?

SELECT dept_no, dept_name, avg(salary) as salario_promedio
FROM salaries as s
JOIN departments as d
group by dept_no
order by salario_promedio desc LIMIT 1;

-- 27. Gerente con Más Tiempo en el Cargo: Encuentra al gerente que ha estado en su puesto por más tiempo. Muestra su nombre y el número de días en el cargo.
SELECT e.first_name, e.last_name, DATEDIFF(CURDATE(), dm.from_date) AS dias_en_el_cargo
FROM dept_manager dm
JOIN employees e ON dm.emp_no = e.emp_no
ORDER BY dm.from_date ASC
LIMIT 1

-- 28. Incremento Salarial por Empleado: Para el empleado 10001, calcula la diferencia

SELECT MAX(s.salary) - MIN(s.salary) AS incremento_salarial
FROM salaries s
WHERE s.emp_no = 10001;

-- 29. Empleados Contratados el Mismo Día: Encuentra todos los pares de empleados

SELECT e1.emp_no AS empleado_1, e2.emp_no AS empleado_2, e1.hire_date
FROM employees e1
JOIN employees e2 ON e1.hire_date = e2.hire_date AND e1.emp_no < e2.emp_no
ORDER BY e1.hire_date;

-- 30 El Ingeniero Mejor Pagado: ¿Quién es el 'Senior Engineer' con el salario actual más alto en toda la empresa? Muestra su nombre, apellido y salario.

SELECT e.first_name, e.last_name, s.salary
FROM employees e
JOIN titles t ON e.emp_no = t.emp_no
JOIN salaries s ON e.emp_no = s.emp_no
WHERE t.title = 'Senior Engineer'
ORDER BY s.salary DESC
LIMIT 1;