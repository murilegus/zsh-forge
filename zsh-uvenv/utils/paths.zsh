# Root path for virtual environments
UVENV_HOME="$HOME/.local/share/uvenv"
mkdir -p "$UVENV_HOME"


uvenv_path() {
    echo "$UVENV_HOME/$1"
}
