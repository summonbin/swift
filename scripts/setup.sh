#!/bin/sh
####################
#### Dependency ####
####################
SWIFTENV_REPO_URL="https://github.com/kylef/swiftenv"
NINJA_REPO_URL="https://github.com/ninja-build/ninja"


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
SWIFTENV_CACHE_DIR=$(<$CONFIG_DIR/swiftenv/cache)
SWIFTENV_VERSION=$(<$CONFIG_DIR/swiftenv/version)
NINJA_VERSION=$(<$CONFIG_DIR/ninja/version)


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


########################
#### Setup swiftenv ####
########################

SWIFTENV_DIR="$SWIFTENV_CACHE_DIR/$SWIFTENV_VERSION"

# Clone swiftenv
if [ ! -d "$SWIFTENV_DIR/bin" ]
then
  rm -rf "$SWIFTENV_DIR"
  git clone $SWIFTENV_REPO_URL $SWIFTENV_DIR -b $SWIFTENV_VERSION --single-branch --depth 1
fi

export SWIFTENV_ROOT="$PWD/$SWIFTENV_DIR"
export PATH="$SWIFTENV_ROOT/bin:$PATH"
eval "$(swiftenv init -)"


#####################
#### Setup ninja ####
#####################

NINJA_DIR="$SWIFTENV_DIR/tmp/swiftenv-build-$TARGET_SWIFT_VERSION/ninja"

# Clone ninja
if [ ! -f "$NINJA_DIR/configure.py" ]
then
  rm -rf "$NINJA_DIR"
  git clone $NINJA_REPO_URL $NINJA_DIR -b $NINJA_VERSION --single-branch --depth 1
fi

swiftenv install "$TARGET_SWIFT_VERSION" --build
export SWIFT_VERSION="$TARGET_SWIFT_VERSION"
