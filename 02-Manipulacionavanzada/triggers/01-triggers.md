
# Triggers en SQL Server

## 1. ¿Qué es un Trigger?

Un trigger (disparador) es un bloque de código SQL que se ejecuta automátiacmente cuando ocurre un evento en una tabla.

🦖 Eventos principales:
    - Insert
    - Delete
    - Update

Nota: No se ejecutan manualmente, se activan solos

## 2. ¿Para que sirven?
    - Validaciones
    - Auditoría (guardar historial)
    - Reglas de negocio
    - Automatización

## 3. Tipos de Triggers en SQL Server

    - AFTER TRIGGER

    Se ejecuta despues del evento

    - INSTEAD OF TRIGGER

    Reemplaza la operación original

## 4. Sintaxis Básica

```sql
    CREATE OR ALTER TRIGGER nombre_trigger
    ON nombre_tabla
    AFTER INSERT
    AS 
    BEGIN
    END;
```

## 5. Tablas especiales

| Tabla | Contenido |
| :--- | :--- |
| inserted | Nuevos Datos |
| deleted | Datos anteriores |