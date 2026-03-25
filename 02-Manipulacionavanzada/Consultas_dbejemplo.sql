/*
Clientes - Num_Cli
Oficinas - Oficina
Pedidos - Num_Pedido
Productos - Id_producto, Id_fab
Representantes - Num_Empl
---------------------------------
Clientes - Rep_Cli -> Representantes - Num_Empl
Oficinas - Jef -> Representantes - Num_Empl
Pedidos - Cliente -> Clientes - Num_Cli
Pedidos - Rep -> Representantes - Num_Empl
Pedidos - Fab, Producto -> Productos - Id_fab, Id_producto
Representantes - Oficina_Rep -> Oficinas - Oficina
Representantes - Jefe -> Representantes - Num_Empl
*/
USE bdejemplo

SELECT * FROM Clientes;
SELECT * FROM Representantes;
SELECT * FROM Oficinas;
SELECT * FROM Productos;
SELECT * FROM Pedidos;

-- Crear una vista que visualice el total de los importes agrupados por productos
-- Nota: En una vista una columna no se puede quedar sin nombre

CREATE OR ALTER VIEW vw_importes_productos
AS
SELECT
	pr.Descripcion AS [Nombre del Producto],
	SUM(p.Importe) AS [Total],
	SUM(p.Importe * 1.15) AS [Importe Descuento]
FROM Pedidos AS p
INNER JOIN Productos AS pr
ON p.Fab = pr.Id_fab
AND p.Producto = pr.Id_producto
GROUP BY pr.Descripcion;

SELECT * FROM vw_importes_productos
WHERE [Nombre del Producto] LIKE '%brazo'
AND [Importe Descuento] > 34000;

-- Seleccionar los nombres de los representantes y las oficinas donde trabajan 


CREATE OR ALTER VIEW vw_oficinas_representantes
AS
SELECT
	r.Ventas AS [Ventas_Representantes],
	r.Nombre,
	o.Oficina,
	o.Ciudad,
	o.Region,
	o.Ventas AS [Ventas_Oficinas]
FROM Representantes AS r
INNER JOIN Oficinas AS o
ON r.Oficina_Rep = o.Oficina;

SELECT *
FROM Representantes
WHERE Nombre = 'Daniel Ruidrobo';

SELECT
	Nombre,
	Ciudad
FROM vw_oficinas_representantes
ORDER BY Nombre DESC;

-- Seleccionar los pedidos con fecha en importe, el nombre del representante que lo realizo 
-- y al cliente que lo solicit�

SELECT
	p.Num_Pedido,
	p.Fecha_Pedido,
	p.Importe,
	c.Empresa,
	r.Nombre
FROM Pedidos AS p
INNER JOIN Clientes AS c
ON c.Num_Cli = p.Cliente
INNER JOIN Representantes AS r
ON r.Num_Empl = p.Rep;

-- Seleccionar los pedidos con fecha en importe, el nombre del representante que atendi� al cliente 
-- y al cliente que lo solicit�

SELECT
	p.Num_Pedido,
	p.Fecha_Pedido,
	p.Importe,
	c.Empresa,
	r.Nombre
FROM Pedidos AS p
INNER JOIN Clientes AS c
ON c.Num_Cli = p.Cliente
INNER JOIN Representantes AS r
ON r.Num_Empl = c.Rep_Cli;