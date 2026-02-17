# Manual de Instalación y Uso: Git y GitHub

Este documento guía al usuario a través del proceso de instalación y configuración de **Git**, el sistema de control de versiones estándar de la industria, asegurando la compatibilidad con herramientas modernas como Visual Studio Code y la conexión con **GitHub**.

---

## Tabla de Contenidos
1. [Fase 1: Descarga del Instalador](#fase-1-descarga-del-instalador)
2. [Fase 2: Instalación y Selección de Componentes](#fase-2-instalación-y-selección-de-componentes)
3. [Fase 3: Configuración del Entorno](#fase-3-configuración-del-entorno)
4. [Fase 4: Preparación del Repositorio Local](#fase-4-preparación-del-repositorio-local)
5. [Fase 5: Creación de Repositorio en GitHub](#fase-5-creación-de-repositorio-en-github)
6. [Fase 6: Vinculación y Subida (Push)](#fase-6-vinculación-y-subida-push)

---

## Fase 1: Descarga del Instalador

### 1. Acceso al sitio oficial
* Abre tu navegador web y busca **"Git"** o dirígete directamente a [git-scm.com](https://git-scm.com/).
* Haz clic en el monitor que dice **"Download for Windows"**.

![Página oficial de Git](/img/gitpaso1.png)

### 2. Descarga del archivo
* Selecciona la versión **"64-bit Git for Windows Setup"** (Standalone Installer).
* Espera a que se descargue el archivo `.exe`.

### 3. Ejecución del instalador
* Ve a tu carpeta de **Descargas**.
* Haz clic derecho sobre el instalador de Git y selecciona **"Ejecutar como administrador"**.

![Selección de la versión de 64 bits](/img/gitpaso2.png)

---

## Fase 2: Instalación y Selección de Componentes

### 4. Selección de Componentes (Select Components)
En esta pantalla puedes elegir qué elementos instalar.
* Asegúrate de marcar **"Windows Explorer integration"** (para tener las opciones "Git Bash Here" al hacer clic derecho en carpetas).
* Se recomienda marcar **"Git LFS (Large File Support)"** para manejar archivos pesados.
* (Opcional) Puedes marcar **"Scalar"** si vas a manejar repositorios gigantescos.
* Haz clic en **"Next"**.

![Selección de componentes de Git](/img/gitpaso4.jpeg)

### 5. Elección del Editor Predeterminado (Choosing the default editor)
* Despliega la lista y selecciona **"Use Visual Studio Code as Git's default editor"**.
    > **Nota:** Esto permitirá que Git abra VS Code cuando necesite que escribas mensajes de commit o resuelvas conflictos, en lugar del complejo editor Vim.
* Haz clic en **"Next"**.

![Configurar VS Code como editor predeterminado](/img/gitpaso5.jpeg)

---

## Fase 3: Configuración del Entorno

*Nota: En los pasos intermedios (nombres de ramas), puedes dejar la opción por defecto ("Let Git decide") y dar clic en Next.*

### 6. Ajuste del PATH (Adjusting your PATH environment)
Esta opción define desde dónde puedes usar los comandos de Git.
* Selecciona la opción recomendada: **"Git from the command line and also from 3rd-party software"**.
    > **Importancia:** Esto asegura que Git funcione tanto en la consola propia (Git Bash) como en el CMD de Windows y PowerShell.
* Haz clic en **"Next"**.

![Configuración del PATH recomendada](/img/gitpaso6.jpeg)

### 7. Configuración de Finales de Línea (Line Ending Conversions)
Windows y Linux manejan los "enters" (saltos de línea) de forma diferente.
* Selecciona la primera opción: **"Checkout Windows-style, commit Unix-style line endings"**.
    > **Por qué:** Esto evita problemas de formato si trabajas en equipo con personas que usan Mac o Linux.
* Haz clic en **"Next"**.

![Configuración de saltos de línea](/img/gitpaso7.jpeg)

### 8. Selección del Emulador de Terminal
* Selecciona **"Use MinTTY (the default terminal of MSYS2)"**.
    > **Ventaja:** Esta terminal es más flexible, permite redimensionar la ventana y tiene mejores colores que la consola antigua de Windows.
* Haz clic en **"Next"**.

![Selección de terminal MinTTY](/img/gitpaso8.jpeg)

### 9. Finalización
* En las pantallas restantes, deja las opciones predeterminadas y haz clic en **"Next"** hasta **"Install"**.
* Cuando termine, haz clic en **"Finish"**.

![Verificación de versión de GIT](/img/gitpaso9.png)

---

## Fase 4: Preparación del Repositorio Local

Antes de subir nada a internet, debemos guardar el historial en nuestra computadora.

### 10. Guardado de Cambios (Commit)
* Abre la terminal (Git Bash) en la carpeta de tu proyecto.
* Ejecuta el comando `git commit -m "Mensaje descriptivo"` para guardar el estado actual.

![Realizando el primer commit](/img/gitpaso10.png)

### 11. Verificación de Historial
* Ejecuta el comando: `git status` y luego `git log`.
* Verifica que aparezca el autor (tú), tu correo y la fecha del guardado.

![Verificando status y log](/img/gitpaso11.png)

---

## Fase 5: Creación de Repositorio en GitHub

### 12. Nuevo Proyecto
* Inicia sesión en GitHub.
* Haz clic en el botón verde **"New"** (Nuevo) en el panel izquierdo o en la pestaña de repositorios.

![Botón para nuevo repositorio](/img/gitpaso12.png)

### 13. Detalles del Repositorio
* Asigna un nombre al repositorio (ej. `bdnegociosdigitales`).
* Agrega una descripción breve y configúralo como **"Public"**.
* Haz clic en **"Create repository"**.

![Formulario de creación de repositorio](/img/gitpaso13.png)

---

## Fase 6: Vinculación y Subida (Push)

### 14. Conectar Local con Remoto
* Copia la URL HTTPS que te proporciona GitHub.
* En tu terminal local, ejecuta:
  `git remote add origin https://github.com/HEmir2005/bdnegociosdigitales.git`
* Verifica la conexión con: `git remote -v`

![Agregando el origen remoto](/img/gitpaso14.png)

### 15. Subir Archivos (Push)
* Ejecuta el comando para enviar tu rama `main` a la nube:
  `git push -u origin main`

![Comando git push](/img/gitpaso15.png)

### 16. Autenticación
* Se abrirá automáticamente el **Git Credential Manager**.
* Haz clic en el botón azul **"Authorize git-ecosystem"** (o "Sign in with your browser").

![Autorización en el navegador](/img/gitpaso16.png)

### 17. Confirmación y Verificación
* Regresa a la terminal y espera el mensaje de éxito (100%).
* Actualiza la página de GitHub para ver tus archivos publicados.

![Terminal con subida exitosa](/img/gitpaso17.png)

![Repositorio final en GitHub](/img/gitpaso18.png)