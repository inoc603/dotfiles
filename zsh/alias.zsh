###############################################################################
# Common alias
###############################################################################

# Short clear
alias c='clear'

# Fast navigation
alias cd..='cd ../'
alias ..='cd ../'
alias ...='cd ../../'

# List and find
alias la='ls -a'
alias ll='ls -FGlAhp'
alias lf='la | grep'
alias llf='ll | grep'
alias pf='ps -e | grep'

# Pretty print path
alias path='echo -e ${PATH//:/\\n}'

alias todo='nvim ~/.todo.md'

# Edit zsh config
alias zshconfig="vim ~/.zshrc"

# Edit ssh config
alias sshconfig="vim ~/.ssh/config"

# Refresh zsh settings
alias ref="[ -e ~/.zshenv ] && source ~/.zshenv; source ~/.zshrc"

# Use taobao's npm registry
alias tnpm='npm --registry=https://registry.npm.taobao.org/'

# Use pypi.douban.com for pip install
dpi () {
	pip install $@ -i http://pypi.douban.com/simple/ --trusted-host pypi.douban.com
}

# Use shadowsocks as socks5 proxy
alias ss='ALL_PROXY=socks5://localhost:1080'

# Use priovxy as http proxy
alias pp='HTTP_PROXY=http://localhost:8118 HTTPS_PROXY=http://localhost:8118'

if [ `uname` = 'Darwin' ]; then
	# Open directory/file in Finder
	alias f='open -a Finder'
fi

alias ta='tmux a || (cd ~ && tn)'

alias t='tmux a'

tn() {
	local session=${1:-$(basename $(dirname $(pwd)))/$(basename $(pwd))}
	if [ -z "$TMUX" ]
	then
		tmux a -t $session || tmux new -s $session
	else
		tmux new -s $session -d
	fi
}
