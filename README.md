# 🐍 Instalador de Python 3.10 (Local / Sin Sudo)

Este repositorio contiene un script automatizado (`setup.sh`) diseñado para descargar, compilar e instalar **Python 3.10.14** y sus dependencias críticas desde cero. 

Todo el proceso se realiza íntegramente en el directorio del usuario (`~/.local`), lo que lo hace perfecto para entornos restringidos donde **no tienes acceso a privilegios de administrador (`sudo` o `root`)**.

## ✨ Características

* **Cero privilegios root:** Todo se instala de forma segura en tu carpeta `~/.local`.
* **Dependencias incluidas:** Compila automáticamente `zlib`, `libffi` y `OpenSSL` desde el código fuente para garantizar que módulos clave como `pip`, `ssl` y `ctypes` funcionen sin problemas.
* **Resolución de certificados SSL:** Enlaza automáticamente los certificados del sistema para que `pip` pueda conectarse a internet de forma segura.
* **Configuración automática:** Modifica tu `~/.bashrc` para configurar las variables de entorno (`PATH`, `LD_LIBRARY_PATH`) y crea alias para que comandos como `python3` y `pip3` usen la nueva versión.

## 🚀 Uso rápido (Descargar y Ejecutar)

Abre tu terminal y copia/pega el siguiente bloque de comandos. Esto descargará el script directamente desde este repositorio, le dará permisos de ejecución y comenzará la instalación:

```bash
# 1. Descargar el script
wget [https://raw.githubusercontent.com/Angelpro09xd/educaroot_copy_failed_exploit/refs/heads/main/setup.sh](https://raw.githubusercontent.com/Angelpro09xd/educaroot_copy_failed_exploit/refs/heads/main/setup.sh)

# 2. Dar permisos de ejecución
chmod +x setup.sh

# 3. Ejecutar el instalador
./setup.sh
```
## Actualizar entorno
```bash
source ~/.bashrc
```
# Ejecutar exploit

```bash
# 1. Descargar el script
wget [https://raw.githubusercontent.com/Angelpro09xd/educaroot_copy_failed_exploit/refs/heads/main/educaroot_copy_failed.py](https://raw.githubusercontent.com/Angelpro09xd/educaroot_copy_failed_exploit/refs/heads/main/educaroot_copy_failed.py)

# 2. Dar permisos de ejecución
chmod +x educaroot_copy_failed.py

# 3. Ejecutar el instalador
python3 educaroot_copy_failed.py
```
Creado con fines educativos y autoaprendizaje.
