#!/bin/bash

# exit asap
set -ex

echo Updating skia...

BASE_DIR=~/skia

cd ${BASE_DIR}
python2 tools/git-sync-deps

EMCC=`which emcc`
EMCXX=`which em++`
EMAR=`which emar`

if [[ $@ == *debug* ]]; then
  echo "Building a Debug build"
  EXTRA_CFLAGS="\"-DSK_DEBUG\","
  BUILD_DIR=${BUILD_DIR:="/work/out/skia-wasm/debug"}
  IS_SKIA_DEBUG="is_debug=true"
  IS_SKIA_OFFICIAL="is_official_build=false"
else
  echo "Building a Release build"
  EXTRA_CFLAGS="\"-DSK_RELEASE\", \"-DGR_GL_CHECK_ALLOC_WITH_GET_ERROR=0\","
  BUILD_DIR=${BUILD_DIR:="/work/out/skia-wasm/release"}
  IS_SKIA_DEBUG="is_debug=false"
  IS_SKIA_OFFICIAL="is_official_build=true"
fi

mkdir -p $BUILD_DIR

./bin/fetch-gn

echo "Compiling skia libraries..."

./bin/gn gen ${BUILD_DIR} \
  --args="cc=\"${EMCC}\" \
  cxx=\"${EMCXX}\" \
  ar=\"${EMAR}\" \
  extra_cflags_cc=[\"-frtti\"] \
  extra_cflags=[\"-s\", \"WARN_UNALIGNED=1\", \"-s\", \"MAIN_MODULE=1\",
    \"-DSKNX_NO_SIMD\", \"-DSK_DISABLE_AAA\", \"-DSK_DISABLE_LEGACY_SHADERCONTEXT\",
    ${EXTRA_CFLAGS}
  ] \
  ${IS_SKIA_DEBUG} 
  ${IS_SKIA_OFFICIAL}
  is_component_build=false \
  werror=true \
  target_cpu=\"wasm\" \
  \
  skia_use_angle=false \
  skia_use_dng_sdk=false \
  skia_use_egl=true \
  skia_gl_standard=\"webgl\" \
  skia_use_expat=false \
  skia_use_fontconfig=false \
  skia_use_freetype=true \
  skia_use_libheif=false \
  skia_use_libjpeg_turbo_decode=true \
  skia_use_libjpeg_turbo_encode=true \
  skia_use_libpng_decode=true \
  skia_use_libpng_encode=true \
  skia_use_libwebp_decode=true \
  skia_use_libwebp_encode=false \
  skia_use_wuffs=true \
  skia_use_lua=false \
  skia_use_piex=false \
  skia_use_system_libpng=false \
  skia_use_system_freetype2=false \
  skia_use_system_libjpeg_turbo=false \
  skia_use_system_libwebp=false \
  skia_use_system_zlib=false\
  skia_use_vulkan=false \
  skia_use_zlib=true \
  skia_enable_gpu=true \
  skia_enable_tools=false \
  skia_enable_skshaper=false \
  skia_enable_ccpr=false \
  skia_enable_nvpr=false \
  skia_enable_fontmgr_custom_directory=false \
  skia_enable_fontmgr_custom_embedded=true \
  skia_enable_fontmgr_custom_empty=false \
  skia_enable_pdf=false"

# Build all the libs
~/depot_tools/ninja -C ${BUILD_DIR} libskia.a
