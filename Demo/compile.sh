#!/bin/bash
# Copyright 2019 Google LLC
#
# Use of this source code is governed by a BSD-style license that can be
# found in the LICENSE file.

set -ex

# This expects the environment variable EMSDK to be set
if [[ ! -d $EMSDK ]]; then
  echo "Be sure to set the EMSDK environment variable."
  exit 1
fi

source $EMSDK/emsdk_env.sh
EMCC=`which emcc`
EMCXX=`which em++`
EMAR=`which emar`

if [[ $@ == *debug* ]]; then
  echo "Building a Debug build"
  RELEASE_CONF="-O0 --js-opts 0 -s DEMANGLE_SUPPORT=1 -s ASSERTIONS=1 -s GL_ASSERTIONS=1 -g4 -DSK_DEBUG --source-map-base /"
  EXTERNALS_FOLDER=/externals/debug
  BUILD_DIR=${BUILD_DIR:="out/debug"}
else
  echo "Building a Release build"
  # RELEASE_CONF="-Oz --closure 1 -DSK_RELEASE -DGR_GL_CHECK_ALLOC_WITH_GET_ERROR=0"

  # HACK: Faster builds with -O0
  RELEASE_CONF="-O0 --js-opts 0 -DSK_RELEASE -DGR_GL_CHECK_ALLOC_WITH_GET_ERROR=0"
  EXTERNALS_FOLDER=/externals/release
  BUILD_DIR=${BUILD_DIR:="out/release"}
fi

mkdir -p $BUILD_DIR

WASM_GPU="-lEGL -lGLESv2 -DSK_SUPPORT_GPU=1 -DSK_GL -DSK_DISABLE_LEGACY_SHADERCONTEXT"

# Emscripten prefers that the .a files go last in order, otherwise, it
# may drop symbols that it incorrectly thinks aren't used. One day,
# Emscripten will use LLD, which may relax this requirement.
# ${EMCXX} \
#     $RELEASE_CONF \
#     -I. \
#     -I~/skia/include \
#     -I~/skia/include/core \
#     -DSK_DISABLE_AAA \
#     -std=c++17 \
#     $WASM_GPU \
#     ${EXTERNALS_FOLDER}/libskia.a \
#     -s ALLOW_MEMORY_GROWTH=1 \
#     -s FORCE_FILESYSTEM=0 \
#     -s MODULARIZE=1 \
#     -s NO_EXIT_RUNTIME=1 \
#     -s STRICT=1 \
#     -s INITIAL_MEMORY=128MB \
#     -s WARN_UNALIGNED=1 \
#     -s WASM=1 \
#     -s USE_WEBGL2=1 \
#     -o $BUILD_DIR/index.html

# Compile
# NOTE: MODULARIZE should be set to 1, the module should be loaded in javascript using a promise
# See https://emscripten.org/docs/getting_started/FAQ.html
#
# NOTE: Had to remove -s STRICT=1, got linker errors (emscripten_sleep not defined)
# NOTE: Had to set ERROR_ON_UNDEFINED_SYMBOLS to 0, to workaround linker errors :(
#
# SK_BUILD_FOR_WASM is our own symbol, nothing to do with Skia.
${EMCXX} \
    -I . \
    -I ~/skia/include/core \
    -I ~/skia/include/effects \
    -I ~/skia \
    -std=c++17 \
    -s WASM=1 \
    -s USE_SDL=2 \
    -s ALLOW_MEMORY_GROWTH=1 \
    -s FORCE_FILESYSTEM=0 \
    -s MODULARIZE=0 \
    -s NO_EXIT_RUNTIME=1 \
    -s INITIAL_MEMORY=128MB \
    -s WARN_UNALIGNED=1 \
    -s ERROR_ON_UNDEFINED_SYMBOLS=0 \
    -DSK_BUILD_FOR_WASM \
    ${WASM_GPU} \
    ${RELEASE_CONF} \
    ${EXTERNALS_FOLDER}/libskia.a \
    -o $BUILD_DIR/index.html \
    ./main.cpp

# Test
# node $BUILD_DIR/index.js

