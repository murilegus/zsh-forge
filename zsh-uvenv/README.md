# zsh-uvenv

A Zsh wrapper around [astral-sh/uv](https://github.com/astral-sh/uv) that manages
Python virtual environments in one central place, with the `workon` workflow of
[virtualenvwrapper](https://virtualenvwrapper.readthedocs.io) and
[pyenv-virtualenv](https://github.com/pyenv/pyenv-virtualenv).

```zsh
uvenv create myapp -p 3.12 -a ~/code/myapp   # create, activate, cd into the project
workon myapp                                 # later: activate and cd again
workoff                                      # deactivate
```

## Requirements

- Zsh
- [uv](https://docs.astral.sh/uv/getting-started/installation/)

## Installation

Download the repository with Git clone or as a ZIP file: [zsh-forge](https://github.com/murilegus/zsh-forge)

### Method 1: Source it

Add this line to your `~/.zshrc`:

```zsh
source /path/to/zsh-forge/zsh-uvenv/zsh-uvenv.zsh
```

### Method 2: Oh My Zsh custom plugin

1. Copy the plugin into `$ZSH_CUSTOM/plugins` (default `~/.oh-my-zsh/custom/plugins`):

    ```zsh
    sh /path/to/zsh-forge/zsh-uvenv/install.sh
    ```

2. Add `zsh-uvenv` to the `plugins=(...)` list in `~/.zshrc` and reload the shell.

## Commands

Every command is available as `uvenv <command>`. The virtualenvwrapper names
work too, so existing muscle memory keeps working.

| uvenv | virtualenvwrapper | pyenv | What it does |
| --- | --- | --- | --- |
| `uvenv create <env>` | `mkvirtualenv` | `pyenv virtualenv` | Create a virtual env with `uv venv` and activate it |
| `uvenv activate [env]` | `workon` | `pyenv activate` | Activate a virtual env and cd into its project. Without a name, list the envs |
| `uvenv deactivate` | `deactivate` (also `workoff`) | `pyenv deactivate` | Deactivate the active virtual env |
| `uvenv list` | `lsvirtualenv` | `pyenv virtualenvs` | List virtual envs, the active one is marked with `*` |
| `uvenv show [env]` | `showvirtualenv` | | Show name, path, Python version and project |
| `uvenv remove <env>...` | `rmvirtualenv` | `pyenv virtualenv-delete` | Remove virtual envs |
| `uvenv copy <src> <dst>` | `cpvirtualenv` | | Duplicate a virtual env |
| `uvenv cd [env]` | `cdvirtualenv` | | cd into the virtual env directory |
| `uvenv cdproject [env]` | `cdproject` | | cd into the project directory |
| `uvenv cdsitepackages [env]` | `cdsitepackages` | | cd into `site-packages` |
| `uvenv lssitepackages [env]` | `lssitepackages` | | List `site-packages` |
| `uvenv setproject [path] [env]` | `setvirtualenvproject` | | Bind a project directory to a virtual env |
| `uvenv wipe [env]` | `wipeenv` | | Uninstall every package from a virtual env |
| `uvenv versions` | | `pyenv versions` | List the Python versions uv has installed |
| `uvenv install <version>` | | `pyenv install` | Install a Python version with uv |
| `uvenv help [command]` | `virtualenvwrapper` | `pyenv help` | Show help |
| `uvenv version` | | | Show the uvenv version |

Short aliases: `uvenv mk`, `uvenv ls`, `uvenv rm`, `uvenv cp`, `uvenv workon`, `uvenv workoff`.

Commands taking `[env]` default to the active virtual env. Tab completion of
commands and env names is registered when `compinit` is loaded.

### create

```text
uvenv create [options] <env_name> [-- <uv venv options>]

-p, --python <version>      Python version or interpreter (e.g. 3.11)
-a, --project <path>        Project directory to cd into on `workon`
-r, --requirements <file>   Install packages from a requirements file
-i, --install <package>     Install a package (can be repeated)
-n, --no-activate           Do not activate the new environment
```

Everything after `--` is passed to `uv venv`, for example `uvenv create myapp -- --seed`.

### activate / workon

```text
workon [-n|--no-cd] [env_name]
```

`-n` activates without changing directory.

### list

```text
uvenv list [-b|--brief] [-l|--long]
```

`-b` prints bare names (useful in scripts), `-l` adds the Python version and project.

### remove

```text
uvenv remove [-f|--force] <env_name>...
```

Asks for confirmation once for the whole command, `-f` skips the question.
The active virtual env cannot be removed, run `workoff` first.

## Configuration

| Variable | Default | Description |
| --- | --- | --- |
| `UVENV_HOME` | `~/.local/share/uvenv` | Where virtual envs are stored. Export it before the plugin is loaded |

The project directory of an env is stored in `<env>/.project`, the same file
virtualenvwrapper uses.
