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
	$(call link_to_home,zsh)
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
	@ echo 'Install tmux plugins'
	@ ./tmux/plugins/tpm/bin/install_plugins
	pip install -U powerline-status

bin:
	mkdir -p ~/bin
	ln -s `pwd`/bin/* ~/bin

ag:
	$(call link_to_home,agignore)

ansible:
	$(call link_to_home,ansible.cfg)
