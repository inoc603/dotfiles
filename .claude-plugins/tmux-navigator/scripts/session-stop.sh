#!/usr/bin/env bash
# Unmark tmux pane as a Claude session
[ -z "$TMUX" ] && exit 0

tmux set-option -pu @claude
