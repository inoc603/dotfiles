# Load pyenv
if which pyenv > /dev/null; then eval "$(pyenv init -)"; fi

# Load the fuck
if which thefuck > /dev/null; then eval "$(thefuck --alias)"; fi

# Load nvm, this assume default install directory of nvm
export NVM_DIR="${HOME}/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

# prefer locally installed node binaries
export PATH=node_modules/.bin:$PATH
