#!/usr/bin/env bash

set -eo pipefail

QT_VERSION_MAJOR="5.15"
QT_VERSION="$QT_VERSION_MAJOR.14"
QT_DOWNLOAD_URL="https://download.qt.io/official_releases/qt/$QT_VERSION_MAJOR/$QT_VERSION/single/qt-everywhere-opensource-src-$QT_VERSION.tar.xz"
QT_FOLDER="qt-everywhere-src-$QT_VERSION"
QT_PREFIX="/usr/local/qt-$QT_VERSION"

export DEVELOPER_DIR="/Applications/Xcode_14.3.1.app/Contents/Developer"

# Download Qt sources
wget -q -O qt.tar.xz "$QT_DOWNLOAD_URL"
tar -xf qt.tar.xz

# Build Qt
mkdir qt-build
pushd qt-build
$GITHUB_WORKSPACE/$QT_FOLDER/configure QMAKE_APPLE_DEVICE_ARCHS="x86_64 arm64" -opensource -confirm-license -nomake examples -nomake tests -no-openssl -securetransport -prefix "$QT_PREFIX"
make -j4
make -j4 install
popd

# Package as tarball
tar -czf qt-mac-universal.tar.gz "$QT_PREFIX"
