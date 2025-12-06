#!/bin/sh

MINGW_LIBS=${MINGW_LIBS:=$(PWD)/../libs}

PATH=${MINGW_LIBS}/bin:${PATH}

VER=16.3
PKGNAME=gdb

if [ ! -f ${PKGNAME}-${VER}.tar.xz ]; then wget --continue https://ftp.gnu.org/gnu/${PKGNAME}/${PKGNAME}-${VER}.tar.xz; fi

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
--with-gmp="$MINGW_LIBS" \
--with-mpfr="$MINGW_LIBS" \
--with-mpc="$MINGW_LIBS" \
--with-isl="$MINGW_LIBS" \
--with-ld="$ARCH_DIR/bin/$TARGET-ld" \
--with-as="$ARCH_DIR/bin/$TARGET-as" \
--with-system-zlib \
--with-python=/opt/local/bin/python3 \
--enable-static \
--disable-shared \
--disable-guile \
--disable-nls \
--disable-werror \
--disable-sim

PROCS="$(sysctl -n hw.ncpu 2>/dev/null)"
${MAKE:-make} -j $PROCS && ${MAKE:-make} install

cat > gdb-entitlement.xml <<'EOF'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
"http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>com.apple.security.cs.allow-jit</key>
    <true/>
    <key>com.apple.security.cs.allow-unsigned-executable-memory</key>
    <true/>
    <key>com.apple.security.cs.allow-dyld-environment-variables</key>
    <true/>
    <key>com.apple.security.cs.disable-library-validation</key>
    <true/>
    <key>com.apple.security.cs.disable-executable-page-protection</key>
    <true/>
    <key>com.apple.security.cs.debugger</key>
    <true/>
    <key>com.apple.security.get-task-allow</key>
    <true/>
</dict>
</plist>
EOF

codesign --force --sign - --options=runtime --entitlements gdb-entitlement.xml "$ARCH_DIR/bin/$TARGET-gdb"
