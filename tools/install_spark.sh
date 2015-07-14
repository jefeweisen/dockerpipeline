#!/bin/bash
pushd $(dirname "$0") > /dev/null
cd ..
adirRepo=$(pwd)
popd > /dev/null

set -e  # stop on errors

# configuration
versionSpark="1.2.2"
flavorSpark="hadoop2.4"
rnameSpark="spark-$versionSpark-bin-$flavorSpark"

# derived configuration
rfileSpark="$rnameSpark.tgz"
#see also mirror selection: "http://www.apache.org/dyn/closer.cgi/spark/$rnameSpark/$rnameSpark.tgz"
urlMirror="http://supergsego.com/apache/spark"
urlSpark="$urlMirror/$rnameSpark/$rfileSpark"
adirTargetParent="$adirRepo/dockerbuild/dockerpipeline"
adirTarget="$adirTargetParent/$rnameSpark"

if [[ -e "$adirTarget" ]]
then
  echo found spark already installed
  exit 0
fi

# generate temporary location
tStart=$(date "+%Y%m%d-%H%M%S")
adirTmp0="$adirRepo/tmp"
adirTmp="$adirTmp0/t$tStart"
mkdir -p "$adirTmp"

#fetch
echo curl -k -L "$urlSpark" -o "$adirTmp/$rfileSpark"
curl -k -L "$urlSpark" -o "$adirTmp/$rfileSpark"

#extract
mkdir -p "$adirTmp/files"
echo tar -C"$adirTmp/files" -xzf "$adirTmp/$rfileSpark"
tar -C"$adirTmp/files" -xzf "$adirTmp/$rfileSpark"

#atomic idempotent write
mkdir -p "$adirTargetParent"
rm -rf "$adirTarget"
mv "$adirTmp/files/$rnameSpark" "$adirTarget"

#cleanup
rm -rf "$adirTmp"
