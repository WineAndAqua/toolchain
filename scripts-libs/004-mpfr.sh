#!/bin/sh -e

MINGW_LIBS=${MINGW_LIBS:=$(PWD)/../libs}

PATH=${MINGW_LIBS}/bin:${PATH}

VER=4.2.2
PKGNAME=mpfr

if [ ! -f ${PKGNAME}-${VER}/${PKGNAME}-${VER}.tar.xz ]; then wget --continue https://www.mpfr.org/${PKGNAME}-${VER}/${PKGNAME}-${VER}.tar.xz; fi

rm -Rf ${PKGNAME}-${VER} && tar xf ${PKGNAME}-${VER}.tar.xz && cd ${PKGNAME}-${VER}

if [ -f ../../patches/${PKGNAME}-${VER}.patch ]; then patch -p1 < ../../patches/${PKGNAME}-${VER}.patch; fi

CC="clang" \
./configure \
--prefix="$MINGW_LIBS" \
--with-gmp="$MINGW_LIBS" \
--disable-shared \
--enable-static

PROCS="$(sysctl -n hw.ncpu 2>/dev/null)"
${MAKE:-make} -j $PROCS

mkdir -p ${MINGW_LIBS}/include
cp src/mpfr.h ${MINGW_LIBS}/include
mkdir -p ${MINGW_LIBS}/lib
cp -P src/.libs/*.a ${MINGW_LIBS}/lib
mkdir -p ${MINGW_LIBS}/lib/pkgconfig
cp mpfr.pc ${MINGW_LIBS}/lib/pkgconfig
