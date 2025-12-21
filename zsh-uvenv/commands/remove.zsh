_uvenv_remove() {
    local env_name=$1

    if [[ -z $env_name ]]; then
        echo "Usage: uvenv remove <env_name>"
        return 1
    fi

    rm -ri "$UVENV_HOME/$env_name"
}
