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
