#!/usr/bin/env bash
# Prompt Claude to re-register on resume
[ -z "$TMUX" ] && exit 0

echo "Run /tc with a suggested description based on what the user is asking."
