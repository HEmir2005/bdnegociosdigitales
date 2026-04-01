-- 1. Crear BD bdpracticas
-- 2. Crear el siguiente Diagrama, Utilizando como base los datos de NORTHWIND en las tablas de catalogo
-- CatProducto: id_producto INT IDENTITY PK, nombre_producto NVARCHAR(40), existencia INT, precio MONEY (Esta tabla se llena con NORTHWIND.dbo.Products)
-- CatCliente: id_cliente NCHAR(5), nombre_cliente NVARCHAR(40), pais NVARCHAR(15), ciudad NVARCHAR(15) (Esta tabla se llena con NORTHWIND.dbo.Customers)
-- TblVenta: id_venta INT IDENTITY FK, fecha DATE, id_cliente FK
-- TblDetalleVenta: id_venta INT FK - PK, id_producto INT FK - PK, precio_venta MONEY, cantidad_vendida INT
-- 3. Crear un SP llamado usp_agregar_venta (TRY, CATCH, TRANSACTIONS)
/*
    *Va a insertar en la tabla TblVenta, la fecha debe ser la fecha actual (GETDATE()), verificar si el cliente existe (si no el SP termina)
    *Insertar en la tabla TblDetalleVenta, verificar si el producto existe (si no el SP termina), 
    *Obtener de la tabla CatProducto el precio del producto 
    *Cantidad Vendida sea suficiente en la existencia de la tabla CatProducto (si no el SP termina con mensaje "No hay existencia suficiente")
    *Actualizar la existencia en la tabla CatProducto mediante la operacion Existencia - Cantidad Vendida
*/
-- 4. Documentar todo el procedimiento de la solucion en archivo .md
-- 5. Crear un Commit llamado "Practica Venta Store Procedure"
-- 6. Hacer Merge a Main
-- 7. Hacer Push a GitHub

-- Paso 1
CREATE DATABASE bdpracticas;
GO

-- Paso 2
USE bdpracticas;
GO

CREATE TABLE CatProducto (
    id_producto INT IDENTITY(1,1) PRIMARY KEY,
    nombre_producto NVARCHAR(40),
    existencia INT,
    precio MONEY
);
GO

CREATE TABLE CatCliente (
    id_cliente NCHAR(5) PRIMARY KEY,
    nombre_cliente NVARCHAR(40),
    pais NVARCHAR(15),
    ciudad NVARCHAR(15)
);
GO

CREATE TABLE TblVenta (
    id_venta INT IDENTITY(1,1) PRIMARY KEY,
    fecha DATE,
    id_cliente NCHAR(5),
    FOREIGN KEY (id_cliente) REFERENCES CatCliente(id_cliente)
);
GO

CREATE TABLE TblDetalleVenta (
    id_venta INT,
    id_producto INT,
    precio_venta MONEY,
    cantidad_vendida INT,
    PRIMARY KEY (id_venta, id_producto),
    FOREIGN KEY (id_venta) REFERENCES TblVenta(id_venta),
    FOREIGN KEY (id_producto) REFERENCES CatProducto(id_producto)
);
GO

-- Paso 2.1 (Meter datos de NORTHWIND)
INSERT INTO CatProducto (nombre_producto, existencia, precio)
SELECT ProductName, UnitsInStock, UnitPrice FROM NORTHWND.dbo.Products;
GO

INSERT INTO CatCliente (id_cliente, nombre_cliente, pais, ciudad)
SELECT CustomerID, CompanyName, Country, City FROM NORTHWND.dbo.Customers;
GO

-- Paso 3
CREATE OR ALTER PROC usp_agregar_venta
    @id_cliente NCHAR(5),
    @id_producto INT,
    @cantidad_vendida INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Verificar si el cliente existe
        IF NOT EXISTS (SELECT 1 FROM CatCliente WHERE id_cliente = @id_cliente)
        BEGIN
            -- THROW requiere un número de error >= 50000 para errores de usuario
            THROW 50001, 'El cliente no existe.', 1; 
        END

        -- Verificar si el producto existe
        IF NOT EXISTS (SELECT 1 FROM CatProducto WHERE id_producto = @id_producto)
        BEGIN
            THROW 50002, 'El producto no existe.', 1;
        END

        -- Obtener el precio del producto
        DECLARE @precio_producto MONEY;
        SELECT @precio_producto = precio FROM CatProducto WHERE id_producto = @id_producto;

        -- Verificar existencia suficiente
        DECLARE @existencia INT;
        SELECT @existencia = existencia FROM CatProducto WHERE id_producto = @id_producto;

        IF @cantidad_vendida > @existencia
        BEGIN
            THROW 50003, 'No hay existencia suficiente.', 1;
        END

        -- Insertar en TblVenta
        INSERT INTO TblVenta (fecha, id_cliente) VALUES (GETDATE(), @id_cliente);
        DECLARE @id_venta INT 
        SET @id_venta = @@IDENTITY

        -- Insertar en TblDetalleVenta
        INSERT INTO TblDetalleVenta (id_venta, id_producto, precio_venta, cantidad_vendida)
        VALUES (@id_venta, @id_producto, @precio_producto, @cantidad_vendida);

        -- Actualizar existencia en CatProducto
        UPDATE CatProducto
        SET existencia = existencia - @cantidad_vendida
        WHERE id_producto = @id_producto;

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        -- Si hay una transacción abierta, se deshace
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        THROW; 
    END CATCH
