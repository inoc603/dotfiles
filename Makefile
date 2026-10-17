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

edi:
	mkdir -p ~/.edi/prompts ~/.edi/skills
	cp .edi/system_prompt.md ~/.edi/system_prompt.md
	cp -R .edi/prompts/. ~/.edi/prompts/
	cp -R .edi/skills/. ~/.edi/skills/
	if [ -d .edi/airwallex ]; then \
		mkdir -p ~/.edi/airwallex; \
		cp -R .edi/airwallex/. ~/.edi/airwallex/; \
		cp -R .edi/airwallex/skills/. ~/.edi/skills/; \
		cp .edi/airwallex/system_prompt.md ~/.edi/system_prompt.md; \
	fi

link: edi
	stow -t ~ .

.PHONY: edi phony
phony:
