# Manual de Instalación y Uso: Docker Desktop

Este documento detalla el procedimiento completo para preparar el sistema operativo, instalar **Docker Desktop**, gestionar imágenes, desplegar contenedores y configurar servicios de base de datos (SQL Server) con acceso externo.

---

## Tabla de Contenidos
1. [Fase 1: Preparación de Características de Windows](#fase-1-preparación-de-características-de-windows)
2. [Fase 2: Descarga e Instalación](#fase-2-descarga-e-instalación)
3. [Fase 3: Verificación Inicial](#fase-3-verificación-inicial)
4. [Fase 4: Obtención de Imágenes (Pull)](#fase-4-obtención-de-imágenes-pull)
5. [Fase 5: Gestión de Contenedores (Run/Stop/Start)](#fase-5-gestión-de-contenedores-runstopstart)
6. [Fase 6: Configuración Avanzada (Puertos y Variables)](#fase-6-configuración-avanzada-puertos-y-variables)
7. [Fase 7: Verificación de Conexión](#fase-7-verificación-de-conexión)

---

## Fase 1: Preparación de Características de Windows

Antes de instalar Docker, es indispensable habilitar las características de virtualización del sistema operativo.

### 1. Acceso a la configuración
* Presiona la tecla `Windows` o ve al menú Inicio.
* Escribe **"Activar o desactivar las características de Windows"**.
* Abre la opción del Panel de Control.

![Búsqueda de características de Windows](/img/docker1.png)

### 2. Habilitación de componentes
* En la ventana emergente, busca y marca las siguientes casillas:
    * [x] **Subsistema de Windows para Linux** (Windows Subsystem for Linux)
    * [x] **Plataforma de máquina virtual** (Virtual Machine Platform)
* Haz clic en **"Aceptar"** y reinicia tu equipo si se solicita.

![Lista de características habilitadas](/img/docker2.png)

---

## Fase 2: Descarga e Instalación

### 3. Ejecución del instalador
* Una vez descargado el instalador desde el sitio oficial de Docker.
* Dirígete a la carpeta de **Descargas**.
* Haz clic derecho sobre `Docker Desktop Installer` y selecciona **"Ejecutar como administrador"**.

![Ejecutar instalador como administrador](/img/docker3.png)

### 4. Proceso de instalación
* Asegúrate de dejar marcada la opción **"Use WSL 2 instead of Hyper-V"** (Recomendado).
* Espera a que el instalador descomprima los paquetes.
* Al finalizar, verás el mensaje "Installation succeeded" o similar. Haz clic en **"Close"**.

![Instalación completada exitosamente](/img/docker4.png)

---

## Fase 3: Verificación Inicial

### 5. Primer arranque y comprobación
* Abre **Docker Desktop** desde el menú Inicio y acepta los términos de servicio.
* Abre una terminal (Git Bash, PowerShell o CMD).
* Ejecuta el comando: `docker --version`.
    > Si aparece la versión instalada, el sistema está listo.

![Verificación de versión en terminal](/img/docker5.png)

---

## Fase 4: Obtención de Imágenes (Pull)

Aprenderemos a descargar "moldes" (imágenes) para crear nuestros contenedores.

### 6. Búsqueda de imágenes oficiales
* Para SQL Server, busca la documentación oficial en Microsoft Learn o Docker Hub.
* Identifica la etiqueta (tag) correcta, por ejemplo: `2019-latest`.

![Búsqueda de imagen SQL Server](/img/docker6.png)
![Documentación oficial de Microsoft](/img/docker7.png)

### 7. Descarga de SQL Server
* Copia el comando de extracción (*pull*) de la documentación.
* Ejecuta en tu terminal:
  `docker pull mcr.microsoft.com/mssql/server:2019-latest`

![Copiando comando pull](/img/docker8.png)

### 8. Descarga de otras imágenes (MySQL y Demo)
* Repite el proceso para otras tecnologías.
* Busca **MySQL** en Docker Hub y verifica que sea la "Docker Official Image".

![Búsqueda de MySQL en Docker Hub](/img/docker9.png)

* Ejecuta: `docker pull mysql:latest`
* Ejecuta: `docker pull docker/getting-started`

![Descarga de MySQL en terminal](/img/docker10.png)
![Descarga de getting-started](/img/docker11.png)
![Descargas múltiples completadas](/img/docker12.png)

### 9. Verificación Visual
* Abre Docker Desktop y ve a la pestaña **Images**.
* Deberías ver listadas las tres imágenes descargadas.

![Lista de imágenes en Docker Desktop](/img/docker13.png)

---

## Fase 5: Gestión de Contenedores (Run/Stop/Start)

### 10. Creación de contenedor (Nombre Aleatorio)
* Lista las imágenes en terminal: `docker images`
* Ejecuta la imagen de prueba usando su ID: `docker run <IMAGE_ID>` (ej. `d793`).
* Docker asignará un nombre aleatorio (ej. `elastic_burnell`).

![Listar imágenes y ejecutar por ID](/img/docker14.png)
![Contenedor con nombre aleatorio en Desktop](/img/docker15.png)

### 11. Control de Ciclo de Vida
* **Detener:** `docker stop <nombre_contenedor>`
* **Iniciar:** `docker start <nombre_contenedor>`
* Verifica el cambio de estado (STATUS) en la terminal.

![Comandos stop y start](/img/docker16.png)

### 12. Creación con Nombre Personalizado
* Para organizar mejor, usa la bandera `--name`.
* Comando: `docker run --name miprimercontenedor docker/getting-started`
* Verifica en Docker Desktop que el nuevo nombre aparece correctamente.

![Ejecución con nombre personalizado](/img/docker17.png)
![Verificación en GUI](/img/docker18.png)

---

## Fase 6: Configuración Avanzada (Puertos y Variables)

Desplegaremos servicios reales exponiendo puertos y configurando variables de entorno.

### 13. Mapeo de Puertos (Port Mapping)
* Para acceder al contenedor desde nuestro navegador o herramientas, debemos mapear los puertos.
* Ejemplo con el tutorial: Mapear el puerto 80 del contenedor al puerto **8089** de la PC.
* Comando: `docker run --name tutorial-docker -d -p 8089:80 docker/getting-started`

![Instrucciones de puerto](/img/docker19.png)
![Contenedor corriendo en puerto 8089](/img/docker20.png)

> **Nota de Seguridad:** Si aparece una alerta del Firewall de Windows, haz clic en **"Permitir"**.

![Alerta de Firewall](/img/docker21.png)

### 14. Despliegue de Base de Datos (SQL Server)
* SQL Server requiere aceptar la licencia (`ACCEPT_EULA`) y definir una contraseña (`MSSQL_SA_PASSWORD`).
* Consulta las variables exactas en la documentación.

![Variables de entorno requeridas](/img/docker22.png)
![Variables de entorno requeridas](/img/docker23.png)

* Ejecuta el siguiente comando (usando el puerto **1435** para evitar conflictos locales):

```bash
docker run -e "ACCEPT_EULA=Y" -e "MSSQL_SA_PASSWORD=P@ssw0rd" \
-p 1435:1433 --name servidorsqlserver \
-d [mcr.microsoft.com/mssql/server:2019-latest](https://mcr.microsoft.com/mssql/server:2019-latest)