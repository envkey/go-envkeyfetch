#!/bin/bash

version=${1?missing param 1 version}
branch=${2?missing param 2 branch}

echo $version $branch

THIS_DIR=$(
  cd "$(dirname "${BASH_SOURCE[0]}")"
  pwd -P
)
PUBLIC_GO_MOD_REPO=$(
  cd "$THIS_DIR/../../../../go-envkeyfetch"
  pwd -P
)

echo "SDK publish for envkey-fetch will only push source code to mirror (no artifacts)"
# assume the repo exists
cd $PUBLIC_GO_MOD_REPO || "did you git clone go-envkeyfetch mirror?"
pwd

git checkout -b "$branch"

rm -rf ./*

# files to move over
cp -r $THIS_DIR/* ./

# the lines in go.mod which start with "replace" are for local dev only
sed '/^replace / d' < $THIS_DIR/go.mod > ./go.mod

git add -A
git commit -m "Release v${version}"
git tag -m "v${version}" "v$version"
git push origin --tags "$branch"
