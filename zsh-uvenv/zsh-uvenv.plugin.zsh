# uvenv main stub for lazy-loading commands
# Usage: uvenv <command> [options]


# Auto-detect plugin path
0=${(%):-%N}
ZSH_PLUGIN_PATH="${0:A:h}"


# Source custom paths
source "${ZSH_PLUGIN_PATH}/utils/paths.zsh"


# Command registry
typeset -gA UVENV_COMMANDS
UVENV_COMMANDS=(
    activate    "commands/activate.zsh:_uvenv_activate"
    create      "commands/create.zsh:_uvenv_create"
    deactivate  "commands/deactivate.zsh:_uvenv_deactivate"
    help        "commands/help.zsh:_uvenv_help"
    lsvenv      "commands/lsvenv.zsh:_uvenv_lsvenv"
    remove      "commands/remove.zsh:_uvenv_remove"
    version     "commands/version.zsh:_uvenv_version"
)


uvenv() {
    local cmd entry relpath func

    # Empty arguments
    if (( $# == 0 )); then
        cmd="help"
    else
        cmd="$1"
        shift
    fi

    entry="${UVENV_COMMANDS[$cmd]}"

    if [[ -z "$entry" ]]; then
        echo "Error: unknown command '$cmd'"
        uvenv help
        return 1
    fi

    relpath="${entry%%:*}"
    func="${entry##*:}"

    source "$ZSH_PLUGIN_PATH/$relpath"

    if ! whence -w "$func" >/dev/null; then
        echo "Error: function '$func' not found"
        return 1
    fi

    "$func" "$@"
}


workon () {
    uvenv activate "$@"
}


workoff() {
    uvenv deactivate
}
