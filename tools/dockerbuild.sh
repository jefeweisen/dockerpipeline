#!/bin/bash
pushd $(dirname "$0") > /dev/null
cd ..
adirRepo=$(pwd)
popd > /dev/null
sbt assembly
docker build -t dockerpipeline dockerbuild

