_uvenv_wipe() {
    local force=0 env_name="" env_path packages ret

    while (( $# )); do
        case $1 in
            -h|--help)
                cat <<'EOF'
Usage: uvenv wipe [options] [env_name]

Uninstall every package from a virtual environment (default: the active one).

Options:
    -f, --force, -y, --yes  Wipe without asking
    -h, --help              Show this help message
EOF
                return 0
                ;;
            -f|--force|-y|--yes) force=1 ;;
            -*) _uvenv_err "Unknown option '$1'"; return 1 ;;
            *)  env_name="$1" ;;
        esac
        shift
    done

    _uvenv_require_uv || return 1
    _uvenv_resolve "$env_name" || return 1
    env_path="$REPLY"

    packages="$(uv pip list --python "$env_path/bin/python" --format freeze)"
    ret=$?

    if (( ret != 0 )); then
        _uvenv_err "Failed to list packages of '${env_path:t}'"
        return $ret
    fi

    if [[ -z $packages ]]; then
        echo "Nothing to remove in '${env_path:t}'"
        return 0
    fi

    if (( ! force )) && ! _uvenv_confirm "Uninstall every package from '${env_path:t}'?"; then
        echo "Aborted"
        return 1
    fi

    # name==version lines -> package names
    uv pip uninstall --python "$env_path/bin/python" ${${(f)packages}%%==*}
}
