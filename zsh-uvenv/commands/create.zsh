_uvenv_create_help() {
    cat <<'EOF'
Usage: uvenv create [options] <env_name> [-- <uv venv options>]
       mkvirtualenv [options] <env_name>

Create a new virtual environment with `uv venv` and activate it.

Arguments:
    <env_name>                  The name of the virtual environment

Options:
    -p, --python <version>      Python version or interpreter (e.g. 3.11)
    -a, --project <path>        Project directory to cd into on `workon`
    -r, --requirements <file>   Install packages from a requirements file
    -i, --install <package>     Install a package (can be repeated)
    -n, --no-activate           Do not activate the new environment
    -h, --help                  Show this help message
EOF
}


_uvenv_create() {
    local env_name="" python_version="" project_path="" requirements=""
    local activate=1 opt ret
    local -a packages uv_args cmd install_args

    while (( $# )); do
        case $1 in
            -h|--help)
                _uvenv_create_help
                return 0
                ;;
            -n|--no-activate) activate=0 ;;
            --python=*)       python_version="${1#*=}" ;;
            --project=*)      project_path="${1#*=}" ;;
            --requirements=*) requirements="${1#*=}" ;;
            --install=*)      packages+=("${1#*=}") ;;
            -p|--python|-a|--project|-r|--requirements|-i|--install)
                opt="$1"
                if (( $# < 2 )); then
                    _uvenv_err "Option '$opt' requires a value"
                    return 1
                fi
                shift
                case $opt in
                    -p|--python)       python_version="$1" ;;
                    -a|--project)      project_path="$1" ;;
                    -r|--requirements) requirements="$1" ;;
                    -i|--install)      packages+=("$1") ;;
                esac
                ;;
            --)
                shift
                uv_args=("$@")
                break
                ;;
            -*)
                _uvenv_err "Unknown option '$1'"
                _uvenv_create_help >&2
                return 1
                ;;
            *)
                if [[ -n $env_name ]]; then
                    _uvenv_err "Unexpected argument '$1'"
                    _uvenv_create_help >&2
                    return 1
                fi
                env_name="$1"
                ;;
        esac
        shift
    done

    # Validate arguments before creating anything
    if [[ -z $env_name ]]; then
        _uvenv_err "Missing required argument <env_name>"
        _uvenv_create_help >&2
        return 1
    fi

    if ! _uvenv_valid_name "$env_name"; then
        _uvenv_err "Invalid virtual environment name '$env_name' (no '/', no leading '.' or '-')"
        return 1
    fi

    if [[ -n $requirements && ! -f $requirements ]]; then
        _uvenv_err "Requirements file not found: $requirements"
        return 1
    fi

    _uvenv_require_uv || return 1

    # Path to store the environment
    local env_path="$UVENV_HOME/$env_name"

    if [[ -e $env_path ]]; then
        _uvenv_err "Virtual environment '$env_name' already exists at $env_path"
        return 1
    fi

    if [[ -n $project_path ]]; then
        if ! command mkdir -p -- "$project_path"; then
            _uvenv_err "Cannot create project directory: $project_path"
            return 1
        fi
        # Store an absolute path, so `workon` works from any directory
        project_path="${project_path:A}"
    fi

    command mkdir -p -- "$UVENV_HOME" || return 1

    # Build uv command
    cmd=(uv venv)
    [[ -n $python_version ]] && cmd+=(--python "$python_version")
    cmd+=("$uv_args[@]" "$env_path")

    "$cmd[@]"
    ret=$?

    if (( ret != 0 )); then
        _uvenv_err "Failed to create virtual environment '$env_name'"
        return $ret
    fi

    # Bind the project directory (same `.project` file as virtualenvwrapper)
    if [[ -n $project_path ]]; then
        print -r -- "$project_path" > "$env_path/.project"
    fi

    # Install requested packages
    [[ -n $requirements ]] && install_args+=(-r "$requirements")
    install_args+=("$packages[@]")

    if (( $#install_args )); then
        uv pip install --python "$env_path/bin/python" "$install_args[@]"
        ret=$?
        if (( ret != 0 )); then
            _uvenv_err "Virtual environment '$env_name' was created, but installing packages failed"
            return $ret
        fi
    fi

    echo "✅ Created: $env_name"

    if (( activate )); then
        uvenv activate "$env_name"
    fi
}
