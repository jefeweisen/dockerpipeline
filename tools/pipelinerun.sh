#!/bin/bash
pushd $(dirname "$0") > /dev/null
cd ..
adirRepo=$(pwd)
popd > /dev/null
"$adirRepo/tools/dockerbuild.sh"
"$adirRepo/tools/dockerrun.sh" dockerpipeline java -agentlib:jdwp=transport=dt_socket,address=4000,suspend=n,server=y -jar /var/lib/dockerpipeline.jar

