#!/bin/sh
pushd $(dirname "$0") > /dev/null
adirScript=$(pwd)
popd > /dev/null
echo "If the pipeline-based application has ExternalProcess scripts, put them in this directory: $adirScript"