@echo off
start http://localhost:8000
pushd out\release
python %~dp0serve.py
popd
