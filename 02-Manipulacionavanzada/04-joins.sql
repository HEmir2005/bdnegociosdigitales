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