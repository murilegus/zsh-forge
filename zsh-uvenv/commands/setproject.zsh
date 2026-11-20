_uvenv_setproject() {
    if [[ $1 == (-h|--help) ]]; then
        cat <<'EOF'
Usage: uvenv setproject [project_path] [env_name]

Bind a project directory to a virtual environment, so that `workon` cds into
it. Defaults: the current directory and the active virtual environment.
EOF
        return 0
    fi

    local project="${1:-$PWD}" env_path
    _uvenv_resolve "$2" || return 1
    env_path="$REPLY"

    if [[ ! -d $project ]]; then
        _uvenv_err "Project directory not found: $project"
        return 1
    fi

    project="${project:A}"
    print -r -- "$project" > "$env_path/.project" || return 1
    echo "📁 Project of '${env_path:t}' set to $project"
}
