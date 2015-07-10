#!/bin/bash
pushd $(dirname "$0") > /dev/null
cd ..
adirRepo=$(pwd)
env VAGRANT_CWD="$adirRepo/chvdocker" "$adirRepo/chvdocker/tools/extract_my_docker_certs.sh"
