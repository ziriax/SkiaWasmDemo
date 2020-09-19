@echo off

pushd %~dp0

docker run -it --rm --name skia-hello-wasm ^
  --volume %cd%:/work ^
  --volume %cd%\..\..\Dependencies\skia-wasm\out\skia-wasm:/externals ^
  sts/skia-wasm-build ^
  /bin/bash

popd
