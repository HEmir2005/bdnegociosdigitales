# Lenguaje Transact-SQL (MSServer)

## 💩 Fundamentos Programables

1. ¿Qué es la parte programable de T-SQL?

Es todo lo que permite:

- Usar Variables
- Controlar el flujo (if/else,while)
- Crear Procedimientos Almacenados (Stored Procedures)
- Disparadores (Triggers)
- Manejar errores
- Crear Funciones
- Usar Transacciones

Es convertir SQL en un lenguaje casi C/Java pero dentro del motor de base de datos

2. Variables 👻

👀 Una variable alamcena un valor temporal
```sql
/*========================================= Variables en Transact-SQL =======================================*/
DECLARE @edad INT;
SET @edad = 21;

PRINT @edad;
SELECT @edad AS [EDAD];

DECLARE @nombre AS VARCHAR(30) = 'San Gallardo';
SELECT @nombre AS [Nombre];
SET @nombre = 'San Adonai';
SELECT @nombre AS [Nombre];

/*========================================= Ejercicios =======================================*/
/*
Ejercicio 1.
- Declarar una variable @Precio
- Asigne el valor 150
- Calcular el IVA (16)
- Mostrar el total
*/

/* El mio
DECLARE @Precio MONEY;
SET @Precio = 150;
DECLARE @IVA MONEY;
SET @IVA = 0.16 * @Precio;
DECLARE @Total MONEY;
SET @Total = @Precio + @IVA;
SELECT @Total AS [Total];
El del profe
*/

DECLARE @Precio MONEY = 150;
DECLARE @IVA DECIMAL(10,2);
DECLARE @Total MONEY;

SET @IVA = @Precio * 0.16;
SET @Total = @Precio + @IVA;

SELECT 
    @Precio AS [Precio], 
    CONCAT('$', @IVA) AS [IVA(16%)],
    CONCAT('$', @Total) AS [Total];
```

3. IF/ELSE 👻

👀 Definicion

Permite ejecutar código según condición
```sql
/* =======================================IF/ELSE ============================*/
DECLARE @edad INT;
SET @edad = 18;

IF NOT @edad >= 18
    PRINT 'Eres mayor de edad';
ELSE
    PRINT 'Eres menor de edad';

-- Calificación 
DECLARE @cali DECIMAL (10,2);
SET @cali = 5.0;

IF @cali >= 0 AND @cali <= 10
    IF @cali >= 7.0
        PRINT ('APROBADO')
    ELSE
        PRINT ('REPROBADO')
ELSE
    SELECT CONCAT(@cali,' ', 'Esta fuera de rango') AS [RESPUESTA];
```

4. WHILE (CICLOS)👻

```sql
/* ====================================== WHILE ============================*/
DECLARE @limite INT = 5;
DECLARE @i INT = 1;

WHILE (@i<= @limite)
BEGIN
    PRINT CONCAT('Numero: ', @i)
    SET @i = @i + 1
END
```