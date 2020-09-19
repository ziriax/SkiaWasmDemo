#!/usr/bin/env bash
set -e

echo Setting emsdk environment...\ 
source ~/emsdk/emsdk_env.sh

echo Adding depot_tools to path...\ 
export PATH=~/depot_tools:${PATH}

exec "$@"
