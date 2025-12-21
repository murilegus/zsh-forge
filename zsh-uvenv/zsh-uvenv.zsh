# Auto-detect plugin path
0=${(%):-%N}
ZSH_PLUGIN_PATH="${0:A:h}"


# Source custom paths
source "${ZSH_PLUGIN_PATH}/zsh-uvenv.plugin.zsh"
