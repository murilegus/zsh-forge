#!/usr/bin/env sh
set -e

PLUGIN_NAME="zsh-uvenv"


# Resolve script directory
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

[ -f "$SCRIPT_DIR/zsh-uvenv.plugin.zsh" ] || {
  echo "❌ install.sh must be run from project root"
  exit 1
}


# Detect ZSH_CUSTOM
if [ -n "$ZSH_CUSTOM" ]; then
    CUSTOM_DIR="$ZSH_CUSTOM"
else
    CUSTOM_DIR="$HOME/.oh-my-zsh/custom"
fi

PLUGIN_DIR="$CUSTOM_DIR/plugins/$PLUGIN_NAME"

echo "🔧 Installing $PLUGIN_NAME..."
echo "📂 Source: $SCRIPT_DIR"
echo "📂 Target: $PLUGIN_DIR"


# Ensure plugins directory exists
mkdir -p "$CUSTOM_DIR/plugins"


# If plugin already exists
if [ -d "$PLUGIN_DIR" ]; then
    echo "⚠️  Plugin already exists, updating..."
    rm -rf "$PLUGIN_DIR"
fi


# Copy project
cp -R "$SCRIPT_DIR" "$PLUGIN_DIR"


# Remove install.sh from target (optional but clean)
rm -f "$PLUGIN_DIR/install.sh"

echo "✅ Installed $PLUGIN_NAME"

cat <<EOF

👉 Next steps:

1. Add plugin to ~/.zshrc

   plugins=(
     $PLUGIN_NAME
   )

2. Reload shell

   source ~/.zshrc

3. Try it

   workon
   uvenv help

EOF
