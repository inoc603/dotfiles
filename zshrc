# Change default zim location
export ZIM_HOME=${ZDOTDIR:-${HOME}}/.zim

export ZSH_ROOT=${HOME}/.zsh

# Some common functions for other scripts
source ${ZSH_ROOT}/common.zsh

# Start zim
source_safe ${ZIM_HOME}/init.zsh

source ${ZSH_ROOT}/alias.zsh
source ${ZSH_ROOT}/network.zsh
source ${ZSH_ROOT}/git.zsh
source ${ZSH_ROOT}/docker.zsh

# Load dependecies
source ${ZSH_ROOT}/deps.zsh

