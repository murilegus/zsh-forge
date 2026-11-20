_uvenv_activate_help() {
    cat <<'EOF'
Usage: uvenv activate [options] [env_name]
       workon [options] [env_name]

Activate a virtual environment and cd into its project directory.
Without <env_name>, list the available virtual environments.

Options:
    -n, --no-cd     Do not cd into the project directory
    -c, --cd        cd into the project directory (default)
    -h, --help      Show this help message
EOF
}


_uvenv_activate() {
    local env_name="" env_path project no_cd=0
    local -a names

    while (( $# )); do
        case $1 in
            -h|--help)  _uvenv_activate_help; return 0 ;;
            -n|--no-cd) no_cd=1 ;;
            -c|--cd)    no_cd=0 ;;
            -*)
                _uvenv_err "Unknown option '$1'"
                _uvenv_activate_help >&2
                return 1
                ;;
            *)
                if [[ -n $env_name ]]; then
                    _uvenv_err "Unexpected argument '$1'"
                    _uvenv_activate_help >&2
                    return 1
                fi
                env_name="$1"
                ;;
        esac
        shift
    done

    # No name -> show envs list
    if [[ -z $env_name ]]; then
        uvenv list
        return
    fi

    if ! _uvenv_valid_name "$env_name"; then
        _uvenv_err "Invalid virtual environment name '$env_name'"
        return 1
    fi

    env_path="$UVENV_HOME/$env_name"

    if [[ ! -d $env_path ]]; then
        _uvenv_err "Virtual environment '$env_name' not found"
        names=(${(f)"$(_uvenv_env_names)"})
        if (( $#names )); then
            print -u2 -- "Available virtual environments:"
            print -u2 -r -l -- "  "${^names}
        else
            print -u2 -- "No available virtual environments. Create one with: uvenv create <env_name>"
        fi
        return 1
    fi

    if ! _uvenv_is_env "$env_path"; then
        _uvenv_err "'$env_name' is not a valid virtual environment (missing bin/activate or pyvenv.cfg)"
        return 1
    fi

    # Deactivate current venv if active
    if [[ -n $VIRTUAL_ENV ]] && (( $+functions[deactivate] )); then
        deactivate
    fi

    source "$env_path/bin/activate" || return 1
    echo "✅ Activated: $env_name"

    # Auto-cd into the project directory
    if (( ! no_cd )) && project="$(_uvenv_project_of "$env_path")"; then
        if [[ -d $project ]]; then
            cd "$project" && echo "📁 cd $project"
        else
            print -u2 -- "⚠️  Project directory not found: $project"
        fi
    fi

    return 0
}
