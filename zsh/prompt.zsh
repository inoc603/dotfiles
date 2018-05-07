# For my own and others sanity
# git:
# %b => current branch
# %a => current action (rebase/merge)
# prompt:
# %F => color dict
# %f => reset color
# %~ => current path
# %* => time
# %n => username
# %m => shortname host
# %(?..) => prompt conditional - %(condition.true.false)
# terminal codes:
# \e7   => save cursor position
# \e[2A => move cursor 2 lines up
# \e[1G => go to position 1 in terminal
# \e8   => restore cursor position
# \e[K  => clears everything after the cursor on the current line
# \e[2K => clear everything on the current line

prompt_inoc_render() {
	# Preprompt array
	local -a preprompt

	# Path
	preprompt+=('%F{blue}%~%f')

	preprompt+=('$prompt_inoc_branch')

	# Start time of the command
	preprompt+=('%F{white}%*%f')

	local cleaned_ps1=$PROMPT
	local -H MATCH
	if [[ $PROMPT = *$prompt_newline* ]]; then
		# When the prompt contains newlines, we keep everything before the first
		# and after the last newline, leaving us with everything except the
		# preprompt. This is needed because some software prefixes the prompt
		# (e.g. virtualenv).
		cleaned_ps1=${PROMPT%%${prompt_newline}*}${PROMPT##*${prompt_newline}}
	fi

	# Construct the new prompt with a clean preprompt.
	local -ah ps1
	ps1=(
		$prompt_newline
		${(j. .)preprompt}
		$prompt_newline           # Separate preprompt and prompt.
		$cleaned_ps1
	)
	PROMPT="${(j..)ps1}"
}

prompt_inoc_async_vcs_branch() {
	setopt localoptions noshwordsplit

	local dir=$1 untracked_dirty=$2

	# use cd -q to avoid side effects of changing directory, e.g. chpwd hooks
	builtin cd -q $dir 2>/dev/null

	# configure vcs_info inside async task, this frees up vcs_info
	# to be used or configured as the user pleases.
	zstyle ':vcs_info:*' enable git
	zstyle ':vcs_info:*' use-simple true
	# only export two msg variables from vcs_info
	zstyle ':vcs_info:*' max-exports 2
	# export branch (%b)
	zstyle ':vcs_info:git*' formats '%b'
	zstyle ':vcs_info:git*' actionformats '%b|%a'

	vcs_info

	branch=$vcs_info_msg_0_

	if [[ $untracked_dirty = 0 ]]; then
		command git diff --no-ext-diff --quiet --exit-code
	else
		test -z "$(command git status --porcelain --ignore-submodules -unormal)"
	fi

	local git_color='green'

	async_job prompt_inoc prompt_inoc_async_vcs_branch

	print -P '%F{$git_color}$vcs_info_msg_0_%f'


	# print -r - $vcs_info_msg_0_
}

prompt_inoc_async_callback() {
	setopt localoptions noshwordsplit
	local job=$1 code=$2 output=$3 exec_time=$4

	print $job

	case $job in
		prompt_inoc_async_vcs_branch)
			typeset -g prompt_inoc_branch $output
			print $output
			zle reset-prompt
			;;
	esac
}

prompt_inoc_precmd() {
	prompt_inoc_check_cmd_exec_time
	prompt_inoc_render
}

# Print the execution time of the last command if it exceeds the threshold
prompt_inoc_check_cmd_exec_time() {
	integer elapsed
	(( elapsed = EPOCHSECONDS - ${prompt_inoc_cmd_start_time:-$EPOCHSECONDS} ))
	typeset -g prompt_inoc_cmd_exec_time=
	(( elapsed > ${INOC_CMD_EXEC_TIME_THRESHOLD:-10} )) && {
		local human=""
		local days=$(( elapsed / 60 / 60 / 24 ))
		local hours=$(( elapsed / 60 / 60 % 24 ))
		local minutes=$(( elapsed / 60 % 60 ))
		local seconds=$(( elapsed % 60 ))
		(( days > 0 )) && human+="${days}d "
		(( hours > 0 )) && human+="${hours}h "
		(( minutes > 0 )) && human+="${minutes}m "
		human+="${seconds}s"
		print -P "\n\r The last command took: %F{yellow}$human%f"
	}
	unset prompt_inoc_cmd_start_time
}

prompt_inoc_preexec() {
	typeset -g prompt_inoc_cmd_start_time=$EPOCHSECONDS
}

prompt_inoc_setup() {
	# Prevent percentage showing up if output doesn't end with a newline.
	export PROMPT_EOL_MARK=''

	# disallow python virtualenvs from updating the prompt
	export VIRTUAL_ENV_DISABLE_PROMPT=1

	prompt_opts=(subst percent)

	# borrowed from promptinit, sets the prompt options in case pure was not
	# initialized via promptinit.
	setopt noprompt{bang,cr,percent,subst} "prompt${^prompt_opts[@]}"

	if [[ -z $prompt_newline ]]; then
		# This variable needs to be set, usually set by promptinit.
		typeset -g prompt_newline=$'\n%{\r%}'
	fi

	zmodload zsh/zle

	# Override the accept-line function so it updates the time on current
	# prompt to show when the command starts
	zle -N accept-line reset_prompt_and_accept_line

	autoload -Uz add-zsh-hook
	autoload -Uz vcs_info
	autoload -Uz async && async

	add-zsh-hook precmd prompt_inoc_precmd
	add-zsh-hook preexec prompt_inoc_preexec

	typeset -g inoc_prompt_symbol_color='white'
	export INOC_PROMPT_SYMBOL='$'

	# prompt turns red if the previous command didn't exit with 0
	PROMPT='%(?.%F{$inoc_prompt_symbol_color}.%F{red})${INOC_PROMPT_SYMBOL:-❯}%f '

	async_start_worker "prompt_inoc" -n
	async_register_callback "prompt_inoc" prompt_inoc_async_callback
}

reset_prompt_and_accept_line() {
    zle .reset-prompt
    zle .accept-line
}


prompt_inoc_setup
