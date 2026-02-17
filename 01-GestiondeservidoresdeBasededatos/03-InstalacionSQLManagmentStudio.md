# Manual de Instalación Gráfico: SQL Server 2022 y SSMS

Este documento detalla el procedimiento paso a paso para la instalación del motor de base de datos **SQL Server 2022 (Edición Developer)** y su interfaz de administración gráfica **SQL Server Management Studio (SSMS)** en un entorno Windows.

---

## Tabla de Contenidos
1. [Fase 1: Descarga y Preparación de Medios](#fase-1-descarga-y-preparación-de-medios)
2. [Fase 2: Instalación del Motor de Base de Datos](#fase-2-instalación-del-motor-de-base-de-datos-sql-server)
3. [Fase 3: Instalación de SSMS](#fase-3-instalación-de-sql-server-management-studio-ssms)
4. [Fase 4: Verificación](#fase-4-verificación)

---

## Fase 1: Descarga y Preparación de Medios

### 1. Ejecución del asistente de descarga
* Localiza el archivo instalador web (`SQL2022-SSEI-Expr.exe` o similar).
* Haz clic derecho sobre el archivo y selecciona **"Ejecutar como administrador"**.

![Ejecutar el instalador web como administrador](/img/paso1.png)

### 2. Selección del tipo de medio
* En la pantalla de inicio, selecciona la opción **"Descargar medios"**.
    > **Nota:** Esto permitirá bajar el instalador completo (ISO).

![Selección de Descargar Medios](/img/paso2.png)

### 3. Configuración de la descarga
* **Idioma:** Selecciona "Inglés".
    > **Nota:** Puedes seleccionar Español, pero tendrias que cambiar el idioma de tu PC a Español España
* **Paquete:** Selecciona la opción **"ISO"**.
* **Acción:** Haz clic en **"Descargar"** y espera a que finalice (aprox. 1.1 GB).

![Configuración para descargar ISO](/img/paso3.png)
![Configuración para descargar ISO](/img/paso3.1.png)

### 4. Montaje de la imagen ISO
* Ve a la carpeta de Descargas y localiza el archivo ISO generado.
* Haz clic derecho sobre él y selecciona **"Montar"**.
    > **Resultado:** Windows creará una unidad de DVD virtual.

![Montar la imagen ISO](/img/paso4.png)

---

## Fase 2: Instalación del Motor de Base de Datos (SQL Server)

### 5. Inicio del instalador
* Dentro de la unidad virtual montada, busca el archivo `setup.exe`.
* Haz clic derecho y selecciona **"Ejecutar como administrador"**.

![Ejecutar setup.exe dentro del ISO](/img/paso5.png)

### 6. Selección de instalación independiente
* En la ventana *SQL Server Installation Center*, ve al menú lateral **Installation**.
* Haz clic en: **"New SQL Server standalone installation..."**.

![Centro de instalación - Nueva instalación independiente](/img/paso6.png)

### 7. Selección de Edición
* Elige la opción **"Specify a free edition"** y selecciona **"Developer"**.
* Haz clic en **"Next"**.

![Selección de edición Developer](/img/paso7.png)

### 8. Términos y Configuración Inicial
* Acepta los términos de licencia.
* En las pantallas siguientes (Update/Azure), puedes desmarcar las opciones para una instalación local.

![Aceptar términos de licencia](/img/paso8.png)
![Aceptar términos de licencia](/img/paso8.1.png)

### 9. Selección de Características (Feature Selection)
* En la lista, marca únicamente:
    * [x] **Database Engine Services**
* Haz clic en **"Next"**.

![Selección de características del motor](/img/paso9.png)

### 10. Configuración de Instancia
* Selecciona **"Default instance"** (MSSQLSERVER).
* Haz clic en **"Next"**.

![Configuración de instancia predeterminada](/img/paso10.png)

### 11. Configuración del Servidor (Cuentas de Servicio)
* Verifica que el "SQL Server Database Engine" tenga el inicio en **"Automatic"**.
* Haz clic en **"Next"**.

![Configuración de cuentas de servicio](/img/paso11.png)

### 12. Configuración del Motor (Autenticación)
Paso crítico de seguridad:
1.  Selecciona **"Mixed Mode"**.
2.  Define una contraseña para el usuario `sa`.
3.  Haz clic en **"Add Current User"** para añadirte como administrador.
4.  Haz clic en **"Next"**.

![Configuración de autenticación mixta y usuarios](/img/paso12.png)

### 13. Instalación Final
* Revisa el resumen y haz clic en **"Install"**.
* Espera a que la barra de progreso termine.
* Verifica que todo esté en estado **"Succeeded"** y cierra.

![Pantalla final de instalación exitosa](/img/paso13.png)
![Pantalla final de instalación exitosa](/img/paso13.1.png)

---

## Fase 3: Instalación de SQL Server Management Studio (SSMS)

### 14. Descarga de SSMS
* En el *SQL Server Installation Center*, selecciona **"Install SQL Server Management Tools"**.
* Descarga el instalador desde la web que se abre.

![Enlace para instalar herramientas de gestión](/img/paso14.png)
![Enlace para instalar herramientas de gestión](/img/paso14.1.png)

### 15. Ejecución del Instalador SSMS
* Localiza el archivo descargado (`vs_SSMS.exe`).
* Ejecútalo como administrador y sigue las instrucciones (clic en "Install").

![Ejecutar el instalador de SSMS](/img/paso15.png)

---

## Fase 4: Verificación 

### 16. Apertura del programa
* Busca **"SQL Server Management Studio"** en el menú Inicio y ábrelo.

![Buscar SSMS en el menú inicio](/img/paso16.png)

> ✅ **Éxito**