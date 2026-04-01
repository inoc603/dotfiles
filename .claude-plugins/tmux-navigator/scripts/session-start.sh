#!/usr/bin/env bash
# Register tmux pane as a Claude session
[ -z "$TMUX" ] && exit 0

tmux set-option -p @claude 1
