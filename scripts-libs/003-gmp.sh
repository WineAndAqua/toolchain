#!/bin/sh -e

MINGW_LIBS=${MINGW_LIBS:=$(PWD)/../libs}

PATH=${MINGW_LIBS}/bin:${PATH}

VER=6.3.0
PKGNAME=gmp

if [ ! -f ${PKGNAME}-${VER}.tar.xz ]; then wget --continue https://gmplib.org/download/${PKGNAME}/${PKGNAME}-${VER}.tar.xz; fi

rm -Rf ${PKGNAME}-${VER} && tar xf ${PKGNAME}-${VER}.tar.xz && cd ${PKGNAME}-${VER}

if [ -f ../../patches/${PKGNAME}.patch ]; then patch -p1 < ../../patches/${PKGNAME}.patch; fi

CC="clang" \
ABI=64 \
./configure \
--prefix="$MINGW_LIBS" \
--disable-cxx \
--disable-shared \
--enable-static


PROCS="$(sysctl -n hw.ncpu 2>/dev/null)"
${MAKE:-make} -j $PROCS

mkdir -p ${MINGW_LIBS}/include
cp gmp.h ${MINGW_LIBS}/include
mkdir -p ${MINGW_LIBS}/lib
cp -P .libs/*.a ${MINGW_LIBS}/lib
mkdir -p ${MINGW_LIBS}/lib/pkgconfig
cp gmp.pc ${MINGW_LIBS}/lib/pkgconfig
