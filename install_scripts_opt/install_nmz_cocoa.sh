#!/usr/bin/env bash

set -e

source $(dirname "$0")/common.sh

if [ "$GMP_INSTALLDIR" != "" ]; then
    CPPFLAGS="${CPFFLAGS} -I${GMP_INSTALLDIR}/include"
    LDFLAGS="${LDFLAGS} -L${GMP_INSTALLDIR}/lib"
fi

##  script for the installation of CoCoALib
## as far as needed by libnormaliz

COCOA_VERSION="0.99710"
COCOA_URL="http://cocoa.dima.unige.it/cocoalib/tgz/CoCoALib-${COCOA_VERSION}.tgz"
COCOA_SHA256=80d472fd74c7972f8f2a239679e7ad8ae8a43676e3c259c2218ae2480a6267a8

echo "Installing CoCoA..."

# download & extract
mkdir -p ${NMZ_OPT_DIR}/CoCoA_source/
cd ${NMZ_OPT_DIR}/CoCoA_source/
../../download.sh ${COCOA_URL} ${COCOA_SHA256}
if [ ! -d CoCoALib-${COCOA_VERSION} ]; then
    tar xvf CoCoALib-${COCOA_VERSION}.tgz
fi

# configure & compile
cd CoCoALib-${COCOA_VERSION}
if [ ! -f configuration/autoconf.mk ]; then
    ./configure --threadsafe-hack --no-boost
fi
make library -j4
mkdir -p ${PREFIX}/include/CoCoA
cp include/CoCoA/*.H ${PREFIX}/include/CoCoA
mkdir -p ${PREFIX}/lib
cp lib/libcocoa.a ${PREFIX}/lib

echo "CoCoALib unstalled"
 
