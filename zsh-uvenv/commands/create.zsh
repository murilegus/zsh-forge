help_create() {
    cat <<'EOF'
Usage: uvenv create [options] <env_name>

Arguments:
    [env_name]          The name of virtual enviroment

Options:
    --python=<version>  Specify Python version (e.g., 3.11)
    --project=<path>    Path to project directory
    -h, --help          Show this help message
EOF
}


_uvenv_create() {
    # Parse arguments
    local env_name=""
    local python_version=""
    local project_path=""

    for arg in "$@"; do
        case $arg in
            -h|--help)
                help_create
                return 0
                ;;
            --python=*)
                python_version="${arg#--python=}"
                ;;
            --project=*)
                project_path="${arg#--project=}"
                ;;
            *)
                if [[ -z $env_name ]]; then
                    env_name="$arg"
                else
                    echo "Error: unknown argument '$arg'"
                    help_create
                    return 1
                fi
                ;;
        esac
    done


    # Validate environment name
    if [[ -z $env_name ]] then
        echo "Error: require param <env_name> cannot be empty!"
        help_create
        return 1
    fi

    # Check if uv is installed
    if ! command -v uv >/dev/null 2>&1; then
        echo "Error: 'uv' command not found. Please install uv first to using uvenv!"
        echo "hint: install using command below"
        echo "curl -LsSf https://astral.sh/uv/install.sh | sh"
        echo "or if you prefer wget instead"
        echo "wget -qO- https://astral.sh/uv/install.sh | sh"
        return 1
    fi

    # Path to store the environment
    local env_path="$UVENV_HOME/$env_name"

    # Check if environment already exists
    if [[ -d $env_path ]]; then
        echo "Error: virtual environment $env_name already exists at $env_path"
        return 1
    fi

    # Build uv command
    local cmd=("uv" "venv" "$env_path")
    if [[ -n $python_version ]]; then
        cmd+=("--python=$python_version")
    fi

    # Execute command
    "${cmd[@]}"
    local ret=$?

    if (( ret != 0 )); then
        echo "Error: failed to create virtual environment"
        return $ret
    fi

    # If project path is specified, store it in a per-env manifest
    if [[ -n $project_path ]]; then
        if [[ ! -d $project_path ]]; then
            mkdir -p $project_path
        fi

        # Store manifest inside the environment folder
        if [[ -d $project_path ]]; then
            local manifest_file="$env_path/.manifest"
            echo "Store workdir at: $project_path"
            echo "WORKDIR=$project_path" > "$manifest_file"
        else
            echo "Error: workdir $project_path does not exists and cannot to create!"
            echo "Manually create the workdir and set this path to the $env_path/.manifest file"
        fi
    fi
}
