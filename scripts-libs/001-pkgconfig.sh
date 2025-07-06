#!/bin/sh -e

MINGW_LIBS=${MINGW_LIBS:=$(PWD)/../libs}

PATH=${MINGW_LIBS}/bin:${PATH}

VER=0.29.2
PKGNAME=pkg-config

if [ ! -f ${PKGNAME}-${VER}.tar.gz ]; then wget --continue https://pkgconfig.freedesktop.org/releases/${PKGNAME}-${VER}.tar.gz; fi

rm -Rf ${PKGNAME}-${VER} && tar xf ${PKGNAME}-${VER}.tar.gz && cd ${PKGNAME}-${VER}

if [ -f ../../patches/${PKGNAME}-${VER}.patch ]; then patch -p1 < ../../patches/${PKGNAME}-${VER}.patch; fi

PKG_CONFIG=false \
CC="clang" \
CFLAGS="-Wno-error=int-conversion" \
./configure \
--prefix="$MINGW_LIBS" \
--disable-silent-rules \
--disable-host-tool \
--with-internal-glib \
--with-pc-path=${MINGW_LIBS}/lib/pkgconfig


PROCS="$(sysctl -n hw.ncpu 2>/dev/null)"
${MAKE:-make} -j $PROCS

install -d ${MINGW_LIBS}/bin
install -m 755 pkg-config ${MINGW_LIBS}/bin
install -d ${MINGW_LIBS}/share/aclocal
install -m 644 pkg.m4 ${MINGW_LIBS}/share/aclocal
