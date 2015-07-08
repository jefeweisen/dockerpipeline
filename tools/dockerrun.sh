#!/bin/bash
pushd $(dirname "$0") > /dev/null
cd ..
adirRepo=$(pwd)
popd > /dev/null
"$adirRepo/chvdocker/tools/dockerrun.sh" "$@"
