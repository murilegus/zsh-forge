# Entry point for sourcing the plugin manually
0="${ZERO:-${${0:#$ZSH_ARGZERO}:-${(%):-%N}}}"
source "${0:A:h}/zsh-uvenv.plugin.zsh"
