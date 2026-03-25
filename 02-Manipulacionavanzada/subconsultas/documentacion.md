# ¿Qué es una subconsulta?

Una subconsulta (subquery) es un SELECT dentro de otro SELECT. Puede devolver:

1. Un solo valor (escalar)
1. Una lista de valores (una columna, varias filas)
1. Una tabla (varias columnas y/o varias filas)
1. Según lo que devuelva, se elige el operador correcto (=, IN, EXISTS, etc).

Una subconsulta es una consulta anidada dentro de otra consulta:
que permite resolver problemas en varios niveles de información

```
Dependiendo de donde se coloque y que retorne, cambia su comportamiento
```

5 grandes formas de usarlas:

1. Subconsultas escalares.
2. Subconsultas con IN, ANY, ALL.
3. Subconsultas correlacionadas.
4. Subconsultas en SELECT.
5. Subconsultas en FROM (Tablas derivadas).

## Escalares:

Devuelven un único valor, por eso se pueden utilizar con operadores =, <, >.

Ejemplo:

```sql
SELECT *
FROM Pedidos
WHERE total = (
	SELECT MAX(total)
	FROM Pedidos
);
```

## Subconsultas con IN, ANY, ALL.

Devuelve varios valores con una sola columna (IN)

> Seleccionar todos los clientes que han hecho pedidos
```sql
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
```

## Clausula ANY 

- Compara un valor contra una lista
- La condición se cumple si se cumple con AL MENOS UNO

```sql
valor > ANY (subconsulta)
```

> Es como decir: Mayor que al menos uno de los valores

- Seleccionar pedidos mayores que algún pedido de Luis (id_cliente=2)

```sql
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
```

## Clausula ALL
Se cumple contra todos los valores

```sql
valor > ALL (subconsulta)
```

Significa:

- Mayor que todos los valores

```sql
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
```

## Subconsultas correlacionadas

>Una subconsulta correlacionada depende de la fila actual de la consulta principal y se ejecuta una vez por cada fila

---

1. Seleccionar los clientes cuyo total de compras sea mayor a 1000