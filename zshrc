# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh
export DISABLE_AUTO_TITLE='true'
export DISABLE_UPDATE_PROMPT=true
export ZSH_THEME="ys"
export ENABLE_CORRECTION="false"


# zsh plugins
plugins=(git extract brew docker osx npm zsh-autosuggestions autojump)

# load nvm zsh
export NVM_LAZY_LOAD=true
plugins+=(zsh-nvm)

source $ZSH/oh-my-zsh.sh

# ys theme without user and hostname
# INDI_COLOR can be set in zshenv to change the color of the indicator, which
# is useful for distinguish different environments
PROMPT="%{$terminfo[bold]$fg[blue]%}#%{$reset_color%} \
%{$terminfo[bold]$fg[yellow]%}%~%{$reset_color%}\
${hg_info}\
${git_info}\
 \
%{$fg[white]%}[%*] $exit_code
%{$terminfo[bold]$fg[${INDI_COLOR:-red}]%}$ %{$reset_color%}"


# Custom
source ~/.zsh/deps.sh
source ~/.zsh/common.sh
source ~/.zsh/docker.sh
source ~/.zsh/gfw.sh

if [ `uname` = 'Darwin' ]; then
	source ~/.zsh/mac.sh
fi

# edit zsh config
alias zshconfig="vim ~/.zshrc"

# edit ssh config
alias sshconfig="vim ~/.ssh/config"

# refresh zsh settings
alias ref="[ -e ~/.zshenv ] && source ~/.zshenv; source ~/.zshrc"
