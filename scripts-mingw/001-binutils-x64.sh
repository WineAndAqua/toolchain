#!/bin/sh

MINGW_LIBS=${MINGW_LIBS:=$(PWD)/../libs}

PATH=${MINGW_LIBS}/bin:${PATH}

VER=2.44
PKGNAME=binutils

if [ ! -f ${PKGNAME}-${VER}.tar.xz ]; then wget --continue https://sourceware.org/pub/${PKGNAME}/releases/${PKGNAME}-${VER}.tar.xz; fi

rm -Rf ${PKGNAME}-${VER} && tar xf ${PKGNAME}-${VER}.tar.xz && cd ${PKGNAME}-${VER}

if [ -f ../../patches/${PKGNAME}-${VER}.patch ]; then patch -p1 < ../../patches/${PKGNAME}-${VER}.patch; fi

ARCH=x86_64

ARCH_DIR=${MINGW_PATH}

PATH=${ARCH_DIR}/bin:${PATH}

TARGET="${ARCH}-w64-mingw32"

mkdir -p "build-$ARCH" && cd "build-$ARCH"

../configure \
--prefix="$ARCH_DIR" \
--with-sysroot="$ARCH_DIR" \
--target="$TARGET" \
--enable-targets="$TARGET" \
--with-gmp="$MINGW_LIBS" \
--with-mpfr="$MINGW_LIBS" \
--with-mpc="$MINGW_LIBS" \
--with-isl="$MINGW_LIBS" \
--with-system-zlib \
--enable-static \
--disable-shared \
--disable-multilib \
--disable-werror \
--disable-nls

PROCS="$(sysctl -n hw.ncpu 2>/dev/null)"
${MAKE:-make} -j $PROCS && ${MAKE:-make} install-strip
