# Práctica: Creación y Manejo de Ventas con Stored Procedures

## Descripción General
Este proyecto contiene el script SQL para la creación de una base de datos relacional orientada al registro de ventas. Incluye la definición de tablas catálogo (alimentadas con datos de `NORTHWND`), tablas transaccionales y la implementación de un Stored Procedure seguro para procesar las ventas aplicando reglas de negocio estrictas.

---

## 1. Creación de la Base de Datos

El primer paso de la práctica consiste en la creación de la base de datos desde cero, asignándole el nombre `bdpracticas`, y preparándola para la inserción de tablas.

**Código de Creación de la BD:**
![Captura de creación de la base de datos](/img/SP1.png)

---

## 2. Estructura de Tablas

La base de datos está compuesta por cuatro tablas principales:

### Tablas Catálogo (Maestras)
* **`CatProducto`**: Almacena el inventario. Contiene `id_producto` (Autonumérico PK), `nombre_producto`, `existencia` y `precio`.
* **`CatCliente`**: Almacena los compradores. Contiene `id_cliente` (NCHAR PK), `nombre_cliente`, `pais` y `ciudad`.

> *Nota: Ambas tablas catálogo fueron inicializadas con datos reales extraídos de la base de datos de prueba `NORTHWND`.*

### Tablas Transaccionales
* **`TblVenta`**: Registra la cabecera de la transacción (`id_venta` PK, `fecha` y llave foránea a `CatCliente`).
* **`TblDetalleVenta`**: Almacena el desglose de los productos por venta. Utiliza una llave primaria compuesta (`id_venta`, `id_producto`) y registra el `precio_venta` y la `cantidad_vendida`.

**Creación de Tablas:**
![Captura de la creación de tablas](/img/SP2.png)

---

## 3. Lógica del Stored Procedure (`usp_agregar_venta`)

### Manejo de Transacciones y Errores (TRY...CATCH y THROW)
* Se implementa un bloque `BEGIN TRY / BEGIN CATCH` junto con `BEGIN TRANSACTION`.
* Si todas las validaciones pasan, el SP inserta la venta, recupera el ID autogenerado mediante `@@IDENTITY`, inserta el detalle y actualiza (resta) el stock en el catálogo de productos. Finalmente, confirma los cambios con `COMMIT TRANSACTION`.
* Si alguna validación falla o ocurre un error del sistema, la instrucción `THROW` detiene la ejecución inmediatamente, enviando el flujo al bloque `CATCH`, donde se ejecuta un `ROLLBACK TRANSACTION` para mantener la base de datos intacta.

**Código del Stored Procedure:**
![Captura del código TRY CATCH](/img/SP4.png)

**Ejecución Exitosa del Stored Procedure:**
![Captura del resultado de ejecución](/img/SP5.png)
![Captura del resultado de ejecución](/img/SP6.png)
![Captura del resultado de ejecución](/img/SP7.png)

### Características y Validaciones:
El SP asegura la integridad de los datos mediante las siguientes validaciones antes de insertar cualquier registro:
1. **Validación de Cliente:** Verifica que el `@id_cliente` exista en `CatCliente` (Error `50001`).
2. **Validación de Producto:** Verifica que el `@id_producto` exista en `CatProducto` (Error `50002`).
3. **Validación de Stock:** Comprueba que la `existencia` actual sea mayor o igual a la `@cantidad_vendida` solicitada (Error `50003`).

**Código de las Validaciones:**
![Captura de las validaciones en el SP](/img/SP3.png)

---

## 5. Conclusión
Esta práctica me permitió consolidar mis conocimientos en el manejo de bases de datos relacionales y la programación segura con T-SQL. Aprendí que el control estricto de transacciones y validaciones no solo evita errores en un sistema de ventas, sino que sienta las bases lógicas para cualquier proyecto que requiera un manejo de datos impecable, desde una aplicación empresarial hasta la gestión de inventarios y bases de datos en el desarrollo de videojuegos.