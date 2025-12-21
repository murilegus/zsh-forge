# zsh-uvenv

## Installation

Download repository using Git clone/Download ZIP file [zsh-forge](https://github.com/trungit2001/zsh-forge)

### Method 1: Source when usage

1. **Download repository**
2. **Add to shell config**

    ```bash
    source /path/to/zsh-forge/zsh-uvenv/zsh-uvenv.zsh
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
