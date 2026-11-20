# Python interpreters managed by uv (like `pyenv versions` / `pyenv install`)

_uvenv_versions() {
    _uvenv_require_uv || return 1
    uv python list --only-installed "$@"
}


_uvenv_install() {
    if (( $# == 0 )) || [[ $1 == (-h|--help) ]]; then
        cat <<'EOF'
Usage: uvenv install <python_version>...

Download and install Python versions with uv (e.g. uvenv install 3.12).
EOF
        (( $# > 0 ))
        return
    fi

    _uvenv_require_uv || return 1
    uv python install "$@"
}
