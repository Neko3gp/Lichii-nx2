#!/usr/bin/env bash
# Launches Lichii with host settings for a Ryzen 7 5700G + RX 6600 on Fedora KDE.
set -u

BIN="${LICHII_BIN:-$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)/build/zen3/bin/lichii}"

# Larger Mesa on-disk shader cache (the default is small for Switch 2 titles).
export MESA_SHADER_CACHE_MAX_SIZE="${MESA_SHADER_CACHE_MAX_SIZE:-20G}"

# Force the RX 6600 and skip the Vega iGPU. Get the id from: MESA_VK_DEVICE_SELECT=list vulkaninfo
# and export it as MESA_VK_DEVICE_SELECT=<vendor>:<device>! before running this script.

command -v powerprofilesctl >/dev/null && powerprofilesctl set performance 2>/dev/null

if command -v gamemoderun >/dev/null; then
    exec gamemoderun "$BIN" "$@"
fi
exec "$BIN" "$@"
