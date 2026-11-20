# uvenv - manage uv Python virtual environments the virtualenvwrapper/pyenv way
# Usage: uvenv <command> [options]


# Auto-detect plugin path
0="${ZERO:-${${0:#$ZSH_ARGZERO}:-${(%):-%N}}}"
typeset -g UVENV_PLUGIN_PATH="${0:A:h}"


# Source shared helpers
source "${UVENV_PLUGIN_PATH}/utils/core.zsh"


# Command registry: <command> "<file>:<function>"
typeset -gA UVENV_COMMANDS
UVENV_COMMANDS=(
    activate        "commands/activate.zsh:_uvenv_activate"
    cd              "commands/cd.zsh:_uvenv_cd"
    cdproject       "commands/cd.zsh:_uvenv_cdproject"
    cdsitepackages  "commands/cd.zsh:_uvenv_cdsitepackages"
    copy            "commands/copy.zsh:_uvenv_copy"
    create          "commands/create.zsh:_uvenv_create"
    deactivate      "commands/deactivate.zsh:_uvenv_deactivate"
    help            "commands/help.zsh:_uvenv_help"
    install         "commands/python.zsh:_uvenv_install"
    list            "commands/list.zsh:_uvenv_list"
    lssitepackages  "commands/cd.zsh:_uvenv_lssitepackages"
    remove          "commands/remove.zsh:_uvenv_remove"
    setproject      "commands/setproject.zsh:_uvenv_setproject"
    show            "commands/show.zsh:_uvenv_show"
    version         "commands/version.zsh:_uvenv_version"
    versions        "commands/python.zsh:_uvenv_versions"
    wipe            "commands/wipe.zsh:_uvenv_wipe"
)


# Command aliases: <alias> <command>
typeset -gA UVENV_ALIASES
UVENV_ALIASES=(
    workon      activate
    workoff     deactivate
    mk          create
    new         create
    ls          list
    lsvenv      list
    rm          remove
    delete      remove
    cp          copy
    cdvenv      cd
    -h          help
    --help      help
    -V          version
    --version   version
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

    cmd="${UVENV_ALIASES[$cmd]:-$cmd}"
    entry="${UVENV_COMMANDS[$cmd]}"

    if [[ -z "$entry" ]]; then
        _uvenv_err "Unknown command '$cmd'"
        print -u2 -- "Run 'uvenv help' to see available commands"
        return 1
    fi

    relpath="${entry%%:*}"
    func="${entry##*:}"

    # Lazy-load the command on first use
    if (( ! $+functions[$func] )); then
        source "$UVENV_PLUGIN_PATH/$relpath"
    fi

    if (( ! $+functions[$func] )); then
        _uvenv_err "Function '$func' not found"
        return 1
    fi

    "$func" "$@"
}


# virtualenvwrapper-compatible shortcuts
workon()               { uvenv activate "$@" }
workoff()              { uvenv deactivate "$@" }
mkvirtualenv()         { uvenv create "$@" }
rmvirtualenv()         { uvenv remove "$@" }
lsvirtualenv()         { uvenv list "$@" }
showvirtualenv()       { uvenv show "$@" }
cpvirtualenv()         { uvenv copy "$@" }
cdvirtualenv()         { uvenv cd "$@" }
cdproject()            { uvenv cdproject "$@" }
cdsitepackages()       { uvenv cdsitepackages "$@" }
lssitepackages()       { uvenv lssitepackages "$@" }
setvirtualenvproject() { uvenv setproject "$@" }
wipeenv()              { uvenv wipe "$@" }


# Completion: command names for `uvenv`, environment names everywhere else
_uvenv_completion() {
    local -a envs
    envs=(${(f)"$(_uvenv_env_names)"})

    if [[ $service == uvenv ]]; then
        if (( CURRENT == 2 )); then
            compadd -- ${(ok)UVENV_COMMANDS}
            return
        fi

        case ${UVENV_ALIASES[$words[2]]:-$words[2]} in
            create|setproject) _files -/ ; return ;;
            deactivate|help|install|list|version|versions) return ;;
        esac
    fi

    compadd -a envs
}

if (( $+functions[compdef] )); then
    compdef _uvenv_completion uvenv workon rmvirtualenv showvirtualenv \
        cpvirtualenv cdvirtualenv cdproject cdsitepackages lssitepackages wipeenv
fi
