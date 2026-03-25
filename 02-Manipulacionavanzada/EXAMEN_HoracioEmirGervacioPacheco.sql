-- B1
SELECT
	c.Num_Cli AS [Numero_Cliente],
	c.Empresa AS [Nombre_Empresa],
	re.Nombre AS [Nombre_del_Representante],
	c.Limite_Credito AS [Limite_de_Credito]
FROM Clientes AS c
INNER JOIN Representantes AS re
ON c.Rep_Cli = re.Num_Empl
WHERE c.Limite_Credito >= 40000
AND C.Empresa LIKE '%S.A%'
ORDER BY c.Limite_Credito DESC;

-- B2
SELECT 
	p.Descripcion AS [Descripcion],
	p.Precio AS [Precio],
	p.Stock AS [Stock],
	(p.Precio * p.Stock) AS [ValorInventario]
FROM Productos AS p
WHERE p.Stock BETWEEN 10 AND 40
AND P.Precio BETWEEN 100 AND 5000
ORDER BY ValorInventario DESC;

-- B3
SELECT 
	p.Num_Pedido AS [Numero_Pedido],
	p.Fecha_Pedido AS [Fecha_Pedido],
	c.Empresa AS [Nombre_Empresa],
	p.Importe AS [Importe]
FROM Pedidos AS p
INNER JOIN Clientes AS c
ON p.Cliente = c.Num_Cli
WHERE c.Empresa LIKE '%Ltd%'
ORDER BY p.Fecha_Pedido ASC;

-- B4
SELECT 
	o.Oficina AS [Nombre_Oficina],
	o.Ciudad AS [Ciudad_Oficina],
	o.Region AS [Region_Oficina],
	AVG(o.Ventas) AS [PromedioVentasRep]
FROM Oficinas AS o
GROUP BY o.Oficina, o.Ciudad, o.Region
ORDER BY PromedioVentasRep DESC;

-- B5
SELECT
	c.Num_Cli AS [Numero_Cliente],
	c.Empresa AS [Nombre_Empresa],
	COUNT(*) AS [NumPedidos]
FROM Clientes AS c
INNER JOIN Pedidos AS p
ON c.Num_Cli = p.Cliente
GROUP BY c.Num_Cli, c.Empresa
HAVING COUNT(*) >= 2
ORDER BY NumPedidos DESC,
c.Empresa ASC;

-- B6
SELECT
	o.Ciudad,
	o.Region,
	SUM(r.Ventas) AS [TotalVentasReps],
	COUNT (*) AS [NumReps]
FROM Oficinas AS o
INNER JOIN Representantes AS r
ON o.Jef = r.Num_Empl
GROUP BY o.Ciudad, o.Region
ORDER BY TotalVentasReps DESC;

-- B7
CREATE OR ALTER VIEW vw_ClientesRepOficina_B
AS
SELECT
	c.Num_Cli AS [Numero_Cliente],
	c.Empresa AS [Nombre_Empresa],
	c.Limite_Credito AS [Limite_Credito],
	r.Nombre AS [NombreRep],
	r.Puesto AS [PuestoRep],
	o.Ciudad AS [Ciudad_Oficina],
	o.Region AS [Region_Oficina]
FROM Clientes AS c
INNER JOIN Representantes AS r
ON c.Rep_Cli = r.Num_Empl
INNER JOIN Oficinas AS o
ON r.Num_Empl = o.Jef

SELECT * FROM vw_ClientesRepOficina_B

-- B8

CREATE OR ALTER VIEW vw_VentasPorCliente
AS
SELECT
	c.Num_Cli AS [Numero_Cliente],
	c.Empresa AS [Nombre_Empresa],
	SUM(Importe) AS [TotalImporte],
	COUNT(Num_Pedido) AS [NumPedidos]
FROM Clientes AS c
INNER JOIN Pedidos AS p
ON c.Num_Cli = p.Cliente
GROUP BY c.Num_Cli, c.Empresa
HAVING SUM(Importe) >= 30000