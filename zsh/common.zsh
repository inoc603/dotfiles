source_safe() {
	[[ -s "$1" ]] && source $1
}

has_bin() {
	which $1 > /dev/null
}


add_path() {
	export PATH=$1:$PATH
}

bindkey "^P" up-line-or-search
bindkey "^[[3~" delete-char

tf() {
	local next=$(find ~/src -maxdepth 3 -mindepth 3 -type d | grep -v '.git' | fzf)
	local session=$(basename $next)
	if [ -z "$TMUX" ]
	then
		tmux a -t $session || tmux new -s $session -c $next
	else
		tmux switch -t $session || (tmux new -s $session -d -c $next && tmux switch -t $session)
	fi
}
