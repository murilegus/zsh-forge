_uvenv_remove_help() {
    cat <<'EOF'
Usage: uvenv remove [options] <env_name>...

Remove one or more virtual environments. Asks for confirmation once.

Options:
    -f, --force, -y, --yes  Remove without asking
    -h, --help              Show this help message
EOF
}


_uvenv_remove() {
    local force=0 name active
    local -a names

    while (( $# )); do
        case $1 in
            -h|--help)           _uvenv_remove_help; return 0 ;;
            -f|--force|-y|--yes) force=1 ;;
            -*)
                _uvenv_err "Unknown option '$1'"
                _uvenv_remove_help >&2
                return 1
                ;;
            *) names+=("$1") ;;
        esac
        shift
    done

    if (( ! $#names )); then
        _uvenv_remove_help >&2
        return 1
    fi

    # Validate everything before deleting anything
    active="$(_uvenv_active_name)"
    for name in $names; do
        if ! _uvenv_valid_name "$name"; then
            _uvenv_err "Invalid virtual environment name '$name'"
            return 1
        fi
        if [[ ! -d $UVENV_HOME/$name ]]; then
            _uvenv_err "Virtual environment '$name' not found"
            return 1
        fi
        if [[ $name == $active ]]; then
            _uvenv_err "Cannot remove the active virtual environment '$name', run 'workoff' first"
            return 1
        fi
    done

    # Ask once for the whole batch, never once per file
    if (( ! force )); then
        if ! _uvenv_confirm "Remove virtual environment(s) '${(j:', ':)names}' from $UVENV_HOME?"; then
            echo "Aborted"
            return 1
        fi
    fi

    for name in $names; do
        # `:?` aborts instead of deleting if either part is ever empty
        command rm -rf -- "${UVENV_HOME:?}/${name:?}" || return 1
        echo "🗑️  Removed: $name"
    done
}
