# Short descriptions for commands
# (map only command -> short text, not file paths)
_uvenv_help_shortdesc() {
    case $1 in
        activate)       echo "Activate a virtual env and cd into its project" ;;
        cd)             echo "cd into a virtual env directory" ;;
        cdproject)      echo "cd into the project directory of a virtual env" ;;
        cdsitepackages) echo "cd into the site-packages of a virtual env" ;;
        copy)           echo "Duplicate a virtual env" ;;
        create)         echo "Create a new uv-managed Python virtual env" ;;
        deactivate)     echo "Deactivate the active virtual env" ;;
        help)           echo "Show this message" ;;
        install)        echo "Install a Python version with uv" ;;
        list)           echo "List virtual envs" ;;
        lssitepackages) echo "List the site-packages of a virtual env" ;;
        remove)         echo "Remove virtual envs" ;;
        setproject)     echo "Bind a project directory to a virtual env" ;;
        show)           echo "Show details of a virtual env" ;;
        version)        echo "Show uvenv version" ;;
        versions)       echo "List Python versions installed by uv" ;;
        wipe)           echo "Uninstall every package from a virtual env" ;;
    esac
}


_uvenv_help() {
    # `uvenv help <command>` -> help of that command
    if (( $# )) && [[ $1 != help ]]; then
        uvenv "$1" --help
        return
    fi

    cat <<'EOF'
A uv Python virtual environment manager, in the style of virtualenvwrapper

Usage: uvenv <command> [options]

Commands:
EOF

    # Sort commands alphabetically (pretty output)
    local cmd
    for cmd in ${(ok)UVENV_COMMANDS}; do
        printf "    %-15s %s\n" "$cmd" "$(_uvenv_help_shortdesc "$cmd")"
    done

    cat <<EOF

Shortcuts:
    workon [env_name]      uvenv activate     workoff          uvenv deactivate
    mkvirtualenv           uvenv create       rmvirtualenv     uvenv remove
    lsvirtualenv           uvenv list         showvirtualenv   uvenv show
    cpvirtualenv           uvenv copy         cdvirtualenv     uvenv cd
    setvirtualenvproject   uvenv setproject   wipeenv          uvenv wipe
    cdproject, cdsitepackages, lssitepackages

Virtual envs are stored in: $UVENV_HOME (override with \$UVENV_HOME)
Run 'uvenv <command> --help' for details on a command.
EOF
}
