---
name: tc
description: Register this Claude session with a description for tmux navigation
disable-model-invocation: false
argument-hint: "<description>"
allowed-tools:
  - Bash(claude-register *)
---

Register the current Claude Code session for tmux fuzzy search (Ctrl+a Ctrl+g).

Run:
```bash
claude-register "$ARGUMENTS"
```

If no arguments were provided, suggest a short description based on what we've been working on and ask the user to confirm.
