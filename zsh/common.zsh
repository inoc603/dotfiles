source_safe() {
	[[ -s "$1" ]] && source $1
}

has_bin() {
	which $1 > /dev/null
}
