#!/bin/sh
###################
#### Arguments ####
###################

CONFIG_DIR=$1
TARGET_SWIFT_VERSION=$2


#####################
#### Read config ####
#####################
CMAKE_CACHE_DIR=$(<$CONFIG_DIR/cmake/cache)
CMAKE_SOURCE_URL=$(<$CONFIG_DIR/cmake/source)


##############################
#### Check version system ####
##############################

if [ "$TARGET_SWIFT_VERSION" = "system" ]
then
  return
fi


#####################
#### Setup cmake ####
#####################

CMAKE_DOWNLOAD_FILE_NAME="${CMAKE_SOURCE_URL##*/}"
CMAKE_DIR="$CMAKE_CACHE_DIR/$CMAKE_DOWNLOAD_FILE_NAME"
CMAKE_DOWNLOAD_DIR="$CMAKE_DIR/download"
CMAKE_CONTENT_DIR="$CMAKE_DIR/content"
CMAKE_BIN_DIR="$CMAKE_CONTENT_DIR/bin"
CMAKE_BIN_PATH="$CMAKE_BIN_DIR/cmake"

if [ ! -f "$CMAKE_BIN_PATH" ]
then
  mkdir -p "$CMAKE_DOWNLOAD_DIR"
  curl -L -C - "$CMAKE_SOURCE_URL" -o "$CMAKE_DOWNLOAD_DIR/$CMAKE_DOWNLOAD_FILE_NAME"
  rm -rf "$CMAKE_CONTENT_DIR"
  mkdir -p "$CMAKE_CONTENT_DIR"
  tar xf "$CMAKE_DOWNLOAD_DIR/$CMAKE_DOWNLOAD_FILE_NAME" -C "$CMAKE_CONTENT_DIR" --strip-components=1
  (cd "$CMAKE_CONTENT_DIR" && ./bootstrap)
  (cd "$CMAKE_CONTENT_DIR" && make)
fi

export PATH="$CMAKE_BIN_DIR:$PATH"
