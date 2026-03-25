# Stored Procedures (Procedimientos Almacenados) en Transact-SQL (SQL SERVER)

1. Fundamentos

- ¿Qué es un Stored Procedure?

Un **Stored Procedure (SP)** es un bloque de código SQL guardado dentro de la base de datos que puede ejecutarse cuando se necesite. Es decir es un **OBJETO DE LA BD**

Es similar a una función o método en programación.

Ventajas

1. Reutilizar el código
2. Mejor Rendimiento
3. Mayor seguridad
4. Centralización de lógica de negocio
5. Menos tráfico entre aplicación y servidor

- Sintaxis

![SintaxisSQL](../../img/sp_sintaxis.png)

- Nomenclatura Recomendada

```
spu_<Entidad>_<Acción>
```

| Parte   | Significado                     | Ejemplo |
|--------|---------------------------------|--------|
| spu    | Stored Procedure User           | spu_   |
| Entidad| Tabla o concepto del negocio    | Cliente|
| Acción | Lo que hace                     | Insert |

- Acciones Estándar

Estas son las **acciones más usadas** en sistemas empresariales

| Acción     | Significado          | Ejemplo                |
| ---------- | -------------------- | ---------------------- |
| Insert     | Insertar registro    | spu_Cliente_Insert     |
| Update     | Actualizar           | spu_Cliente_Update     |
| Delete     | Eliminar             | spu_Cliente_Delete     |
| Get        | Obtener uno          | spu_Cliente_Get        |
| List       | Obtener varios       | spu_Cliente_List       |
| Search     | Búsqueda con filtros | spu_Cliente_Search     |
| Exists     | Validar si existe    | spu_Cliente_Exists     |
| Activate   | Activar registro     | spu_Cliente_Activate   |
| Deactivate | Desactivar           | spu_Cliente_Deactivate |

- Ejemplo completo

Suponer que tenemos una tabla cliente

🤖 Insertar Cliente 
```
spu_Cliente_Insert
```

🤖 Actualizar Cliente 
```
spu_Cliente_Update
```

🤖 Obtener Cliente por ID 
```
spu_Cliente_Get
```

🤖 Listar todos los Clientes 
```
spu_Cliente_List
```

🤖 Buscar Cliente 
```
spu_Cliente_Search
```

```
/*================ Stored Procedures ================*/

CREATE DATABASE bdstored;
GO

USE bdstored;
GO


-- Ejemplo Simple

CREATE PROCEDURE usp_Mensaje_Saludar
    -- No tendra parametros
AS
BEGIN
    PRINT 'Hola Mundo Transact SQL desde SQL Server';
END;
GO

-- Ejecutar
EXECUTE usp_Mensaje_Saludar;
GO

CREATE PROC usp_Mensaje_Saludar2
    -- No tendra parametros
AS
BEGIN
    PRINT 'Hola Mundo Ing en TI';
END;
GO

-- Ejecutar
EXEC usp_Mensaje_Saludar2;
GO

CREATE OR ALTER PROC usp_Mensaje_Saludar3
    -- No tendra parametros
AS
BEGIN
    PRINT 'Hola Mundo ENTORNOS VIRTUALES Y NEGOCIOS DIGITALES';
END;
GO

-- ELIMINAR UN SP
DROP PROC usp_Mensaje_Saludar3;
GO

-- Ejecutar
EXEC usp_Mensaje_Saludar3;
GO

-- Crear un SP que muestre la fecha actual del sistema
CREATE OR ALTER PROC usp_Servidor_FechaActual

AS
BEGIN
    SELECT CAST(GETDATE() AS DATE) AS [FECHA DEL SISTEMA];
END;
GO

-- Ejecutarlo
EXEC usp_Servidor_FechaActual;
GO

-- Crear un SP que muestre el nombre de la base de datos (DB_NAME())
CREATE OR ALTER PROC spu_DBname_get
AS
BEGIN
    SELECT 
        HOST_NAME() AS [MACHINE],
        SUSER_NAME() AS [SQLUSER],
        SYSTEM_USER AS [SYSTEMUSER],
        DB_NAME() AS [DATABASE NAME],
        APP_NAME() AS [APPLICATION];
END;
GO


-- Ejecutarlo
EXEC spu_DBname_get;
GO
```


2. Parámetros en Stored Procedures

Los parametros permiten enviar datos al procedimiento

```sql
/*=========================== STORED PROCEDURES CON PARAMETROS ===========================*/

CREATE OR ALTER PROC usp_persona_saludar
    @nombre VARCHAR(50) -- Parametro de entrada
AS 
BEGIN
    PRINT 'Hola ' + @nombre;
END;
GO

EXEC usp_persona_saludar 'Israel';
EXEC usp_persona_saludar 'Artemio';
EXEC usp_persona_saludar 'Irais';
EXEC usp_persona_saludar @nombre = 'Bryan';

DECLARE @name VARCHAR(50);
SET @name = 'Yael';

EXEC usp_persona_saludar @name;
```

