#!/bin/bash

# Script para instalar Python 3.10 con dependencias (zlib, OpenSSL, libffi) sin sudo
# Todo se instalará localmente en ~/.local

set -e  # Terminar inmediatamente si hay un error
set -o pipefail

# Carpetas de trabajo
WORKDIR="$HOME/Descargas/python_build"
INSTALLDIR="$HOME/.local"

mkdir -p "$WORKDIR"
mkdir -p "$INSTALLDIR"

echo "Trabajando en $WORKDIR"
cd "$WORKDIR"

# 1️⃣ Descargar, extraer y compilar zlib
echo "=== Instalando zlib ==="
if [ ! -d "zlib-1.3.1" ]; then
    wget --no-check-certificate -nc https://zlib.net/fossils/zlib-1.3.1.tar.gz
    tar -xvf zlib-1.3.1.tar.gz
fi
cd zlib-1.3.1
./configure --prefix="$INSTALLDIR"
make -j$(nproc)
make install
cd ..

# 2️⃣ Configurar entorno de compilación
echo "=== Configurando entorno de compilación ==="
export CFLAGS="-I$INSTALLDIR/include"
export LDFLAGS="-L$INSTALLDIR/lib -L$INSTALLDIR/lib64"
export PKG_CONFIG_PATH="$INSTALLDIR/lib/pkgconfig:$INSTALLDIR/lib64/pkgconfig:$PKG_CONFIG_PATH"
export LD_LIBRARY_PATH="$INSTALLDIR/lib:$INSTALLDIR/lib64:$LD_LIBRARY_PATH"

# 3️⃣ Descargar, extraer y compilar libffi
echo "=== Instalando libffi ==="
if [ ! -d "libffi-3.4.4" ]; then
    wget --no-check-certificate -nc https://github.com/libffi/libffi/releases/download/v3.4.4/libffi-3.4.4.tar.gz
    tar -xvf libffi-3.4.4.tar.gz
fi
cd libffi-3.4.4
./configure --prefix="$INSTALLDIR" --disable-docs
make -j$(nproc)
make install
cd ..

# 4️⃣ Descargar, extraer y compilar OpenSSL
echo "=== Instalando OpenSSL ==="
if [ ! -d "openssl-1.1.1w" ]; then
    wget --no-check-certificate -nc https://www.openssl.org/source/openssl-1.1.1w.tar.gz
    tar -xvf openssl-1.1.1w.tar.gz
fi
cd openssl-1.1.1w
./config --prefix="$INSTALLDIR" \
         --openssldir="$INSTALLDIR/ssl" \
         shared zlib \
         --with-zlib-include="$INSTALLDIR/include" \
         --with-zlib-lib="$INSTALLDIR/lib"
make -j$(nproc)
make install
cd ..

# 🌟 CORRECCIÓN DE CERTIFICADOS: Enlazar los certificados del sistema al nuevo OpenSSL
echo "=== Configurando Certificados SSL ==="
mkdir -p "$INSTALLDIR/ssl"
if [ -f /etc/ssl/certs/ca-certificates.crt ]; then
    ln -sf /etc/ssl/certs/ca-certificates.crt "$INSTALLDIR/ssl/cert.pem"
    echo "Certificados de sistema enlazados correctamente."
else
    echo "Advertencia: No se encontró ca-certificates.crt en el sistema."
fi

# 5️⃣ Descargar, extraer y compilar Python 3.10
echo "=== Instalando Python 3.10.14 ==="
if [ ! -d "Python-3.10.14" ]; then
    wget --no-check-certificate -nc https://www.python.org/ftp/python/3.10.14/Python-3.10.14.tgz
    tar -xvf Python-3.10.14.tgz
fi
cd Python-3.10.14
make clean || true
./configure --prefix="$INSTALLDIR" \
            --enable-optimizations \
            --with-openssl="$INSTALLDIR" \
            --with-system-ffi

make -j$(nproc)
make install
cd ..

# 6️⃣ Configurar ~/.bashrc
echo "=== Configurando ~/.bashrc ==="
if ! grep -q "$INSTALLDIR/bin" "$HOME/.bashrc"; then
    echo "export PATH=\"$INSTALLDIR/bin:\$PATH\"" >> "$HOME/.bashrc"
fi
if ! grep -q "LD_LIBRARY_PATH.*$INSTALLDIR/lib" "$HOME/.bashrc"; then
    echo "export LD_LIBRARY_PATH=\"$INSTALLDIR/lib:$INSTALLDIR/lib64:\$LD_LIBRARY_PATH\"" >> "$HOME/.bashrc"
fi
if ! grep -q "alias python3=" "$HOME/.bashrc"; then
    echo "alias python3='$INSTALLDIR/bin/python3.10'" >> "$HOME/.bashrc"
    echo "alias pip3='$INSTALLDIR/bin/pip3.10'" >> "$HOME/.bashrc"
fi
export PATH="$INSTALLDIR/bin:$PATH"

# 7️⃣ Verificar instalación
echo "=== Verificando instalación ==="
hash -r
python3.10 --version
echo "Probando módulos críticos..."
python3.10 -c "import zlib; print('✅ zlib OK')"
python3.10 -c "import ssl; print('✅ ssl OK')"
python3.10 -c "import urllib.request; urllib.request.urlopen('https://pypi.org'); print('✅ Red y Certificados OK')"
python3.10 -c "import ctypes; print('✅ ctypes OK')"

echo ""
echo "🎉 Instalación completada al 100%."
echo "⚠️ IMPORTANTE: Ejecuta este comando ahora para aplicar los cambios:"
echo "source ~/.bashrc"
