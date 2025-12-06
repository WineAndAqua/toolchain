#!/bin/sh -e

MINGW_LIBS=${MINGW_LIBS:=$(PWD)/../libs}

PATH=${MINGW_LIBS}/bin:${PATH}

VER=0.27
PKGNAME=isl

if [ ! -f ${PKGNAME}-${VER}/${PKGNAME}-${VER}.tar.xz ]; then wget --continue https://libisl.sourceforge.io/${PKGNAME}-${VER}.tar.xz; fi

rm -Rf ${PKGNAME}-${VER} && tar xf ${PKGNAME}-${VER}.tar.xz && cd ${PKGNAME}-${VER}

if [ -f ../../patches/${PKGNAME}-${VER}.patch ]; then patch -p1 < ../../patches/${PKGNAME}-${VER}.patch; fi

CC="clang" \
./configure \
--prefix="$MINGW_LIBS" \
--with-gmp-prefix="$MINGW_LIBS" \
--disable-shared \
--enable-static

PROCS="$(sysctl -n hw.ncpu 2>/dev/null)"
${MAKE:-make} -j $PROCS

mkdir -p ${MINGW_LIBS}/include/isl
cp include/isl/*.h ${MINGW_LIBS}/include/isl
mkdir -p ${MINGW_LIBS}/lib
cp -P .libs/*.a ${MINGW_LIBS}/lib
mkdir -p ${MINGW_LIBS}/lib/pkgconfig
cp isl.pc ${MINGW_LIBS}/lib/pkgconfig
