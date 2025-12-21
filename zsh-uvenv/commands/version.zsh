_uvenv_version() {
    local version_file="${ZSH_PLUGIN_PATH}/.version"

    if [[ -f $version_file ]]; then
        local ver
        ver=$(<"$version_file")
        echo "uvenv $ver"
    else
        echo "uvenv unknown"
    fi
}
