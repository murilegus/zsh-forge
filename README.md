# zsh-forge

Collection of Zsh custom plugins

## List of Zsh plugins

- [uvenv](https://github.com/trungit2001/zsh-forge/zsh-uvenv) - A wrapper on the Python package/project management tool [astral-sh/uv](https://github.com/astral-sh/uv)

## Installation

Download repository using Git clone/Download ZIP file [zsh-forge](https://github.com/trungit2001/zsh-forge)

### Method 1: Source when usage

1. **Download repository**
2. **Add to shell config**

    ```bash
    source /path/to/zsh-forge/zsh-*/zsh-*.zsh
    # Example:
    # source ~/Downloads/zsh-forge/zsh-uvenv/zsh-uvenv.zsh
    ```

### Method 2: Add to Zsh custom plugins folder

1. **Download repository**
2. **Execute command to copy specified plugin you want**

    - By default, copy plugin into `$ZSH_CUSTOM/plugins`

    ```bash
    chmod a+x ./install && ./install
    ```

    - Add plugin name to `.zshrc` plugins to use it.

## Usage

Read the `README.md` file in any plugin to know how to use it.
