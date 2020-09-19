@echo off

pushd %~dp0

docker run -it --rm --name skia-demo-wasm ^
  --volume %cd%:/work ^
  --volume %cd%\..\Skia\out\skia-wasm:/externals ^
  sts/skia-wasm-build ^
  /work/compile.sh release
if errorlevel 1 goto :error

echo :-) success!
goto :exit

:error
echo :-( failure!

:exit
popd