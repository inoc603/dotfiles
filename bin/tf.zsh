#!/usr/bin/env zsh

local fzf_bin
local fzf_opts
if [ -z "$TMUX" ]
then
	fzf_bin="fzf"
else
	fzf_bin="fzf-tmux"
	fzf_opts="-p"
fi

local next=$(find ~/src -maxdepth 3 -mindepth 3 -type d | grep -v '/.git' | ${fzf_bin} ${fzf_opts})
if [ -z "$next" ]
then
	return
fi

local session=$(basename $next)
if [ -z "$TMUX" ]
then
	tmux a -t $session || tmux new -s $session -c $next
else
	tmux switch -t $session || (tmux new -s $session -d -c $next && tmux switch -t $session)
fi
