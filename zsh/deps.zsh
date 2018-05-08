load_autojump() {
	if [ `uname` = 'Darwin' ];
	then
		source_safe /usr/local/etc/profile.d/autojump.sh
	else
		source_safe /usr/share/autojump/autojump.zsh
	fi

}

load_pyenv() {
	if has_bin pyenv
	then
		export PYENV_ROOT="$HOME/.pyenv"
		export PATH="$PYENV_ROOT/bin:$PATH"
		eval "$(pyenv init -)"
		eval "$(pyenv virtualenv-init -)"

		if has_bin thefuck; then eval "$(thefuck --alias)"; fi
	fi
}

load_nvm() {
	if [[ -d "$HOME/.nvm" ]]
	then
		export NVM_DIR="$HOME/.nvm"
		source_safe "$NVM_DIR/nvm.sh" 
		# Prefer locally installed node binaries
		export PATH=node_modules/.bin:$PATH
	fi
}

init_funcs=(load_pyenv load_nvm)
init_total=${#init_funcs[*]}
init_index=1

# Triggers an init function
# $1: the init function index to trigger
# $2: the number of seconds to wait before triggering
run() {
	sleep ${2:0}
	echo $1
}

source ${HOME}/.zsh/async.zsh
async_init
async_start_worker zsh -n

init_callback() {
	if [[ "$1" == "run" ]]
	then
		# Run the current init function
		eval "$init_funcs[$3]"

		# Trigger the next init function. This ensures the init
		# functions runs in serial.
		if (( init_index < init_total ))
		then
			init_index=$(( init_index + 1 ))
			async_job zsh run $init_index 0
		fi
	fi
}
async_register_callback zsh init_callback

# Make sure autojump is always loaded
load_autojump

# Delay init function triggering for 2s to make the shell starts faster.
async_job zsh run 1 2
