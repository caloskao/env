#!/bin/sh

BASEDIR=$(dirname "$0")

# import aliases
source $BASEDIR/aliases

# import sources
for file in $BASEDIR/inc/*.sh
    do . $file
done
