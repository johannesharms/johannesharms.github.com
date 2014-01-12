#!/usr/bin/env bash

# change into the script's directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
pushd $DIR > /dev/null

# deploy to github pages
docpad deploy-ghpages --env static

# change back into the original working directory
popd > /dev/null
