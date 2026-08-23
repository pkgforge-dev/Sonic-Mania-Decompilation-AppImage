#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
    cmake     \
    glew      \
    glfw      \
    libtheora \
    sdl2

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano libdecor-mini

echo "Building Sonic Mania Decompilation..."
echo "---------------------------------------------------------------"
REPO="https://github.com/RSDKModding/Sonic-Mania-Decompilation"
VERSION="$(git ls-remote "$REPO" HEAD | cut -c 1-9 | head -1)"
git clone --recursive --depth 1 "$REPO" ./SonicMania
echo "$VERSION" > ~/version

mkdir -p ./AppDir/bin
cd ./SonicMania
cmake -S ./ -B build -D CMAKE_BUILD_TYPE=Release -D RETRO_DISABLE_PLUS=OFF -D USE_SDL_AUDIO=ON
cmake --build build -j$(nproc)
mv -v ./build/dependencies/RSDKv5/RSDKv5U ./build/dependencies/RSDKv5/libGame.so ../AppDir/bin
