# Short descriptions for commands
# (map only command -> short text, not file paths)
uvenv_help_shortdesc() {
    local cmd=$1
    case $cmd in
        activate)   echo "Activate virtual env" ;;
        create)     echo "Create new uv-managed Python virtual env" ;;
        deactivate) echo "Deactivate virtual env" ;;
        help)       echo "Show this message" ;;
        lsvenv)     echo "Display list of virtual envs" ;;
        remove)     echo "Remove existed Python virtual env" ;;
        version)    echo "Show Python version" ;;
        *)          echo "" ;;
    esac
}


_uvenv_help() {
    # General help (auto-generated)
    cat <<'EOF'
An uv Python virtual environment manager

Usage: uvenv [options] <command>

Commands:
EOF

    # Sort commands alphabetically (pretty output)
    local cmd
    for cmd in ${(on)${(k)UVENV_COMMANDS}}; do
        printf "    %-12s %s\n" "$cmd" "$(uvenv_help_shortdesc "$cmd")"
    done

    cat <<'EOF'

Use via:
    workon <env_name>   Activate virtual env
    workoff             Deactivate virtual env
EOF
}
