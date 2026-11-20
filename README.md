# zsh-forge

Collection of Zsh custom plugins

## List of Zsh plugins

- [uvenv](zsh-uvenv) - A `workon`-style virtual environment manager on top of the Python package/project management tool [astral-sh/uv](https://github.com/astral-sh/uv)

## Installation

Download the repository with Git clone or as a ZIP file: [zsh-forge](https://github.com/murilegus/zsh-forge)

### Method 1: Source it

1. **Download repository**
2. **Add to shell config**

    ```zsh
    source /path/to/zsh-forge/zsh-*/zsh-*.zsh
    # Example:
    # source ~/Downloads/zsh-forge/zsh-uvenv/zsh-uvenv.zsh
    ```

### Method 2: Add to Zsh custom plugins folder

1. **Download repository**
2. **Run the installer** to copy plugins into `$ZSH_CUSTOM/plugins`

    ```zsh
    sh ./install.sh              # every plugin
    sh ./install.sh zsh-uvenv    # only the plugins you name
    ```

3. **Add the plugin name** (e.g. `zsh-uvenv`) to `plugins=(...)` in `.zshrc`.

## Usage

Read the `README.md` file in any plugin to know how to use it.
