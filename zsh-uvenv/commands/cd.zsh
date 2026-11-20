# Navigation commands. All of them take an optional [env_name] and default to
# the active virtual environment.

_uvenv_cd() {
    _uvenv_resolve "$1" || return 1
    cd "$REPLY"
}


_uvenv_cdproject() {
    local project
    _uvenv_resolve "$1" || return 1

    if ! project="$(_uvenv_project_of "$REPLY")"; then
        _uvenv_err "No project set for '${REPLY:t}', use 'uvenv setproject' to set one"
        return 1
    fi

    if [[ ! -d $project ]]; then
        _uvenv_err "Project directory not found: $project"
        return 1
    fi

    cd "$project"
}


_uvenv_cdsitepackages() {
    local site
    _uvenv_resolve "$1" || return 1

    if ! site="$(_uvenv_site_packages_of "$REPLY")"; then
        _uvenv_err "site-packages not found in '${REPLY:t}'"
        return 1
    fi

    cd "$site"
}


_uvenv_lssitepackages() {
    local site
    _uvenv_resolve "$1" || return 1

    if ! site="$(_uvenv_site_packages_of "$REPLY")"; then
        _uvenv_err "site-packages not found in '${REPLY:t}'"
        return 1
    fi

    command ls "$site"
}
