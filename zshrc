# zmodload zsh/zprof

export ZIM_HOME=${ZDOTDIR:-${HOME}}/.zim

export ZSH_ROOT=${HOME}/.zsh

PURE_GIT_PULL=0

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

# zprof