```sql
/*TODO: Ejemplo con consultas, vamos a crear una tabla de clientes basada en la tabla de customers de NORTHWIND*/

SELECT CustomerID, CompanyName
INTO Customers
FROM NORTHWND.dbo.Customers;
GO
-- Crear un SP que busque un cliente en espec�fico

CREATE OR ALTER PROC spu_Customer_buscar
@id NCHAR(10)
AS 
BEGIN

    SET @id = TRIM(@id);

    IF LEN(@id)<=0 OR LEN(@id)>5
    BEGIN
        PRINT ('El ID debe estar en el rango de 1 a 5 de tama�o');
        RETURN;
    END

    IF NOT EXISTS (SELECT 1 FROM Customers WHERE CustomerID = @id)
    BEGIN
        PRINT 'El cliente no existe en la BD';
        RETURN;
    END


    SELECT CustomerID AS [Numero], CompanyName AS [Cliente]
    FROM Customers
    WHERE CustomerID = @id;
END
GO

SELECT *
FROM Customers
WHERE CustomerID = 'ANTON';

-- Ejecutar
EXEC spu_Customer_buscar 'ANTON';


SELECT 'HOLAAA'
WHERE NOT EXISTS(
SELECT 1
FROM Customers
WHERE CustomerID = 'ANTON');
GO
-- Ejercicios: Crear un SP que reciba un número y que verifque que no sea negativo, si es negativo imprimir valo no valido,
-- sino multiplicarlo por cinco y mostrar el resultado para mosrtar un SELECT

CREATE OR ALTER PROCEDURE usp_numero_multiplicar
@number INT
AS 
BEGIN
    IF @number <= 0
    BEGIN
        PRINT 'El numero no puede ser negativo ni cero'
        RETURN;
    END

    SELECT (@number * 5) AS [OPERACION];
END;
GO

EXEC usp_numero_multiplicar -34;
EXEC usp_numero_multiplicar 8;
EXEC usp_numero_multiplicar 5;
GO

-- EJERCICIO 2: Crear un SP que reciba un nombre 

CREATE OR ALTER PROC usp_nombre_mayusculas
@name VARCHAR(15)
AS
BEGIN
    SELECT UPPER(@name) AS [NAME];
END;
GO

EXEC usp_nombre_mayusculas 'Monico';
```

3. Parámetros de Salida

Los parametros OUTPUT devuelven valores al usuario
```sql
/* ================================== PARAMETROS DE SALIDA ================================== */

CREATE OR ALTER PROC spu_numeros_sumar
    @a INT,
    @b INT,
    @resultado INT OUTPUT
    AS
    BEGIN
        SET @resultado = @a + @b;
    END;
GO

DECLARE @res INT;
EXEC spu_numeros_sumar 5, 7, @res OUTPUT;
SELECT @res AS [RESULTADO];
GO

CREATE OR ALTER PROC spu_numeros_sumar2
    @a INT,
    @b INT,
    @resultado INT OUTPUT
    AS
    BEGIN
        SELECT @resultado = @a + @b;
    END;
GO

DECLARE @res INT;
EXEC spu_numeros_sumar2 5, 7, @res OUTPUT;
SELECT @res AS [RESULTADO];
GO

-- Crear un SP que devuelva el área de un circulo
CREATE OR ALTER PROC usp_area_circulo
@radio DECIMAL(10,2),
@area DECIMAL(10,2) OUTPUT
AS
BEGIN
    --SET @area = PI() * @radio * @radio;
    SET @area = PI() * POWER(@radio, 2);
END;
GO

DECLARE @r DECIMAL(10,2);
EXEC usp_area_circulo 2.4, @r OUTPUT;
SELECT @r AS [AREA DEL CIRCULO];
GO

-- Crear un SP que reciba un ID del cliente y devuelva el nombre

CREATE OR ALTER PROC spu_cliente_obtener
    @id NCHAR(10),
    @name NVARCHAR(40) OUTPUT
AS
BEGIN
    IF LEN(@id) = 5
    BEGIN
        IF EXISTS (SELECT 1 FROM Customers WHERE CustomerID = @id)
        BEGIN
            SELECT @name = CompanyName
            FROM Customers
            WHERE CustomerID = @id;

            RETURN;
        END

        PRINT 'El cliente no existe en la BD';
        RETURN;
    END

    PRINT 'El ID debe tener 5 caracteres';
END;
GO 

DECLARE @name NVARCHAR(40);
EXEC spu_cliente_obtener 'ANTOm', @name OUTPUT;
SELECT @name AS [NOMBRE DEL CLIENTE];
GO
```

