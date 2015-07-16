#!/bin/bash
pushd $(dirname "$0") > /dev/null
cd ..
adirRepo=$(pwd)
popd > /dev/null

if [[ -z "$1" ]]
then
  "$adirRepo/chvdocker/tools/dockerrun.sh" dockerpipeline java -jar //var/lib/dockerpipeline.jar
else
  "$adirRepo/chvdocker/tools/dockerrun.sh" "$@"
fi
