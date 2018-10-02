#!/bin/sh
###################
#### Arguments ####
###################

BASE_DIR=$(dirname "$0")
CONFIG_DIR=$1
TARGET_SWIFT_VERSION=$2

# Arguments for bin
BIN_ARGS=("$@")
unset BIN_ARGS[0]
unset BIN_ARGS[1]
BIN_ARGS=${BIN_ARGS[@]}


#####################
#### Setup Swift ####
#####################

source "$BASE_DIR/setup.sh" "$CONFIG_DIR" "$TARGET_SWIFT_VERSION"


#######################
#### Execute swift ####
#######################

if [ -t 1 ]
then
  swift $BIN_ARGS < /dev/tty
else
  swift $BIN_ARGS
fi