4. CASE
Sirve para evaluar condiciones como un switch o if multiple
```sql
SELECT 
    nombre,
    precio,
    CASE 
        WHEN precio >= 200 THEN 'Ta caro'
        WHEN precio >= 100 THEN 'Ta medio'
        ELSE 'Ta barato'
    END AS [Categoria]
FROM bdstored.dbo.Productos;

/*
    Selecciona los clientes, con su nombre, pais, ciudad y region (Los valores nulos, visualizalos con la leyenda sin region), 
    ademas quiero que todo el resultado sea en mayuscula
*/

USE NORTHWND;
GO


CREATE OR ALTER VIEW vw_buena
AS
SELECT
    UPPER(CompanyName) AS [CompanyName],
    UPPER(c.Country) AS [Country],
    UPPER(c.City) AS [City],
    UPPER(ISNULL(c.Region, 'Sin region')) AS [RegionLimpia],
    LTRIM(UPPER(CONCAT(e.FirstName, ' ', e.LastName))) AS [FullName],
    ROUND(SUM(od.Quantity * od.UnitPrice), 2) AS [Total],
    CASE 
        WHEN SUM(od.Quantity * od.UnitPrice) >= 30000 AND SUM(od.Quantity * od.UnitPrice) <= 60000 THEN 'GOLD'
        WHEN SUM(od.Quantity * od.UnitPrice) >= 10000 AND SUM(od.Quantity * od.UnitPrice) < 30000 THEN 'SILVER'
        ELSE 'BRONCE'
    END AS [Medallon]
FROM NORTHWND.dbo.Customers AS c
INNER JOIN 
NORTHWND.dbo.Orders AS o
ON c.CustomerID = o.CustomerID
INNER JOIN [Order Details] AS od
ON o.OrderID = od.OrderID
INNER JOIN Employees AS e
ON e.EmployeeID = o.EmployeeID
GROUP BY c.CompanyName, c.Country, c.City, c.Region, CONCAT(e.FirstName, ' ', e.LastName);
GO

CREATE OR ALTER PROC spu_informe_clientes_empleados
@nombre VARCHAR(50),
@region VARCHAR(50)
AS
BEGIN
    SELECT * 
        FROM vw_buena
        WHERE FullName = @nombre
        AND RegionLimpia = @region;
END;

EXEC spu_informe_clientes_empleados 'ANDREW FULLER', 'Sin region' 


SELECT
    UPPER(CompanyName) AS [CompanyName],
    UPPER(c.Country) AS [Country],
    UPPER(c.City) AS [City],
    UPPER(ISNULL(c.Region, 'Sin region')) AS [RegionLimpia],
    LTRIM(UPPER(CONCAT(e.FirstName, ' ', e.LastName))) AS [FullName],
    ROUND(SUM(od.Quantity * od.UnitPrice), 2) AS [Total],
    CASE 
        WHEN SUM(od.Quantity * od.UnitPrice) >= 30000 AND SUM(od.Quantity * od.UnitPrice) <= 60000 THEN 'GOLD'
        WHEN SUM(od.Quantity * od.UnitPrice) >= 10000 AND SUM(od.Quantity * od.UnitPrice) < 30000 THEN 'SILVER'
        ELSE 'BRONCE'
    END AS [Medallon]
FROM NORTHWND.dbo.Customers AS c
INNER JOIN 
NORTHWND.dbo.Orders AS o
ON c.CustomerID = o.CustomerID
INNER JOIN [Order Details] AS od
ON o.OrderID = od.OrderID
INNER JOIN Employees AS e
ON e.EmployeeID = o.EmployeeID
WHERE 
    UPPER(CONCAT(e.FirstName, ' ', e.LastName)) = UPPER('ANDREW FULLER')
    AND UPPER(ISNULL(c.Region, 'Sin region')) = UPPER('SIN REGION')
GROUP BY c.CompanyName, c.Country, c.City, c.Region, CONCAT(e.FirstName, ' ', e.LastName)
ORDER BY FULLNAME, Total DESC; 
```

5. Try ... Catch

Manejo de Errores o exepciones en tiempo de ejecución y manejar lo que sucede cuando ocurren.

SINTAXIS

```SQL
    BEGIN TRY
        -- Código que puede generar un error
    END TRY
    BEGIN CATCH
        -- Código que se ejecuta si ocurre un error 
    END CATCH
```

- ¿COMO FUNCIONA?🤔🤔

1. SQL ejecuta todo lo que esta dentro del TRY
2. Si ocurre un error:
    - Se detiene la ejecución del TRY
    - Salta automáticamente al CATCH
3. En el CATCH se puede:
    - Mostrar mensajes
    - Registrar errores
    - Revertir transacciones

