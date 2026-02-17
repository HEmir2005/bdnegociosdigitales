-- Consultas Simples con SQL-LMD

SELECT *
FROM Categories;

SELECT *
FROM Products;

SELECT *
FROM Orders;

SELECT *
FROM [Order Details];

-- Proyección (Seleccionar algunos campos)

SELECT
	ProductID,
	ProductName,
	UnitPrice,
	UnitsInStock
FROM Products;

-- Alias de Columnas

SELECT
	ProductID AS [NUMERO DE PRODUCTO],
	ProductName 'NOMBRE DE PRODUCTO',
	UnitPrice AS [PRECIO UNITARIO],
	UnitsInStock AS STOCK
FROM Products;

SELECT 
	CompanyName AS CLIENTE,
	City AS CIUDAD,
	Country AS PAIS
FROM Customers;

-- Campos Calculados

-- Seleccionar los productos y calcular el valor del inventario

SELECT *,(UnitPrice * UnitsInStock) AS [COSTO INVENTARIO]
FROM Products;

SELECT 
	ProductID,
	ProductName,
	UnitsInStock,
	(UnitPrice * UnitsInStock) AS [COSTO INVENTARIO]
FROM Products;

-- Calcular el Importe de Venta

SELECT 
	OrderID,
	ProductID,
	UnitPrice,
	Quantity,
	(UnitPrice * Quantity) AS IMPORTE
FROM [Order Details];

-- Seleccionar la Venta con el calculo del importe con descuento

SELECT 
    OrderID, 
    ProductID, 
    UnitPrice, 
    Quantity, 
    Discount,
    (UnitPrice * Quantity) AS IMPORTE,
    (UnitPrice * Quantity) * (1 - Discount) AS ImporteConDescuento
FROM [Order Details]

-- Operadores Relacionales (<, >, <=, >=, =, != o <>)

/*
	Seleccionar los productos con precio mayor a 30
	Seleccionar los productos con stock menor o igual a 20
	Seleccionar los pedidos posteriores a 1997
*/

SELECT 
	ProductID AS [Numero de Producto],
	ProductName AS [Nombre Producto],
	UnitPrice AS [Precio Unitario],
	UnitsInStock AS [Stock]
FROM Products
WHERE UnitPrice>30
ORDER BY UnitPrice DESC;

SELECT 
	ProductID AS [Numero de Producto],
	ProductName AS [Nombre Producto],
	UnitPrice AS [Precio Unitario],
	UnitsInStock AS Stock
FROM Products
WHERE UnitsInStock <= 20;

SELECT
	OrderID AS [Numero Orden],
	CustomerID AS [Nombre Cliente],
	OrderDate AS [Fecha de Orden],
	ShipCountry AS [Lugar de Entrega],
	YEAR(OrderDate) AS Año,
	MONTH(OrderDate) AS Mes,
	DAY(OrderDate) AS Dia,
	DATEPART(YEAR, OrderDate) AS AÑO2,
	DATEPART(QUARTER, OrderDate) AS Trimestre,
	DATEPART(WEEKDAY, OrderDate) AS [Dia Semana],
	DATENAME(WEEKDAY, OrderDate) AS [Dia Semana Nombre]
FROM Orders
WHERE YEAR(OrderDate) > 1997
ORDER BY OrderDate;

SELECT
	OrderID AS [Numero Orden],
	CustomerID AS [Nombre Cliente],
	OrderDate AS [Fecha de Orden],
	ShipCountry AS [Lugar de Entrega],
	YEAR(OrderDate) AS Año,
	MONTH(OrderDate) AS Mes,
	DAY(OrderDate) AS Dia,
	DATEPART(YEAR, OrderDate) AS AÑO2,
	DATEPART(QUARTER, OrderDate) AS Trimestre,
	DATEPART(WEEKDAY, OrderDate) AS [Dia Semana],
	DATENAME(WEEKDAY, OrderDate) AS [Dia Semana Nombre]
FROM Orders
WHERE DATEPART(YEAR, OrderDate) > 1997
ORDER BY OrderDate;

SET LANGUAGE SPANISH;
SELECT
	OrderID AS [Numero Orden],
	CustomerID AS [Nombre Cliente],
	OrderDate AS [Fecha de Orden],
	ShipCountry AS [Lugar de Entrega],
	YEAR(OrderDate) AS Año,
	MONTH(OrderDate) AS Mes,
	DAY(OrderDate) AS Dia,
	DATEPART(YEAR, OrderDate) AS AÑO2,
	DATEPART(QUARTER, OrderDate) AS Trimestre,
	DATEPART(WEEKDAY, OrderDate) AS [Dia Semana],
	DATENAME(WEEKDAY, OrderDate) AS [Dia Semana Nombre]
FROM Orders
WHERE YEAR(OrderDate) > 1997
ORDER BY OrderDate;

