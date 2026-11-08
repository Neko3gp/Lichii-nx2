#!/usr/bin/env bash
# Local Release build for Ryzen 7 5700G (Zen 3) on Fedora: clang, ThinLTO, -march=znver3.
set -euo pipefail

SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
BUILD="${BUILD_DIR:-$SRC/build/zen3}"
JOBS="${JOBS:-$(nproc)}"

if [ "${1:-}" = "--deps" ]; then
    sudo dnf install -y autoconf cmake fmt-devel gcc{,-c++} clang lld ccache glslang hidapi-devel \
        json-devel libtool libusb1-devel libzstd-devel lz4-devel nasm ninja-build openssl-devel \
        pulseaudio-libs-devel qt6-linguist qt6-qtbase{-private,}-devel qt6-qtmultimedia-devel \
        qt6-charts-devel speexdsp-devel wayland-devel zlib-devel ffmpeg-devel libXext-devel boost jq \
        vulkan-tools mesa-vulkan-drivers gamemode
    exit 0
fi

LTO="-flto=thin"
cmake -S "$SRC" -B "$BUILD" -G Ninja \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_C_COMPILER=clang \
    -DCMAKE_CXX_COMPILER=clang++ \
    "-DCMAKE_C_FLAGS=$LTO" \
    "-DCMAKE_CXX_FLAGS=$LTO" \
    "-DCMAKE_EXE_LINKER_FLAGS=-fuse-ld=lld" \
    "-DCMAKE_SHARED_LINKER_FLAGS=-fuse-ld=lld" \
    -DYUZU_BUILD_PRESET=zen3 \
    -DBUILD_TESTING=OFF \
    -DYUZU_TESTS=OFF \
    -DYUZU_CMD=ON \
    -DYUZU_ROOM=OFF \
    -DYUZU_ROOM_STANDALONE=OFF \
    -DYUZU_USE_BUNDLED_QT=OFF \
    -DYUZU_USE_BUNDLED_SDL3=ON \
    -DVulkanHeaders_FORCE_BUNDLED=ON \
    -DVulkanUtilityLibraries_FORCE_BUNDLED=ON \
    -DENABLE_UPDATE_CHECKER=OFF \
    -DUSE_DISCORD_PRESENCE=OFF \
    -DUSE_CCACHE=ON

cmake --build "$BUILD" --target yuzu --parallel "$JOBS"
echo "Listo: $BUILD/bin/lichii"
