# MANUAL COMPLETO DE SQL

## Análisis y explicación detallada de los archivos:

-   01-sql-ldd.sql
-   02-consultassimples.sql
-   03-funciones_agregado.sql

------------------------------------------------------------------------

# INTRODUCCIÓN

Este manual documenta de forma detallada todas las instrucciones SQL
utilizadas en los tres archivos proporcionados. Se explican los
conceptos teóricos, la sintaxis utilizada, el objetivo de cada consulta
y ejemplos prácticos.

El contenido está dividido en tres grandes bloques:

1.  Lenguaje de Definición de Datos (DDL)
2.  Consultas Simples (SELECT)
3.  Funciones de Agregado y Agrupación

------------------------------------------------------------------------

# 1. LENGUAJE DE DEFINICIÓN DE DATOS (DDL)

El DDL permite crear y modificar la estructura de la base de datos.

## 1.1 DROP TABLE

``` sql
DROP TABLE products;
```

### ¿Qué hace?

Elimina completamente la tabla `products` junto con todos sus datos y
estructura.

⚠ Es una operación irreversible.

------------------------------------------------------------------------

## 1.2 CREATE TABLE

``` sql
CREATE TABLE products(
    product_id INT NOT NULL IDENTITY(1,1),
    [name] NVARCHAR (40) NOT NULL,
    quantity INT NOT NULL,
    unit_price MONEY NOT NULL,
    supplier_id INT
);
```

### Explicación detallada

-   `INT`: Tipo de dato entero.
-   `NVARCHAR(40)`: Texto Unicode hasta 40 caracteres.
-   `MONEY`: Tipo de dato monetario.
-   `IDENTITY(1,1)`: Campo autoincremental.
-   `NOT NULL`: No permite valores vacíos.

------------------------------------------------------------------------

## 1.3 Restricciones (CONSTRAINTS)

Las restricciones garantizan la integridad de los datos.

### - PRIMARY KEY

``` sql
CONSTRAINT pk_products PRIMARY KEY (product_id)
```

Garantiza unicidad y evita valores NULL.

------------------------------------------------------------------------

### - UNIQUE

``` sql
CONSTRAINT unique_name_products UNIQUE ([name])
```

Evita registros duplicados en el campo `name`.

------------------------------------------------------------------------

### - CHECK

``` sql
CHECK (credit_limit > 0.0 AND credit_limit <= 50000)
```

Valida que los datos estén dentro de rangos permitidos.

------------------------------------------------------------------------

### - FOREIGN KEY

``` sql
FOREIGN KEY (supplier_id)
REFERENCES suppliers (supplier_id)
ON DELETE SET NULL
ON UPDATE SET NULL
```

Mantiene la relación entre productos y proveedores.

Si un proveedor se elimina: → El `supplier_id` del producto se convierte
en NULL.

------------------------------------------------------------------------

## 1.4 ALTER TABLE

``` sql
ALTER TABLE products
ALTER COLUMN supplier_id INT NULL;
```

Permite modificar una columna ya creada.

------------------------------------------------------------------------

## 1.5 INSERT

``` sql
INSERT INTO products
VALUES ('Papas', 10, 5.3, 1);
```

Inserta un nuevo registro en la tabla.

------------------------------------------------------------------------

# 2️. CONSULTAS SIMPLES (SELECT)

El SELECT permite recuperar información de la base de datos.

------------------------------------------------------------------------

## 2.1 SELECT \*

``` sql
SELECT * FROM Products;
```

Muestra todas las columnas y registros.

------------------------------------------------------------------------

## 2.2 Selección específica de columnas

``` sql
SELECT ProductID, ProductName, UnitPrice
FROM Products;
```

Mejora rendimiento mostrando solo lo necesario.

------------------------------------------------------------------------

## 2.3 Alias

``` sql
SELECT ProductID AS [NUMERO DE PRODUCTO]
FROM Products;
```

Permite renombrar columnas en el resultado.

