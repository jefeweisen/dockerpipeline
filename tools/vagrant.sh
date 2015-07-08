#!/bin/bash
pushd $(dirname "$0") > /dev/null
cd ..
adirRepo=$(pwd)
env CHVDOCKER_YAML="$adirRepo/config/chvdocker.yaml" VAGRANT_CWD="$adirRepo/chvdocker" vagrant "$@"
