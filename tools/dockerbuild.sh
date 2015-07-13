#!/bin/bash
pushd $(dirname "$0") > /dev/null
cd ..
adirRepo=$(pwd)
popd > /dev/null
mkdir -p src/main/resources
cp config/application.conf src/main/resources/application.conf
sbt assembly
mkdir -p "$adirRepo/dockerbuild/dockerpipeline/script"
cp -rf "$adirRepo/script" "$adirRepo/dockerbuild/dockerpipeline/script"
bash "$adirRepo/tools/install_spark.sh"
docker build -t dockerpipeline dockerbuild