--  Operadores Lógicos (NOT, AND, OR)
/*
	Seleccionar los productos que tengan un precio mayor a 20 y menos de 100 unidades en stock
	Mostrar los clientes que sean de USA o de Canada
	Obtener los pedidos que no tengan región
*/

SELECT 
	ProductID AS [Numero Producto],
	ProductName AS [Nombre Producto],
	UnitPrice AS [Precio],
	UnitsInStock
FROM Products
WHERE UnitPrice > 20 AND UnitsInStock < 100
ORDER BY UnitPrice;

SELECT 
	CustomerID AS [Cliente ID],
	CompanyName AS [Nombre Compañia],
	City AS [Ciudad],
	Region AS [Region],
	Country AS [Pais]
FROM Customers
WHERE Country = 'USA' OR
	  Country = 'Canada'
ORDER BY Country;

SELECT 
	CustomerID,
	ShipCountry,
	ShipRegion
FROM Orders
WHERE ShipRegion IS NULL
ORDER BY ShipRegion;

-- Operador IN

/*
	Mostrar clientes de Alemania, Francia y UK
	Obtener los productos donde la categoria sea 1, 3 o 5
*/

SELECT *
FROM Customers
WHERE Country IN ('Germany', 'France', 'UK')
ORDER BY Country DESC;

SELECT *
FROM Customers
WHERE Country = 'Germany' OR
	  Country = 'France' OR
	  Country = 'UK'
ORDER BY Country DESC;

SELECT *
FROM Products
WHERE CategoryID IN (1, 3, 5)
ORDER BY CategoryID;

-- Operador Between

/*
	Mostrar los productos cuyo precio sea entre 20 y 40
*/

SELECT *
FROM Products
WHERE UnitPrice BETWEEN 20 AND 40
ORDER BY UnitPrice;
-- Es lo mismo 
SELECT *
FROM Products
WHERE UnitPrice >= 20 AND  UnitPrice <= 40
ORDER BY UnitPrice;

-- Seleccionar todos los clientes que comiencen con la letra A
SELECT 
	CustomerID,
	CompanyName,
	City,
	Region,
	Country
FROM Customers
WHERE CompanyName LIKE 'a%';

SELECT 
	CustomerID,
	CompanyName,
	City,
	Region,
	Country
FROM Customers
WHERE CompanyName LIKE 'an%';

SELECT 
	CustomerID,
	CompanyName,
	City,
	Region,
	Country
FROM Customers
WHERE City LIKE 'l_nd__%';

SELECT 
	CustomerID,
	CompanyName,
	City,
	Region,
	Country
FROM Customers
WHERE CompanyName LIKE '%as';

-- Seleccionar los clientes donde la ciudad contenga la letra L
SELECT 
	CustomerID,
	CompanyName,
	City,
	Region,
	Country
FROM Customers
WHERE City LIKE '%mé%';

-- Seleccionar todos los clientes que en su nombre comiencen con a o con b
SELECT 
	CustomerID,
	CompanyName,
	City,
	Region,
	Country
FROM Customers
WHERE NOT CompanyName LIKE 'a%' OR CompanyName LIKE 'b%';

SELECT 
	CustomerID,
	CompanyName,
	City,
	Region,
	Country
FROM Customers
WHERE NOT (CompanyName LIKE 'a%' OR CompanyName LIKE 'b%');

-- Seleccionar todos los clientes que comiencen con b y terminen con s
SELECT 
	CustomerID,
	CompanyName,
	City,
	Region,
	Country
FROM Customers
WHERE CompanyName LIKE 'b%s';

SELECT 
	CustomerID,
	CompanyName,
	City,
	Region,
	Country
FROM Customers
WHERE CompanyName LIKE '%a__%';

-- Seleccionar todos los clientes (Nombre) que comiencen con "b, s, p"
SELECT 
	CustomerID,
	CompanyName,
	City,
	Region,
	Country
FROM Customers
WHERE CompanyName LIKE '[bsp]%';

-- Seleccionar todos los clientes que comiencen con: "a", "b", "c", "d", "e" ó "f":
SELECT 
	CustomerID,
	CompanyName,
	City,
	Region,
	Country
FROM Customers
WHERE CompanyName LIKE '[abcdef]%';

SELECT 
	CustomerID,
	CompanyName,
	City,
	Region,
	Country
FROM Customers
WHERE CompanyName LIKE '[a-f]%'
ORDER BY 2 ASC;

SELECT 
	CustomerID,
	CompanyName,
	City,
	Region,
	Country
FROM Customers
WHERE CompanyName LIKE '[^bsp]%';

SELECT 
	CustomerID,
	CompanyName,
	City,
	Region,
	Country
FROM Customers
WHERE CompanyName LIKE '[^a-f]%'
ORDER BY 2 ASC;

-- Seleccionar todos los clientes de USA o Canada que inicien con B
SELECT 
	CustomerID,
	CompanyName,
	City,
	Region,
	Country
FROM Customers
WHERE Country IN ('USA', 'Canada') AND CompanyName LIKE 'b%';
