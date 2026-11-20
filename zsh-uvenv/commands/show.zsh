_uvenv_show() {
    if [[ $1 == (-h|--help) ]]; then
        cat <<'EOF'
Usage: uvenv show [env_name]

Show details of a virtual environment (default: the active one).
EOF
        return 0
    fi

    local env_path project pyver active=no
    _uvenv_resolve "$1" || return 1
    env_path="$REPLY"

    project="$(_uvenv_project_of "$env_path")" || project="-"
    pyver="$(_uvenv_python_version_of "$env_path")" || pyver="?"
    [[ -n $VIRTUAL_ENV && ${VIRTUAL_ENV:A} == ${env_path:A} ]] && active=yes

    printf '%-9s %s\n' \
        "Name:"    "${env_path:t}" \
        "Path:"    "$env_path" \
        "Python:"  "$pyver" \
        "Project:" "$project" \
        "Active:"  "$active"
}
