# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH_ROOT=${HOME}/.zsh

# Some common functions for other scripts
source ${ZSH_ROOT}/common.zsh

source ${ZSH_ROOT}/alias.zsh
source ${ZSH_ROOT}/network.zsh
source ${ZSH_ROOT}/git.zsh
source ${ZSH_ROOT}/docker.zsh

# load zinit
source ${ZSH_ROOT}/zinit.zsh

#set history size
export HISTSIZE=10000
#save history after logout
export SAVEHIST=10000
#history file
export HISTFILE=~/.zhistory
#append into history file
setopt INC_APPEND_HISTORY
#save only one command if 2 common are same and consistent
setopt HIST_IGNORE_DUPS
#add timestamp for each entry
setopt EXTENDED_HISTORY

# use the p10k prompt
zinit depth=1 for \
	romkatv/powerlevel10k

# case insensitive path-completion 
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 
# partial completion suggestions
zstyle ':completion:*' list-suffixes zstyle ':completion:*' expand prefix suffix 

# z.lua for fast navigation
export _ZL_CMD=j # change the default command

zinit wait lucid for \
	atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
		zdharma/fast-syntax-highlighting \
	blockf \
		zsh-users/zsh-completions \
	atload"!_zsh_autosuggest_start" \
		zsh-users/zsh-autosuggestions \
		Aloxaf/fzf-tab \
		OMZL::git.zsh \
		OMZP::git \
		OMZP::extract \
	pick"/dev/null" \
	atclone"lua ./z.lua --init zsh once enhanced fzf -> start.zsh" \
	atpull"%atclone" \
	src"start.zsh" \
	atload"alias ji='j -I .'" \
		skywind3000/z.lua

# use pyenv to manage python versions
zinit wait lucid for \
	atclone'PYENV_ROOT="$PWD" ./libexec/pyenv init - > zpyenv.zsh' \
	atinit'export PYENV_ROOT="$PWD"' atpull"%atclone" \
	as'command' pick'bin/pyenv' src"zpyenv.zsh" \
		pyenv/pyenv  \
	atclone'PYENV_ROOT=../pyenv---pyenv ln -s $PWD $PYENV_ROOT/plugins/pyenv-virtualenv && ./bin/pyenv-virtualenv-init - > zpyenv.zsh' \
	pick'/dev/null' src"zpyenv.zsh" \
		pyenv/pyenv-virtualenv

# use n to manage node versions
export N_PREFIX=$HOME/n
add_path $N_PREFIX/bin
export N_NODE_MIRROR=https://npm.taobao.org/mirrors/node

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
source_safe ~/.p10k.zsh

# enable fzf
source_safe ~/.fzf.zsh
