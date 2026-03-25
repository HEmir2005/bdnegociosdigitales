/**
	JOINS

	1. INNER JOIN
	2. LEFT JOIN
	3. RIGHT JOIN
	4. FULL JOIN
**/

-- SELECCIONAR LAS CATEGORIAS Y SUS PRODUCTOS

SELECT 
	Categories.CategoryID,
	Categories.CategoryName,
	Products.ProductID,
	Products.ProductName,
	Products.UnitPrice,
	Products.UnitsInStock,
	(Products.UnitPrice * Products.UnitsInStock) AS [PRECIO INVENTARIO]
FROM Categories
INNER JOIN Products
ON Categories.CategoryID = Products.CategoryID
WHERE Categories.CategoryID = 9;

-- Crear una tabla a partir de una consulta

SELECT TOP 0
	CategoryID,
	CategoryName
INTO CATEGORIA
FROM Categories;

ALTER TABLE CATEGORIA
ADD CONSTRAINT pk_categoria
PRIMARY KEY (CategoryId);

INSERT INTO CATEGORIA
VALUES ('C1'), ('C2'), ('C3'), ('C4'), ('C5');

SELECT TOP 0
	ProductId AS [Numero_Producto],
	ProductName AS [Nombre_Producto],
	CategoryID AS [Catego_Id]
INTO producto
FROM Products;

ALTER TABLE producto
ADD CONSTRAINT pk_producto
PRIMARY KEY (numero_producto);

ALTER TABLE producto
ADD CONSTRAINT fk_producto_categoria
FOREIGN KEY (catego_id)
REFERENCES categoria (CategoryID)
ON DELETE CASCADE;

INSERT INTO producto
VALUES ('P1', 1), ('P2', 1), ('P3', 2), ('P4', 2), ('P5', 3), ('P6', NULL);

-- INNER JOIN

SELECT *
FROM CATEGORIA AS c
INNER JOIN
producto AS p
ON c.CategoryID = p.Catego_Id;

-- LEFT JOIN

SELECT *
FROM CATEGORIA AS c
LEFT JOIN
producto AS p
ON c.CategoryID = p.Catego_Id;

-- RIGHT JOIN

SELECT *
FROM CATEGORIA AS c
RIGHT JOIN
producto AS p
ON c.CategoryID = p.Catego_Id;

-- FULL JOIN

SELECT *
FROM CATEGORIA AS c
FULL JOIN
producto AS p
ON c.CategoryID = p.Catego_Id;

-- Simular el RIGHT JOIN del query anterior con un LEFT JOIN

SELECT 
	c.CategoryID, 
	c.CategoryName, 
	p.Numero_Producto, 
	p.Nombre_Producto, 
	p.Catego_Id
FROM CATEGORIA AS c
RIGHT JOIN
producto AS p
ON c.CategoryID = p.Catego_Id;

SELECT
	c.CategoryID, 
	c.CategoryName, 
	p.Numero_Producto, 
	p.Nombre_Producto, 
	p.Catego_Id
FROM producto AS p
LEFT JOIN
CATEGORIA AS c
ON c.CategoryID = p.Catego_Id;

-- Visulaizar todas las categorias que no tienen productos

SELECT
	c.CategoryID, 
	c.CategoryName, 
	p.Numero_Producto, 
	p.Nombre_Producto, 
	p.Catego_Id
FROM CATEGORIA AS c
LEFT JOIN
producto AS p
ON c.CategoryID = p.Catego_Id
WHERE Numero_Producto IS NULL;

-- Seleccionar todos los productos que no tienen Categoria

SELECT
	c.CategoryID, 
	c.CategoryName, 
	p.Numero_Producto, 
	p.Nombre_Producto, 
	p.Catego_Id
FROM CATEGORIA AS c
RIGHT JOIN
producto AS p
ON c.CategoryID = p.Catego_Id
WHERE Catego_Id IS NULL;

SELECT
	c.CategoryID, 
	c.CategoryName, 
	p.Numero_Producto, 
	p.Nombre_Producto, 
	p.Catego_Id
FROM producto AS p
LEFT JOIN
CATEGORIA AS c
ON c.CategoryID = p.Catego_Id
WHERE Catego_Id IS NULL;

SELECT *
FROM CATEGORIA;

SELECT *
FROM producto;

-- Guardar en una tabla de productos nuevos, todos aquellos productos que fueron agregados recientemente
-- y no estan en la tabla de apoyo


-- Crear la tabla "products_new" a partir de "products", mediante una consulta
SELECT
	TOP 0
	ProductID AS [product_number],
	ProductName AS [product_name],
	UnitPrice AS [unit_price],
	UnitsInStock AS [stock],
	(UnitPrice * UnitsInStock) AS [total]
INTO products_new
FROM Products;

ALTER TABLE products_new
ADD CONSTRAINT pk_products_new
PRIMARY KEY ([product_number]);

SELECT
	p.ProductID,
	p.ProductName,
	p.UnitPrice,
	p.UnitsInStock,
	(p.UnitPrice * p.UnitsInStock) AS [total],
	pw.*
FROM Products AS p
LEFT JOIN products_new AS pw
ON p.ProductID = pw.product_number;

SELECT
	p.ProductID,
	p.ProductName,
	p.UnitPrice,
	p.UnitsInStock,
	(p.UnitPrice * p.UnitsInStock) AS [total],
	pw.*
FROM Products AS p
INNER JOIN products_new AS pw
ON p.ProductID = pw.product_number;

INSERT INTO products_new
SELECT
	p.ProductName,
	p.UnitPrice,
	p.UnitsInStock,
	(p.UnitPrice * p.UnitsInStock) AS [total]
FROM Products AS p
LEFT JOIN products_new AS pw
ON p.ProductID = pw.product_number
WHERE pw.product_number IS NULL;


SELECT *
FROM products_new;