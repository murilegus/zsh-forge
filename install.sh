#!/usr/bin/env sh
# Install zsh-forge plugins into $ZSH_CUSTOM/plugins
# Usage: ./install.sh [plugin_name...]   (default: every plugin)
set -e

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"

if [ "$#" -eq 0 ]; then
    for installer in "$ROOT_DIR"/zsh-*/install.sh; do
        [ -f "$installer" ] || continue
        set -- "$@" "$(basename "$(dirname "$installer")")"
    done
fi

if [ "$#" -eq 0 ]; then
    echo "❌ No plugins found in $ROOT_DIR" >&2
    exit 1
fi

for plugin in "$@"; do
    installer="$ROOT_DIR/$plugin/install.sh"
    if [ ! -f "$installer" ]; then
        echo "❌ Unknown plugin '$plugin'" >&2
        exit 1
    fi
    sh "$installer"
done
