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

`.edi/` is a resource bundle containing generic prompt fragments and skills.
Bundles do not automatically append prompts. `~/.edi/system_prompt.md` is the global entrypoint;
it explicitly includes the fragments you want. Stow skips `.edi`, and `make link` does not copy instructions.
Use an Edi version supporting resource roots, root-selected includes, and optional includes.
Add this ordered list to `~/.edi/config.yaml`:

```yaml
resource_bundles:
  - ~/src/github.com/inoc603/dotfiles/.edi
  - ~/src/github.com/inoc603/dotfiles/.edi/airwallex
```

Adjust the repository path for your checkout. Configure the second root only if it exists;
explicitly configured missing roots are errors. Work-specific content belongs in ignored `.edi/airwallex/`.
Work files are not distributed with this repository. Root paths may be absolute, start with `~/`,
or be relative to `~/.edi`.

For the configured roots above, put these includes in `~/.edi/system_prompt.md`:

```xml
<include root="~/src/github.com/inoc603/dotfiles/.edi" file="prompts/common.md"/>
<include root="~/src/github.com/inoc603/dotfiles/.edi/airwallex" file="prompts/work.md" optional="true"/>
```

Root selectors must match configured resource bundles. If the work root is unavailable, omit its configuration and include.
`optional="true" skips a missing fragment, not root validation. `common.md` includes generic fragments;
the ignored `work.md` includes only work fragments. Nested includes resolve relative to their containing file
and must stay within their containing directory. No profile or repository conditions select these prompts.

Edit fragments and skills in their roots; no installation copy is needed. Later bundles override earlier skills
with the same name, and legacy global/project skills can override bundle skills.
When migrating, upgrade Edi first. Back up the old global system prompt, then replace it with the explicit entrypoint.
Back up and remove copied legacy skills in `~/.edi` to avoid stale overrides. Keep configuration and runtime data.
Verify the effective prompt with `edi config prompt --stats`.
