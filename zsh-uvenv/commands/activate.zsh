show_available_venv() {
    echo "Available virtual environments:"
    uvenv lsvenv
}

_uvenv_activate() {
    local env_name env_path activate_script manifest workdir

    # Check if not args -> show envs list
    if [[ $# -eq 0 ]]; then
        show_available_venv
        return 0
    fi

    env_name="$1"
    env_path="$UVENV_HOME/$env_name"
    activate_script="$env_path/bin/activate"
    manifest="$env_path/.manifest"

    if [[ ! -d "$env_path" ]]; then
        echo "❌ Virtual environment '$env_name' not found"
        show_available_venv
        return 1
    fi

    if [[ ! -f "$activate_script" ]]; then
        echo "❌ '$env_name' has no bin/activate"
        return 1
    fi

    # Deactivate current venv if active
    if [ -n "$VIRTUAL_ENV" ]; then
        deactivate 2>/dev/null
    fi

    # Activate venv
    source "$activate_script"

    # Auto-cd using manifest
    if [[ -f "$manifest" ]]; then
        workdir="$(grep '^WORKDIR=' "$manifest" | cut -d= -f2-)"

        if [ -d "$workdir" ]; then
            cd "$workdir" || return
            echo "📁 cd $workdir"
        else
            echo "⚠️  Workdir not found: $workdir"
        fi
    fi

    echo "✅ Activated: $env_name"
}
