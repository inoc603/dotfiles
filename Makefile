brew:
	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

docker: phony
	docker build --progress plain -t dotfiles .

starship: phony
	curl -sS https://starship.rs/install.sh | sh

bin/list_git_projects: utils/list_git_projects/*
	cd utils/list_git_projects && go build -o ../../$@ .

test:
	docker run -it --rm dotfiles fish

link:
	stow -t ~ .

.PHONY: phony
phony:
