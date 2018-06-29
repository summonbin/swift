#!/bin/sh
###################
#### Arguments ####
###################

BASE_DIR=$(dirname "$0")
CONFIG_DIR=$1
BIN_NAME=$2
TARGET_SWIFT_VERSION=$3
GIT_URL=$4
GIT_BRANCH=$5

# Arguments for bin
BIN_ARGS=("$@")
unset BIN_ARGS[0]
unset BIN_ARGS[1]
unset BIN_ARGS[2]
unset BIN_ARGS[3]
unset BIN_ARGS[4]
BIN_ARGS=${BIN_ARGS[@]}


#####################
#### Read config ####
#####################

PACKAGE_CACHE_DIR=$(<$CONFIG_DIR/package/cache)


#####################
#### Setup Swift ####
#####################

source $BASE_DIR/setup.sh $CONFIG_DIR $TARGET_SWIFT_VERSION


########################
#### Execute binary ####
########################

PACKAGE_DIR=$PACKAGE_CACHE_DIR/$TARGET_SWIFT_VERSION/$BIN_NAME/$GIT_BRANCH
BIN_PATH=$PACKAGE_DIR/.build/release/$BIN_NAME

# Clone swift repository
if [ ! -d "$PACKAGE_DIR/.git" ]
then
  rm -rf $PACKAGE_DIR
  git clone $GIT_URL $PACKAGE_DIR -b $GIT_BRANCH --single-branch --depth 1
fi

# Build
if [ ! -f "$BIN_PATH" ]
then
  swift build --package-path=$PACKAGE_DIR -c release -Xswiftc -static-stdlib --disable-sandbox
fi

# Execute
if [ -t 1 ]
then
  $BIN_PATH $BIN_ARGS < /dev/tty
else
  $BIN_PATH $BIN_ARGS
fi
