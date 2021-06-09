.PHONY: zsh tmux bin ag ansible

# how do I create a variable in side the function ?
define link_to_home
	@ if [ -L ~/$(if $(2),$(2),.$(1)) ]; then \
		echo "Remove link ~/$(if $(2),$(2),.$(1))"; \
		rm -f ~/$(if $(2),$(2),.$(1)); \
	fi
	@ ln -s $(CURDIR)/$(1) ~/$(if $(2),$(2),.$(1)) && \
		echo "Link $(1) to ~/$(if $(2),$(2),.$(1))"
endef

all: zsh ag ansible tmux

zsh:
	# -git clone --recursive https://github.com/zimfw/zimfw.git ${ZDOTDIR:-${HOME}}/.zim
	# setopt EXTENDED_GLOB
	# for template_file in ${ZDOTDIR:-${HOME}}/.zim/templates/*; do \
	  # user_file="${ZDOTDIR:-${HOME}}/.${template_file:t}"; \
	  # touch ${user_file}; \
	  # ( print -rn "$(<${template_file})$(<${user_file})" >! ${user_file} ) 2>/dev/null; \
	# done
	# source ${ZDOTDIR:-${HOME}}/.zlogin
	$(call link_to_home,zsh)
	$(call link_to_home,zimrc)
	$(call link_to_home,zshrc)

tmux:
	@ if [ -e ./tmux/plugins/tpm ]; then \
		echo 'Update tpm'; \
		cd ./tmux/plugins/tpm && git pull; \
	else \
		echo 'Clone tpm'; \
		git clone https://github.com/tmux-plugins/tpm ./tmux/plugins/tpm; \
	fi;
	$(call link_to_home,tmux)
	$(call link_to_home,tmux.conf)
	$(call link_to_home,tmux-osx.conf)
	$(call link_to_home,bin/tf.zsh,tf)
	@ echo 'Install tmux plugins'
	@ ./tmux/plugins/tpm/bin/install_plugins
	pip install -U powerline-status

ag:
	$(call link_to_home,agignore)

ansible:
	$(call link_to_home,ansible.cfg)

brew:
	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

hammerspoon: phony
	$(call link_to_home,hammerspoon)

alacritty: phony
	$(call link_to_home,.alacritty.yml,.alacritty.yml)

.PHONY: phony
phony:
