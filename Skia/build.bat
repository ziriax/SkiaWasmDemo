@echo off

pushd %~dp0

docker build --target ubuntu -t sts/skia-wasm-ubuntu .
if errorlevel 1 goto :error

docker build --target source -t sts/skia-wasm-source .
if errorlevel 1 goto :error

docker build --target source -t sts/skia-wasm-checkout .
if errorlevel 1 goto :error

docker build --target build -t sts/skia-wasm-build .
if errorlevel 1 goto :error

docker run --rm --name skia-wasm --volume %cd%:/work sts/skia-wasm-build /work/compile.sh
if errorlevel 1 goto :error

echo :-) success!
goto :exit

:error
echo :-( failure!

:exit
popd
