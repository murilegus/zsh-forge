# Shared helpers for uvenv


# Root directory holding every virtual environment (like WORKON_HOME in
# virtualenvwrapper). Override it by exporting UVENV_HOME before loading.
: ${UVENV_HOME:=$HOME/.local/share/uvenv}
UVENV_HOME="${UVENV_HOME:A}"


_uvenv_err() {
    print -u2 -r -- "❌ $*"
}


# uv is required by every command that creates or changes an environment
_uvenv_require_uv() {
    (( $+commands[uv] )) && return 0

    _uvenv_err "'uv' command not found. Please install uv first to use uvenv!"
    print -u2 -- "hint: curl -LsSf https://astral.sh/uv/install.sh | sh"
    print -u2 -- "  or: wget -qO- https://astral.sh/uv/install.sh | sh"
    return 1
}


# A name must be a single path component, so it can never escape UVENV_HOME
_uvenv_valid_name() {
    [[ -n $1 && $1 != .* && $1 != -* && $1 != */* ]]
}


_uvenv_is_env() {
    [[ -f $1/pyvenv.cfg && -f $1/bin/activate ]]
}


# Print the name of every environment, one per line
_uvenv_env_names() {
    local dir
    for dir in "$UVENV_HOME"/*(N/n); do
        _uvenv_is_env "$dir" && print -r -- "${dir:t}"
    done
    return 0
}


# Print the name of the active environment if it is managed by uvenv
_uvenv_active_name() {
    [[ -n $VIRTUAL_ENV && ${VIRTUAL_ENV:A:h} == $UVENV_HOME ]] || return 1
    print -r -- "${VIRTUAL_ENV:t}"
}


# Resolve [env_name] to a path stored in $REPLY.
# Without a name, fall back to the active environment.
_uvenv_resolve() {
    local name=$1

    if [[ -z $name ]]; then
        if [[ -z $VIRTUAL_ENV ]]; then
            _uvenv_err "No virtual environment active. Pass <env_name> or run 'workon <env_name>' first"
            return 1
        fi
        REPLY=$VIRTUAL_ENV
        return 0
    fi

    if ! _uvenv_valid_name "$name"; then
        _uvenv_err "Invalid virtual environment name '$name'"
        return 1
    fi

    if ! _uvenv_is_env "$UVENV_HOME/$name"; then
        _uvenv_err "Virtual environment '$name' not found"
        return 1
    fi

    REPLY="$UVENV_HOME/$name"
}


# Print the project directory bound to an environment path.
# It is stored in `.project`, the same file virtualenvwrapper uses.
_uvenv_project_of() {
    local env_path=$1 line

    [[ -f $env_path/.project ]] || return 1
    IFS= read -r line < "$env_path/.project"
    [[ -n $line ]] || return 1
    print -r -- "$line"
}


# Print the Python version of an environment path
_uvenv_python_version_of() {
    local line
    [[ -f $1/pyvenv.cfg ]] || return 1

    while IFS= read -r line; do
        # uv writes `version_info = 3.12.1`, python -m venv writes `version = 3.12.1`
        if [[ $line == version_info[[:space:]=]* || $line == version[[:space:]=]* ]]; then
            print -r -- "${${line#*=}//[[:space:]]/}"
            return 0
        fi
    done < "$1/pyvenv.cfg"

    return 1
}


# Print the site-packages directory of an environment path
_uvenv_site_packages_of() {
    local -a dirs
    dirs=("$1"/lib/python*/site-packages(N/))
    (( $#dirs )) || return 1
    print -r -- "$dirs[1]"
}


# Ask a yes/no question once. Fails when there is no terminal to answer.
_uvenv_confirm() {
    if [[ ! -t 0 ]]; then
        _uvenv_err "Cannot ask for confirmation without a terminal, use --force"
        return 1
    fi

    read -q "?$1 [y/N] "
    local ret=$?
    print
    return $ret
}
