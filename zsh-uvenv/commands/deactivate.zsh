_uvenv_deactivate() {
    if [[ -z $VIRTUAL_ENV ]]; then
        echo "ℹ️  No virtual environment active"
        return 0
    fi

    # `deactivate` only exists in the shell that sourced bin/activate
    if (( ! $+functions[deactivate] )); then
        _uvenv_err "'${VIRTUAL_ENV:t}' was not activated in this shell, cannot deactivate it"
        return 1
    fi

    local env_name="${VIRTUAL_ENV:t}"
    deactivate
    echo "👋 Deactivated: $env_name"
}
