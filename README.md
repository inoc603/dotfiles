# dotfiles

My dotfiles

## Install

```
make all
```

## Content

- `.zshrc`: zsh config
- `.agignore`: ignore file for ag search that's used in vim
- `.ansible.cfg`: global ansible config
- `.gitconfig`: global git config
- `.tmux.conf`: tmux config
- `.alacritty.yml`: [alacritty](https://github.com/alacritty/alacritty) config
- `hammerspoon`: [hammerspoon](https://www.hammerspoon.org/) config

For vim configuration, see [this repo](https://github.com/inoc603/my-vim).

## Edi

`.edi/system_prompt.md`, `.edi/prompts/`, and `.edi/skills/` contain generic Edi instructions.
Edit them here, then run `make edi` to install copies into `~/.edi`; `make link` also runs this target.
Back up existing instructions before installing. Edi requires included prompts to stay within `~/.edi`,
so Stow skips `.edi` and the installer uses real files instead of symlinks.

Work-specific instructions live in ignored `.edi/airwallex/`, with `prompts/`, `skills/`, and a
`system_prompt.md` that includes generic and work prompts relative to `~/.edi`.
When present, the installer copies work prompts into `~/.edi/airwallex/`, adds work skills to
`~/.edi/skills/`, and installs the work system prompt. These files are not distributed with this repository.
Local configuration, credentials, sessions, sockets, and other runtime data remain outside this repository.
