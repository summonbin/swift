#!/bin/sh -e
###################
#### Arguments ####
###################

CONFIG_DIR=$1
TARGET_SWIFT_VERSION=$2

# TODO: Swift Version Manager


##############################
#### Check version system ####
##############################

if [ "$TARGET_SWIFT_VERSION" = "system" ]
then
  return
fi
