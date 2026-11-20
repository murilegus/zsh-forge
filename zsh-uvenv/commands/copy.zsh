_uvenv_copy() {
    if [[ $1 == (-h|--help) ]] || (( $# != 2 )); then
        cat <<'EOF'
Usage: uvenv copy <source_env> <target_env>

Create <target_env> with the same Python version and packages as <source_env>.
EOF
        [[ $1 == (-h|--help) ]]
        return
    fi

    local src_path dst_name="$2" dst_path pyver packages project ret
    local -a cmd

    _uvenv_require_uv || return 1
    _uvenv_resolve "$1" || return 1
    src_path="$REPLY"

    if ! _uvenv_valid_name "$dst_name"; then
        _uvenv_err "Invalid virtual environment name '$dst_name'"
        return 1
    fi

    dst_path="$UVENV_HOME/$dst_name"
    if [[ -e $dst_path ]]; then
        _uvenv_err "Virtual environment '$dst_name' already exists at $dst_path"
        return 1
    fi

    # A venv cannot be relocated by copying files, so rebuild it instead
    packages="$(uv pip freeze --python "$src_path/bin/python")" || {
        _uvenv_err "Failed to list packages of '${src_path:t}'"
        return 1
    }

    cmd=(uv venv)
    pyver="$(_uvenv_python_version_of "$src_path")" && cmd+=(--python "$pyver")
    cmd+=("$dst_path")

    "$cmd[@]" || {
        _uvenv_err "Failed to create virtual environment '$dst_name'"
        return 1
    }

    if [[ -n $packages ]]; then
        print -r -- "$packages" | uv pip install --python "$dst_path/bin/python" -r -
        ret=$?
        if (( ret != 0 )); then
            _uvenv_err "'$dst_name' was created, but copying packages failed"
            return $ret
        fi
    fi

    if project="$(_uvenv_project_of "$src_path")"; then
        print -r -- "$project" > "$dst_path/.project"
    fi

    echo "✅ Copied: ${src_path:t} -> $dst_name"
}
