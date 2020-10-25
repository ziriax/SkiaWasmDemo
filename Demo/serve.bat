@echo off
start http://localhost:8000
pushd %~dp0out\release
python %~dp0serve.py
popd