**OBTENER INFORMACIÓN DEL ERROR**

Dentro del CATCH, SQL SERVER tiene funciones especiales:

| Función | Descripción |
| :--- | :--- |
| ERROR_MESSAGE() | Mensaje de error |
| ERROR_NUMBER() | Número de error |
| ERROR_LINE() | Linea dónde ocurrió |
| ERROR_PROCEDURE() | Procedimiento |
| ERROR_SEVERITY() | Nivel de Gravedad |
| ERROR_STATE() | Estado del Error |

```sql
/*====================================== MANEJO DE ERRORES CON TRY ... CATCH ==================================*/

-- Sin TRY - CATCH
SELECT 10/0;

-- Con TRY - CATCH
BEGIN TRY
    SELECT  10/0;
END TRY
BEGIN CATCH
    PRINT 'Ocurrio un Error';
END CATCH
GO

-- Ejemplo de uso de funciones para obtener información del error
BEGIN TRY
    SELECT 10/0;
END TRY
BEGIN CATCH
    PRINT 'Mensaje: ' + ERROR_MESSAGE();
    PRINT 'Numero de error: ' + CAST(ERROR_NUMBER() AS VARCHAR);
    PRINT 'Linea de error: ' + CAST(ERROR_LINE() AS VARCHAR);
    PRINT 'Estado del error: ' + CAST(ERROR_STATE() AS VARCHAR);
END CATCH


CREATE TABLE clientes(
    id INT PRIMARY KEY,
    nombre VARCHAR(35)
);
GO

INSERT INTO clientes
VALUES(1, 'PANFILO');
GO

BEGIN TRY
    INSERT INTO clientes
    VALUES(1, 'EUSTACIO');
END TRY
BEGIN CATCH
    PRINT 'ERROR AL INSERTAR: ' + ERROR_MESSAGE();
    PRINT 'ERROR EN LA LINEA: ' + CAST(ERROR_LINE() AS VARCHAR);
END CATCH
GO

BEGIN TRANSACTION;

INSERT INTO clientes
VALUES(2, 'AMERICO ANGEL');

SELECT * FROM clientes;

COMMIT;
ROLLBACK;

-- Ejemplo de uso de transacciones junto con el Try Catch

SELECT * FROM clientes;

BEGIN TRY
    BEGIN TRANSACTION;

    INSERT INTO clientes 
    VALUES (3, 'VALDERABANO');
    INSERT INTO clientes
    VALUES (4, 'ROLES ALINA');

    COMMIT;

END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 1
    BEGIN
        ROLLBACK;
    END
        PRINT 'Se hizo ROLLBACK por error'
        PRINT 'ERROR: ' + ERROR_MESSAGE();
END CATCH
GO

-- Crear un STORE PROCEDURE que inserte un cliente, con las validaciones necesarias

CREATE OR ALTER PROCEDURE usp_insertar_cliente
    @id INT,
    @nombre VARCHAR(35)
AS 
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;
        INSERT INTO clientes
        VALUES (@id, @nombre);
        COMMIT;
        PRINT 'CLIENTE INSERTADO';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT < 1
            BEGIN
                ROLLBACK;
            END
            PRINT 'ERROR: ' + ERROR_MESSAGE();
    END CATCH
END;

SELECT * FROM clientes;

UPDATE clientes
SET nombre = 'AMERICO AZUL'
WHERE id = 2;

IF @@ROWCOUNT < 1
BEGIN
    PRINT @@ROWCOUNT;
    PRINT 'No existe el cliente';
END
ELSE
    PRINT 'Cliente Actualizado';


CREATE TABLE teams    
(
    id INT NOT NULL IDENTITY PRIMARY KEY,
    nombre NVARCHAR(15)
);

SELECT * FROM teams;

INSERT INTO teams (nombre)
VALUES ('ÁGUILAS');

-- FORMA DE OBTENER UN IDENTITY INSERTADO FORMA 1
DECLARE @id_insertado INT
SET @id_insertado = @@IDENTITY
PRINT 'ID INSERTADO: ' + CAST(@id_insertado AS VARCHAR);
SELECT @id_insertado = @@IDENTITY
PRINT 'ID INSERTADO FORMA 2: ' + CAST(@id_insertado AS VARCHAR);

-- FORMA DE OBTENER UN IDENTITY INSERTADO FORMA 2
DECLARE @id_insertado2 INT
SET @id_insertado2 = SCOPE_IDENTITY(); -- Es mejor en un stored
PRINT 'ID INSERTADO: ' + CAST(@id_insertado2 AS VARCHAR);
SELECT @id_insertado2 = @@IDENTITY
PRINT 'ID INSERTADO FORMA 2: ' + CAST(@id_insertado2 AS VARCHAR);
```