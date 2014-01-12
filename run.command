#!/usr/bin/env bash

# change into the script's directory
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
pushd $DIR > /dev/null

# start the server
docpad run

# change back into the original working directory
popd > /dev/null
