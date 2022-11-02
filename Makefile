brew:
	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

docker: phony
	DOCKER_BUILDKIT=1 docker build --progress plain -t dotfiles .

zlua:
	git clone https://github.com/skywind3000/z.lua.git ${HOME}/.z.lua

starship: phony
	curl -sS https://starship.rs/install.sh | sh

test:
	docker run -it --rm dotfiles fish

link:
	stow -t ~ .

.PHONY: phony
phony:
