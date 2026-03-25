-- Subconsulta escalar (un valor)

-- Escalar en SELECT

SELECT
	o.OrderID,
	(od.Quantity * od.UnitPrice) AS [Total],
	(SELECT AVG((od.Quantity * od.UnitPrice)) FROM [Order Details] AS od) AS [AVGTOTAL]
FROM Orders AS o
INNER JOIN [Order Details] AS od
ON o.OrderID = od.OrderId;

-- Mostrar el nombre del producto y el precio promedio de todos los productos

SELECT
	DISTINCT p.ProductName,
	(SELECT AVG((od.UnitPrice)) FROM [Order Details] AS od) AS [Precio Promedio]
FROM Products as p
INNER JOIN [Order Details] AS od
ON p.ProductID = od.ProductID;

SELECT *
FROM [Order Details];

-- Mostrar cada empleado y la cantidad total de pedidos que tiene

SELECT
	DISTINCT e.EmployeeID,
	CONCAT(e.FirstName, ' ', e.LastName) AS [Nombre],
	(SELECT COUNT(*) FROM Orders AS o
	WHERE o.EmployeeID = e.EmployeeID) AS [Numero de Pedidos]
FROM Employees AS e;

SELECT
	DISTINCT e.EmployeeID,
	CONCAT(e.FirstName, ' ', e.LastName) AS [Nombre],
	COUNT(o.OrderID) AS [Numero de Pedidos]
FROM Employees AS e
INNER JOIN Orders AS o
ON e.EmployeeID = o.EmployeeID
GROUP BY e.EmployeeID, e.FirstName, e.LastName;

SELECT *
FROM Orders;

-- Mostrar cada cliente y la fecha de su ultimo pedido

-- Mostar pedidos con nombre del cliente y total del pedido (sum)

SELECT
	o.OrderID,
	c.CompanyName,
	(SELECT SUM(od.Quantity * od.UnitPrice) 
	FROM [Order Details] AS od
	WHERE od.OrderID = o.OrderID) AS [Total]
FROM Orders AS o
INNER JOIN Customers AS c
ON o.CustomerID = c.CustomerID
ORDER BY c.CompanyName;

-- Datos de Ejemplo

CREATE DATABASE bdsubconsultas;
GO

USE bdsubconsultas;

CREATE TABLE Clientes(
id_cliente INT NOT NULL IDENTITY(1, 1) PRIMARY KEY,
nombre NVARCHAR(50) NOT NULL,
ciudad NCHAR(20) NOT NULL
);

CREATE TABLE Pedidos(
id_pedido INT NOT NULL IDENTITY(1, 1) PRIMARY KEY,
id_cliente INT NOT NULL,
total MONEY NOT NULL,
fecha DATE NOT NULL,
CONSTRAINT fk_pedidos_clientes
FOREIGN KEY (id_cliente)
REFERENCES Clientes(id_cliente)
);

INSERT INTO clientes (nombre, ciudad) VALUES
('Ana', 'CDMX'),
('Luis', 'Guadalajara'),
('Marta', 'CDMX'),
('Pedro', 'Monterrey'),
('Sofia', 'Puebla'),
('Carlos', 'CDMX'), 
('Artemio', 'Pachuca'), 
('Roberto', 'Veracruz');

INSERT INTO pedidos (id_cliente, total, fecha) VALUES
(1, 1000.00, '2024-01-10'),
(1, 500.00,  '2024-02-10'),
(2, 300.00,  '2024-01-05'),
(3, 1500.00, '2024-03-01'),
(3, 700.00,  '2024-03-15'),
(1, 1200.00, '2024-04-01'),
(2, 800.00,  '2024-02-20'),
(3, 400.00,  '2024-04-10');

-- Consulta Escalar:

-- Seleccionar los pedidos en donde el total sea igual al total m�ximo de ellos

SELECT MAX(total)
FROM Pedidos;

SELECT *
FROM Pedidos
WHERE total = (
	SELECT MAX(total)
	FROM Pedidos
);

SELECT 
	p.id_pedido,
	c.nombre,
	p.fecha,
	p.total
FROM Pedidos AS p
INNER JOIN Clientes AS c
ON p.id_cliente = c.id_cliente
WHERE p.total = (SELECT MAX(total) FROM Pedidos);

-- Seleccionar los pedidos mayores al promedio

SELECT 
	AVG(total)
FROM Pedidos;

SELECT *
FROM Pedidos
WHERE total > (SELECT AVG(total) FROM Pedidos);

-- Seleccionar todos los pedidos del cliente que tenga el menor id

SELECT MIN(id_cliente)
FROM Pedidos;

SELECT *
FROM Pedidos
WHERE id_cliente = (SELECT MIN(id_cliente) FROM Pedidos);

SELECT id_cliente, COUNT(*) AS [Numero de pedidos]
FROM Pedidos
WHERE id_cliente = (SELECT MIN(id_cliente) FROM Pedidos)
GROUP BY id_cliente;

-- Mostrar los datos del pedidos de la �ltima orden

SELECT MAX(fecha)
FROM Pedidos;

SELECT
	p.id_pedido,
	c.nombre,
	p.fecha,
	p.total
FROM Pedidos AS p
INNER JOIN Clientes AS c
ON p.id_cliente = c.id_cliente
WHERE p.fecha = (SELECT MAX(fecha) FROM Pedidos);

-- Mostar todos los pedidos con un total que sea el m�s bajo

SELECT MIN(total)
FROM Pedidos;

SELECT *
FROM Pedidos
WHERE total = (SELECT MIN(total) FROM Pedidos);

-- Seleccionar los pedidos con el nombre del cliente cuyo total (Freight) sea mayor al promedio general de Freight

USE NORTHWND;

SELECT AVG(Freight)
FROM Orders;

SELECT 
	o.OrderID,
	c.CompanyName,
	o.Freight,
	CONCAT(e.FirstName, ' ', e.LastName) AS [EMPLEADO FULLNAME]
FROM Orders AS o
INNER JOIN Customers AS c
ON o.CustomerID = c.CustomerID
INNER JOIN Employees AS e
ON e.EmployeeID = o.EmployeeID
WHERE o.Freight > (SELECT AVG(Freight) FROM Orders)
ORDER BY o.Freight DESC;

-- Subqueries con IN, ANY, ALL (llevan una sola columna)
-- La clausula IN

-- Clientes que han hecho pedidos

SELECT
	id_cliente
FROM Pedidos;

SELECT *
FROM Clientes
WHERE id_cliente IN (SELECT id_cliente FROM Pedidos);

SELECT DISTINCT
	c.id_cliente,
	c.nombre,
	c.ciudad
FROM Clientes AS c
INNER JOIN Pedidos AS p
ON c.id_cliente = p.id_cliente;

-- Clientes que han hecho pedidos mayores a 800

-- Subconsulta
SELECT 
	id_cliente
FROM Pedidos
WHERE total > 800;

-- Principal
SELECT *
FROM Pedidos
WHERE id_cliente IN (SELECT id_cliente
FROM Pedidos
WHERE total > 800);

-- Seleccionar todos los clientes de la ciudad de m�xico quen han hecho pedidos
-- Subconsulta
SELECT *
FROM clientes
WHERE ciudad = 'CDMX'
AND id_cliente IN (
	SELECT id_cliente
	FROM Pedidos
);

-- Seleccionar clientes que no han hecho pedidos (Usando JOIN)
SELECT
	id_cliente
FROM Pedidos;

-- Principal
SELECT *
FROM Clientes
WHERE id_cliente NOT IN (SELECT id_cliente FROM Pedidos);

SELECT
	c.id_cliente,
	c.nombre,
	c.ciudad
FROM Pedidos AS p
RIGHT JOIN Clientes AS c
ON p.id_cliente = c.id_cliente
WHERE p.id_cliente IS NULL;

-- Seleccionar los pedidos de clientes de Monterrey
-- Subconsulta
SELECT id_cliente
FROM Clientes
WHERE ciudad = 'Monterrey';

-- Principal
SELECT *
FROM Pedidos
WHERE id_cliente IN (SELECT id_cliente FROM Clientes WHERE ciudad = 'Monterrey');

SELECT *
FROM Clientes AS c
LEFT JOIN Pedidos AS p
ON c.id_cliente = p.id_cliente
WHERE c.ciudad = 'Monterrey';

-- Operadores ANY

-- Seleccionar pedidos mayores que algún pedido de Luis (id_cliente=2)

-- Primero la subconsulta
SELECT total
FROM Pedidos
WHERE id_cliente = 2;

-- Consulta principal
SELECT *
FROM Pedidos
WHERE total > ANY (
	SELECT total
	FROM Pedidos
	WHERE id_cliente = 2
);

-- Seleccionar los pedidos mayores (total) de algún pedido de Ana
-- Subconsulta
SELECT total
FROM Pedidos
WHERE id_cliente = 1;

-- Consulta principal
SELECT *
FROM Pedidos
WHERE total > ANY (
	SELECT total
	FROM Pedidos
	WHERE id_cliente = 1
);

-- Seleccionar los pedidos mayores que algun pedido superior (total) a 500
-- Subconsulta
SELECT total
FROM Pedidos
WHERE total > 500;

-- Consulta principal
SELECT *
FROM Pedidos
WHERE total > ANY (
	SELECT total
	FROM Pedidos
	WHERE total > 500
);

-- ALL

-- Seleccionar los pedidos donde el total sea mayor a todos los totales de los pedidos de Luis
-- Subconsulta
SELECT total
FROM Pedidos
WHERE id_cliente = 2;

SELECT total
FROM Pedidos;

-- Principal
SELECT *
FROM Pedidos
WHERE total > ALL(
	SELECT total
	FROM Pedidos
	WHERE id_cliente = 2
);

-- Seleccionar todos los clientes donde su ID sea menor que todos los clientes de la CDMX
-- Subconsulta
SELECT id_cliente
FROM Clientes
WHERE ciudad = 'CDMX';

-- Principal
SELECT *
FROM Clientes
WHERE id_cliente < ALL(
	SELECT id_cliente
	FROM Clientes
	WHERE ciudad = 'CDMX'
);

-- Subconsultas correlacionadas

SELECT SUM(total)
FROM Pedidos as p

SELECT *
FROM Clientes AS c
WHERE (
	SELECT SUM(total)
	FROM Pedidos as p
	WHERE p.id_cliente = c.id_cliente
) > 1000;

SELECT *
FROM Clientes;

SELECT SUM(total)
	FROM Pedidos as p
	WHERE p.id_cliente = 1


-- Seleccionar todos los clientes que han hecho más de un pedido

SELECT *
FROM Clientes AS c
WHERE (
	SELECT COUNT(*)
	FROM Pedidos AS p
	WHERE p.id_cliente = c.id_cliente
) > 1;

-- Seleccionar todos los de pedidos en donde su total debe ser mayor al promedio de los 
-- totales hechos por los clientes

SELECT AVG(total)
FROM Pedidos AS pe
WHERE pe.id_cliente =  

SELECT *
FROM Pedidos AS p
WHERE total > (
	SELECT AVG(total)
	FROM Pedidos AS pe
	WHERE pe.id_cliente =  p.id_cliente
);

-- Seleccionar todos los clientes cuyo pedido máximo sea mayor a 1200

SELECT MAX(total)
FROM Pedidos AS p
WHERE p.id_cliente =

SELECT *
FROM Clientes AS c
WHERE (
	SELECT MAX(total)
	FROM Pedidos as p
	WHERE p.id_cliente = c.id_cliente
) > 1200;


SELECT MAX(total)
FROM Pedidos AS p
WHERE p.id_cliente = 1

SELECT * FROM Clientes;
SELECT * FROM Pedidos;