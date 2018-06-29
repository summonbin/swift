#!/bin/sh
DRIVER_NAME="swift"
VERSION="0.1.0"
BASE_URL="https://raw.githubusercontent.com/summonbin/swift"


###################
#### Arguments ####
###################

INSTALL_PATH=$1
SCHEME_PATH=$2


######################
#### Build driver ####
######################

mkdir -p $INSTALL_PATH/$DRIVER_NAME
curl -L "$BASE_URL/$VERSION/scripts/setup.sh" -o "$INSTALL_PATH/$DRIVER_NAME/setup.sh"
curl -L "$BASE_URL/$VERSION/scripts/swift.sh" -o "$INSTALL_PATH/$DRIVER_NAME/swift.sh"
curl -L "$BASE_URL/$VERSION/scripts/run.sh" -o "$INSTALL_PATH/$DRIVER_NAME/run.sh"


######################
#### Build scheme ####
######################

mkdir -p $SCHEME_PATH/$DRIVER_NAME/package
echo "$INSTALL_PATH/cache/$DRIVER_NAME/package" > $SCHEME_PATH/$DRIVER_NAME/package/cache
