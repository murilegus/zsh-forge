_uvenv_deactivate() {
    if [[ -n "$VIRTUAL_ENV" ]]; then
        deactivate
        echo "👋 Deactivated virtual environment"
    else
        echo "ℹ️  No virtual environment active"
    fi
}
