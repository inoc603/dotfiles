# Lazy load pyenv
pyenv() {
  unset -f pyenv
  if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi
  pyenv
}

# Lazy load the fuck
fuck() {
  unset -f fuck
  if which thefuck > /dev/null; then eval "$(thefuck --alias)"; fi
  fuck
}

# Prefer locally installed node binaries
export PATH=node_modules/.bin:$PATH
