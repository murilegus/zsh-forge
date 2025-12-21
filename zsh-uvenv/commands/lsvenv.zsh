_uvenv_lsvenv() {
    find "$UVENV_HOME" -mindepth 1 -maxdepth 1 -type d -print0 \
        | sort -z -V \
        | while IFS= read -r -d '' dir; do
            printf '%s\n' "$(basename "$dir")"
          done
}