END
GO

EXEC usp_agregar_venta @id_cliente = 'ALFKI', @id_producto = 4, @cantidad_vendida = 3;
GO

EXEC usp_agregar_venta @id_cliente = 'OTIPS', @id_producto = 1, @cantidad_vendida = 10;
GO

EXEC usp_agregar_venta @id_cliente = 'ANATR', @id_producto = 95, @cantidad_vendida = 10;
GO

EXEC usp_agregar_venta @id_cliente = 'ANATR', @id_producto = 2, @cantidad_vendida = 30;
GO

-- Crear un Store que permita agregar N productos
-- Crear una tabla tipo Type, esa tabla enviarla como parametro al Store
-- Parametro: Id_cliente, Cantidad, Tabla tipo Type

-- Crear tabla tipo Type
CREATE TYPE dbo.ProductoVenta AS TABLE (
    id_producto INT,
    cantidad_vendida INT
);
GO

-- Crear el Store Procedure para agregar una venta con múltiples productos
CREATE OR ALTER PROC usp_agregar_venta_masiva
    @id_cliente NCHAR(5),
    @tabla_productos [dbo].[ProductoVenta] READONLY 
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        -- 1. Validar si el cliente existe
        IF NOT EXISTS (SELECT 1 FROM CatCliente WHERE id_cliente = @id_cliente)
            THROW 50001, 'El cliente no existe.', 1;

        -- 2. Validar que todos los productos en la lista existan
        IF EXISTS (SELECT 1 FROM @tabla_productos tp 
                   LEFT JOIN CatProducto cp ON tp.id_producto = cp.id_producto 
                   WHERE cp.id_producto IS NULL)
            THROW 50002, 'Uno o más productos en la lista no existen.', 1;

        -- 3. Validar existencia (stock) para TODOS los productos antes de insertar
        IF EXISTS (
            SELECT 1 
            FROM @tabla_productos tp
            JOIN CatProducto cp ON tp.id_producto = cp.id_producto
            -- Usamos 'cantidad_vendida' como lo definiste en tu Type
            WHERE tp.cantidad_vendida > cp.existencia
        )
            THROW 50003, 'No hay existencia suficiente para uno o más productos.', 1;

        -- 4. Insertar la cabecera de la venta (TblVenta)
        INSERT INTO TblVenta (fecha, id_cliente) 
        VALUES (GETDATE(), @id_cliente);

        DECLARE @id_venta_generada INT = SCOPE_IDENTITY();

        -- 5. Insertar el detalle (TblDetalleVenta) obteniendo precios de CatProducto
        INSERT INTO TblDetalleVenta (id_venta, id_producto, precio_venta, cantidad_vendida)
        SELECT 
            @id_venta_generada, 
            tp.id_producto, 
            cp.precio, 
            tp.cantidad_vendida -- Usamos 'cantidad_vendida'
        FROM @tabla_productos tp
        JOIN CatProducto cp ON tp.id_producto = cp.id_producto;

        -- 6. Actualizar el stock en CatProducto (Operación masiva)
        UPDATE cp
        SET cp.existencia = cp.existencia - tp.cantidad_vendida -- Usamos 'cantidad_vendida'
        FROM CatProducto cp
        JOIN @tabla_productos tp ON cp.id_producto = tp.id_producto;

        COMMIT TRANSACTION;
        PRINT 'Venta múltiple registrada exitosamente.';
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        -- Re-lanzar el error para que se muestre en la consola
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        DECLARE @ErrorSeverity INT = ERROR_SEVERITY();
        DECLARE @ErrorState INT = ERROR_STATE();
        RAISERROR (@ErrorMessage, @ErrorSeverity, @ErrorState);
    END CATCH
END
GO

-- Ejemplo de cómo ejecutar el SP para agregar una venta con múltiples productos
-- Declaramos la variable usando tu tipo de tabla
DECLARE @ListaVenta AS [dbo].ProductoVenta;

-- Agregamos datos de prueba
INSERT INTO @ListaVenta (id_producto, cantidad_vendida)
VALUES 
(1, 2),  
(2, 5),  
(10, 1); 

-- Ejecutamos el Store Procedure
EXEC usp_agregar_venta_masiva 
    @id_cliente = 'ALFKI', 
    @tabla_productos = @ListaVenta;
GO

SELECT * FROM TblVenta;
SELECT * FROM TblDetalleVenta;