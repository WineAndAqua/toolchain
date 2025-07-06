#!/bin/sh -e

MINGW_LIBS=${MINGW_LIBS:=$(PWD)/../libs}

PATH=${MINGW_LIBS}/bin:${PATH}

VER=1.3.1
PKGNAME=mpc

if [ ! -f ${PKGNAME}-${VER}/${PKGNAME}-${VER}.tar.gz ]; then wget --continue https://ftp.gnu.org/gnu/${PKGNAME}/${PKGNAME}-${VER}.tar.gz; fi

rm -Rf ${PKGNAME}-${VER} && tar xf ${PKGNAME}-${VER}.tar.gz && cd ${PKGNAME}-${VER}

if [ -f ../../patches/${PKGNAME}-${VER}.patch ]; then patch -p1 < ../../patches/${PKGNAME}-${VER}.patch; fi

CC="clang" \
./configure \
--prefix="$MINGW_LIBS" \
--with-gmp="$MINGW_LIBS" \
--with-mpfr="$MINGW_LIBS" \
--disable-shared \
--enable-static

PROCS="$(sysctl -n hw.ncpu 2>/dev/null)"
${MAKE:-make} -j $PROCS

mkdir -p ${MINGW_LIBS}/include
cp src/mpc.h ${MINGW_LIBS}/include
mkdir -p ${MINGW_LIBS}/lib
cp -P src/.libs/*.a ${MINGW_LIBS}/lib
