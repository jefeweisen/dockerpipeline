#!/bin/bash
pushd $(dirname "$0") > /dev/null
cd ..
adirRepo=$(pwd)
popd > /dev/null
mkdir -p src/main/resources
cp config/application.conf src/main/resources/application.conf
sbt assembly
rm -rf "$adirRepo/dockerbuild/dockerpipeline/script"
cp -r "$adirRepo/script" "$adirRepo/dockerbuild/dockerpipeline/script"

# or should we decoding git core.eol and core.autocrlf?
if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" || "$OSTYPE" == "win32" ]]
then
  dos2unix "$adirRepo/dockerbuild/dockerpipeline/script/*"
fi
# Spark binaries (e.g. spark-submit) install disabled.  For now, we're 
# doing only java-main style spark, which can all come from maven.
#bash "$adirRepo/tools/install_spark.sh"
docker build -t dockerpipeline dockerbuild

