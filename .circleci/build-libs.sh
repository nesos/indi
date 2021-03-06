#!/bin/bash

# This is a script building libraries for travis-ci
# It is *not* for general audience

SRC=../../3rdparty/

LIBS="libapogee libfishcamp libfli libqhy libqsi libsbig libinovasdk libdspau"

if [ .${CIRCLE_BRANCH%_*} == '.drv' -a `lsb_release -si` == 'Ubuntu' ] ; then 
    DRV=lib"${CIRCLE_BRANCH#drv_}"
    if [ -d 3rdparty/$DRV ] ; then
        LIBS="$DRV"
    else 
        LIBS=""
    fi
    echo "[$DRV] [$LIBS]"
fi

for lib in $LIBS ; do
(
    echo "Building $lib ..."
    mkdir -p build/$lib
    pushd build/$lib
    cmake -DCMAKE_INSTALL_PREFIX=/usr/local . $SRC/$lib -DFIX_WARNINGS=ON -DCMAKE_BUILD_TYPE=$1
    make
    make install
    popd
)
done
