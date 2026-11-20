_uvenv_list_help() {
    cat <<'EOF'
Usage: uvenv list [options]

List the virtual environments. The active one is marked with '*'.

Options:
    -b, --brief     Print names only, one per line
    -l, --long      Also print the Python version and project directory
    -h, --help      Show this help message
EOF
}


_uvenv_list() {
    local mode=default name active mark project pyver
    local -i width=0
    local -a names

    while (( $# )); do
        case $1 in
            -h|--help)  _uvenv_list_help; return 0 ;;
            -b|--brief) mode=brief ;;
            -l|--long)  mode=long ;;
            *)
                _uvenv_err "Unknown argument '$1'"
                _uvenv_list_help >&2
                return 1
                ;;
        esac
        shift
    done

    names=(${(f)"$(_uvenv_env_names)"})

    if [[ $mode == brief ]]; then
        (( $#names )) && print -r -l -- $names
        return 0
    fi

    if (( ! $#names )); then
        echo "No available virtual environments. Create one with: uvenv create <env_name>"
        return 0
    fi

    active="$(_uvenv_active_name)"

    for name in $names; do
        (( $#name > width )) && width=$#name
    done

    for name in $names; do
        mark=" "
        [[ $name == $active ]] && mark="*"

        if [[ $mode == long ]]; then
            project="$(_uvenv_project_of "$UVENV_HOME/$name")" || project="-"
            pyver="$(_uvenv_python_version_of "$UVENV_HOME/$name")" || pyver="?"
            printf '%s %-*s  %-10s %s\n' "$mark" $width "$name" "$pyver" "$project"
        else
            print -r -- "$mark $name"
        fi
    done
}
