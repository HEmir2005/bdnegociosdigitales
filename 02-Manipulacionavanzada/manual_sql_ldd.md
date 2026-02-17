# MANUAL DE FUNCIONALIDADES DE SQL-LDD

## 01-sql-ldd.sql

------------------------------------------------------------------------

# 1️ Creación de Base de Datos

``` sql
CREATE DATABASE tienda;
GO
USE tienda;
```

## Explicación

-   `CREATE DATABASE tienda;` → Crea una nueva base de datos llamada
    **tienda**.
-   `GO` → Indica el fin de un bloque de instrucciones (usado en SQL
    Server).
-   `USE tienda;` → Cambia el contexto de trabajo a la base de datos
    *tienda*.

------------------------------------------------------------------------

# 2️⃣ Creación de Tablas

## Tabla: cliente

``` sql
CREATE TABLE cliente (...)
```

### Funcionalidad

Crea una tabla con información básica de clientes.

### Campos importantes

  Campo           Tipo           Descripción
  --------------- -------------- -----------------------------------
  id              int            Identificador del cliente
  nombre          nvarchar(30)   Nombre
  apaterno        nvarchar(10)   Apellido paterno
  amaterno        nvarchar(10)   Apellido materno (puede ser NULL)
  sexo            nchar(1)       Sexo
  edad            int            Edad
  direccion       nvarchar(80)   Dirección
  rfc             nvarchar(20)   Registro Federal
  limitecredito   money          Límite de crédito (default 500)

### Conceptos aplicados

-   `NOT NULL` → Campo obligatorio.
-   `NULL` → Campo opcional.
-   `DEFAULT 500.0` → Valor automático si no se especifica.

------------------------------------------------------------------------

## Tabla: clientes (con restricciones)

``` sql
CREATE TABLE clientes (...)
```

### Diferencia con la anterior

Incluye **PRIMARY KEY**.

``` sql
cliente_id INT NOT NULL PRIMARY KEY
```

-   `PRIMARY KEY` → Identifica de forma única cada registro.
-   No permite valores repetidos.
-   No permite NULL.

------------------------------------------------------------------------

# 3️⃣ Inserción de Datos (INSERT)

## Inserción básica

``` sql
INSERT INTO clientes VALUES (...)
```

Inserta datos respetando el orden de columnas.

## Inserción con columnas específicas

``` sql
INSERT INTO clientes (nombre, cliente_id, limite_credito...) VALUES (...)
```

Permite insertar columnas en diferente orden u omitir columnas
opcionales.

## Inserción múltiple

``` sql
INSERT INTO clientes VALUES (...), (...), (...);
```

Permite insertar varios registros en una sola instrucción.

------------------------------------------------------------------------

# 4️⃣ Consultas (SELECT)

``` sql
SELECT * FROM clientes;
```

-   `*` → Muestra todas las columnas.

``` sql
SELECT cliente_id, nombre FROM clientes;
```

Selecciona columnas específicas.

## Función del sistema

``` sql
SELECT GETDATE();
```

Devuelve la fecha y hora actual del sistema.

------------------------------------------------------------------------

# 5️⃣ Identity (Autoincremento)

``` sql
cliente_id INT NOT NULL IDENTITY(1,1)
```

-   Primer número → valor inicial.
-   Segundo número → incremento automático.

------------------------------------------------------------------------

# 6️⃣ Uso de DEFAULT automático

``` sql
fecha_registro DATE DEFAULT GETDATE()
```

Si no se especifica fecha, se asigna automáticamente la fecha actual.

------------------------------------------------------------------------

# 7️⃣ Restricciones (CONSTRAINTS)

## PRIMARY KEY

``` sql
CONSTRAINT pk_suppliers PRIMARY KEY (supplier_id)
```

Identificador único para cada registro.

## UNIQUE

``` sql
CONSTRAINT unique_name UNIQUE ([name])
```

No permite valores repetidos.

## CHECK

``` sql
CHECK (credit_limit > 0 AND credit_limit <= 50000)
```

Valida rangos de valores.

``` sql
CHECK (tipo IN ('A', 'B', 'C'))
```

Solo permite valores específicos.

------------------------------------------------------------------------

# 8️⃣ Segunda Base de Datos

``` sql
CREATE DATABASE dborders;
USE dborders;
```

Se crea una base de datos para manejar customers, suppliers y products.

------------------------------------------------------------------------

# 9️⃣ Llaves Foráneas (FOREIGN KEY)

``` sql
FOREIGN KEY (supplier_id)
REFERENCES suppliers (supplier_id)
```

Relaciona productos con proveedores y mantiene integridad referencial.

------------------------------------------------------------------------

# 🔟 Acciones de Integridad Referencial

## ON DELETE NO ACTION

No permite eliminar el proveedor si tiene productos asociados.

## ON DELETE SET NULL

``` sql
ON DELETE SET NULL
```

Si se elimina el proveedor, el campo relacionado se vuelve NULL.

## ON UPDATE SET NULL

Si cambia el ID del proveedor, el valor relacionado se vuelve NULL.

------------------------------------------------------------------------

# 1️⃣1️⃣ DROP TABLE

``` sql
DROP TABLE products;
```

Elimina completamente la tabla.

------------------------------------------------------------------------

# 1️⃣2️⃣ ALTER TABLE

## Eliminar restricción

``` sql
ALTER TABLE products DROP CONSTRAINT fk_products_suppliers;
```

## Modificar columna

``` sql
ALTER TABLE products ALTER COLUMN supplier_id INT NULL;
```

Permite que la columna acepte valores NULL.

------------------------------------------------------------------------

# 1️⃣3️⃣ UPDATE

``` sql
UPDATE products SET supplier_id = NULL WHERE supplier_id = 2;
```

Modifica registros existentes.

------------------------------------------------------------------------

# 1️⃣4️⃣ DELETE

``` sql
DELETE FROM products WHERE supplier_id = 1;
```

Elimina registros específicos.

------------------------------------------------------------------------

# 1️⃣5️⃣ Conceptos SQL utilizados

-   CREATE DATABASE
-   USE
-   CREATE TABLE
-   PRIMARY KEY
-   FOREIGN KEY
-   UNIQUE
-   CHECK
-   DEFAULT
-   IDENTITY
-   INSERT
-   SELECT
-   UPDATE
-   DELETE
-   DROP TABLE
-   ALTER TABLE
-   GETDATE()

------------------------------------------------------------------------

# 🧠 Conclusión

El script demuestra la creación de bases de datos, tablas con
restricciones, integridad referencial, validaciones, y operaciones CRUD
completas.
