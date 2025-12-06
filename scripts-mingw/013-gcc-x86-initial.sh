#!/bin/sh

MINGW_LIBS=${MINGW_LIBS:=$(PWD)/../libs}

PATH=${MINGW_LIBS}/bin:${PATH}

VER=15.2.0
PKGNAME=gcc

if [ ! -f ${PKGNAME}-${VER}.tar.xz ]; then wget --continue https://ftp.gnu.org/gnu/${PKGNAME}/${PKGNAME}-${VER}/${PKGNAME}-${VER}.tar.xz; fi

rm -Rf ${PKGNAME}-${VER} && tar xf ${PKGNAME}-${VER}.tar.xz && cd ${PKGNAME}-${VER}

if [ -f ../../patches/${PKGNAME}-${VER}.patch ]; then patch -p1 < ../../patches/${PKGNAME}-${VER}.patch; fi

ARCH=i686

ARCH_DIR=${MINGW_PATH}

PATH=${ARCH_DIR}/bin:${PATH}

TARGET="${ARCH}-w64-mingw32"

rm -f "${ARCH_DIR}/mingw"; ln -s "${TARGET}" "${ARCH_DIR}/mingw"

mkdir -p "build-$ARCH" && cd "build-$ARCH"

../configure \
--prefix="$ARCH_DIR" \
--with-sysroot="$ARCH_DIR" \
--target="$TARGET" \
--with-gmp="$MINGW_LIBS" \
--with-mpfr="$MINGW_LIBS" \
--with-mpc="$MINGW_LIBS" \
--with-isl="$MINGW_LIBS" \
--with-ld="$ARCH_DIR/bin/$TARGET-ld" \
--with-as="$ARCH_DIR/bin/$TARGET-as" \
--with-system-zlib \
--with-zstd=no \
--enable-static \
--disable-shared \
--enable-languages=c,c++ \
--disable-multilib \
--disable-nls \
--enable-lto \
--with-dwarf4

PROCS="$(sysctl -n hw.ncpu 2>/dev/null)"
${MAKE:-make} -j $PROCS all-gcc && ${MAKE:-make} install-gcc
