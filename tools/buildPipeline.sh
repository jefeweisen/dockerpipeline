#!/bin/bash
pushd $(dirname "$0") > /dev/null
cd ..
adirRepo=$(pwd)
popd > /dev/null
perl "$adirRepo/tools/sbtGitPublishLocal.pl" --verbose --repo https://github.com/jefeweisen/pipeline.git --branch aggregate-0.1
