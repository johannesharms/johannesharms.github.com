#!/usr/bin/env bash

# change into the script's directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
pushd $DIR > /dev/null

# configuration
OUT=out

# clean the git repo in ./out/
git fetch --all
git fetch --tags
rm -rf $OUT
mkdir $OUT
cp -r .git $OUT/.git
pushd out > /dev/null
git checkout --track origin/master
git checkout master
git pull
#git reset --hard origin/master
popd > /dev/null

# deploy to out folder
docpad generate --env static

# commit the out folder's contents
pushd $OUT > /dev/null
git add -A --force
git commit -m "`date`"
git push -f
popd > /dev/null


# change back into the original working directory
popd > /dev/null
