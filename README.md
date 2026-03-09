**These scripts compile the MinGW x86_64 and i386 toolchains for use with Wine on macOS.**

**Supported only on macOS 15 or later running on Apple Silicon.**

The following MacPorts tools are required:

`sudo port install autoconf automake make wget bison flex`

Set up shell environment variables for the MinGW toolchain.

These will be used by the build scripts for Wine and its dependency libraries:

`export MINGW_PATH=<path-to-installed-mingw-toolchain>`

`export PATH=$MINGW_PATH/bin:$PATH`
