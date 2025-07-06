#!/bin/sh -e

MINGW_LIBS=${MINGW_LIBS:=$(PWD)/../libs}

PATH=${MINGW_LIBS}/bin:${PATH}

VER=1.3.1
PKGNAME=zlib

if [ ! -f ${PKGNAME}-${VER}.tar.gz ]; then wget --continue https://www.zlib.net/fossils/${PKGNAME}-${VER}.tar.gz; fi

rm -Rf ${PKGNAME}-${VER} && tar xf ${PKGNAME}-${VER}.tar.gz && cd ${PKGNAME}-${VER}

if [ -f ../../patches/${PKGNAME}-${VER}.patch ]; then patch -p1 < ../../patches/${PKGNAME}-${VER}.patch; fi

CC="clang" \
./configure --prefix="$MINGW_LIBS"

PROCS="$(sysctl -n hw.ncpu 2>/dev/null)"
${MAKE:-make} -j $PROCS

mkdir -p ${MINGW_LIBS}/include
cp zlib.h ${MINGW_LIBS}/include
cp zconf.h ${MINGW_LIBS}/include
mkdir -p ${MINGW_LIBS}/lib
cp -P *.a ${MINGW_LIBS}/lib
mkdir -p ${MINGW_LIBS}/lib/pkgconfig
cp zlib.pc ${MINGW_LIBS}/lib/pkgconfig
