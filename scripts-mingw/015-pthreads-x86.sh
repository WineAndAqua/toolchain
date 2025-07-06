#!/bin/sh

MINGW_LIBS=${MINGW_LIBS:=$(PWD)/../libs}

PATH=${MINGW_LIBS}/bin:${PATH}

VER=13.0.0
PKGNAME=mingw-w64

if [ ! -f ${PKGNAME}-v${VER}.tar.bz2 ]; then wget --continue https://downloads.sourceforge.net/project/${PKGNAME}/${PKGNAME}/${PKGNAME}-release/${PKGNAME}-v${VER}.tar.bz2; fi

rm -Rf ${PKGNAME}-v${VER} && tar xf ${PKGNAME}-v${VER}.tar.bz2 && cd ${PKGNAME}-v${VER}

if [ -f ../../patches/${PKGNAME}-${VER}.patch ]; then patch -p1 < ../../patches/${PKGNAME}-${VER}.patch; fi

cd mingw-w64-libraries/winpthreads

ARCH=i686

ARCH_DIR=${MINGW_PATH}

PATH=${ARCH_DIR}/bin:${PATH}

TARGET="${ARCH}-w64-mingw32"

mkdir -p "build-$ARCH" && cd "build-$ARCH"

CC=$TARGET-gcc \
CXX=$TARGET-g++ \
CPP=$TARGET-cpp \
../configure \
--prefix="$ARCH_DIR/$TARGET" \
--with-sysroot="$ARCH_DIR/$TARGET" \
--host="$TARGET" \
--enable-lib32 \
--disable-lib64

PROCS="$(sysctl -n hw.ncpu 2>/dev/null)"
${MAKE:-make} -j $PROCS && ${MAKE:-make} install
