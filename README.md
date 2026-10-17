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

`.edi/` is a resource bundle containing generic prompts and skills. Edi loads it directly;
Stow skips it, and `make link` does not copy instructions into `~/.edi`.
Use an Edi version with `resource_bundles` support. Add this ordered list to `~/.edi/config.yaml`:

```yaml
resource_bundles:
  - ~/src/github.com/inoc603/dotfiles/.edi
  - ~/src/github.com/inoc603/dotfiles/.edi/airwallex
```

Adjust the repository path for your checkout. Include the second root only if it exists;
explicitly configured missing roots are errors. Work-specific content belongs in ignored
`.edi/airwallex/`, with its own `system_prompt.md`, `prompts/`, and `skills/`.
Its system prompt includes only work prompts, relative to that root; the first bundle supplies generic prompts.
Work files are not distributed with this repository. Paths may be absolute, start with `~/`,
or be relative to `~/.edi`. Bundle includes must remain inside their containing directory.

Edit instructions in these roots; no installation copy is needed. Later bundles override earlier skills
with the same name, and legacy global/project skills can override bundle skills.
When migrating from the copying installer, back up and remove the old installed system prompt and
skills in `~/.edi` to avoid duplicate prompts or stale skill overrides. Keep configuration and runtime data.
Verify the effective prompt with `edi config prompt --stats`.