------------------------------------------------------------------------

## 2.4 Campos calculados

``` sql
SELECT (UnitPrice * UnitsInStock) AS [COSTO INVENTARIO]
FROM Products;
```

Permite realizar operaciones matemáticas en consultas.

------------------------------------------------------------------------

## 2.5 WHERE

``` sql
WHERE UnitPrice > 30
```

Filtra resultados bajo una condición.

------------------------------------------------------------------------

## 2.6 Operadores Lógicos

``` sql
WHERE UnitPrice > 20 AND UnitsInStock < 100
```

Combina múltiples condiciones.

------------------------------------------------------------------------

## 2.7 BETWEEN

``` sql
WHERE UnitPrice BETWEEN 20 AND 40
```

Incluye ambos valores extremos.

------------------------------------------------------------------------

## 2.8 IN

``` sql
WHERE Country IN ('Germany', 'France', 'UK')
```

Simplifica múltiples comparaciones OR.

------------------------------------------------------------------------

## 2.9 LIKE

``` sql
WHERE CompanyName LIKE 'a%'
```

Permite búsquedas por patrón.

-   `'a%'` → Empieza con A
-   `'%a'` → Termina con A
-   `'%a%'` → Contiene A

------------------------------------------------------------------------

# 3️. FUNCIONES DE AGREGADO

Se utilizan para realizar cálculos sobre conjuntos de datos.

------------------------------------------------------------------------

## 3.1 DISTINCT

``` sql
SELECT DISTINCT Country FROM Customers;
```
Selecciona los paises de donde son los clientes.

------------------------------------------------------------------------

## 3.2 COUNT

``` sql
SELECT COUNT(*) FROM Orders;
```

Cuenta el total de registros.

------------------------------------------------------------------------

## 3.3 MAX y MIN (Con ejemplo de DATEPART)

``` sql
SELECT MAX(UnitPrice) FROM Products;
SELECT MIN(Quantity) FROM [Order Details];
```

Selecciona el precio máximo de los productos.
Cual es la minima cantidad de los pedidos.

``` sql
SELECT MAX(DATEPART(YEAR, OrderDate)) AS [Año mas reciente] FROM Orders;
```

Seleccionar el año de la fecha de compra mas reciente.

------------------------------------------------------------------------

Obtiene valores extremos.

## 3.4 SUM

``` sql
SELECT SUM(UnitPrice * Quantity * (1-Discount))
FROM [Order Details];
```

Calcula el total de ventas considerando descuentos.

------------------------------------------------------------------------

## 3.5 AVG

``` sql
SELECT AVG(UnitPrice) FROM Products;
```

Calcula el promedio.

------------------------------------------------------------------------

## 3.6 GROUP BY

``` sql
SELECT ShipCountry, COUNT(*)
FROM Orders
GROUP BY ShipCountry;
```

Agrupa resultados por columna.

------------------------------------------------------------------------

## 3.7 INNER JOIN

``` sql
SELECT Customers.CompanyName, COUNT(*) AS [Numero de Ordenes] FROM Orders
INNER JOIN Customers
ON Orders.CustomerID = Customers.CustomerID
GROUP BY Customers.CompanyName;
```

Selecciona un dato que existe en dos tablas.
Nota: Siempre que haya un INNER JOIN, debe tener un ON

------------------------------------------------------------------------

## 3.8 HAVING

``` sql
GROUP BY CustomerID
HAVING COUNT(*) > 10;
```

Filtra resultados agrupados.

------------------------------------------------------------------------

# CONCLUSIÓN GENERAL

Este conjunto de archivos demuestra:

✔ Creación estructural de bases de datos\
✔ Aplicación de integridad referencial\
✔ Consultas con filtros avanzados\
✔ Cálculos financieros\
✔ Agrupación y análisis de datos

El dominio de estos conceptos es fundamental para el desarrollo de
sistemas de información y análisis de bases de datos relacionales.

------------------------------------------------------------------------