_uvenv_version() {
    local version_file="${UVENV_PLUGIN_PATH}/.version"

    if [[ -f $version_file ]]; then
        echo "uvenv $(<"$version_file")"
    else
        echo "uvenv unknown"
    fi
}
