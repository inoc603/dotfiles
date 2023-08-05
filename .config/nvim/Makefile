
define link
	@ if [ -L $(2) ]; then \
		echo "Remove link $(2)"; \
		rm -f $(2); \
	fi
	@ ln -s $(1) $(2) && \
		echo "Link $(1) to $(2)"
endef

docker:
	docker build -t nvim .

base: Dockerfile-build
	docker build -f Dockerfile-build -t nvim-build .

build: 
	rm -rf tmp/*
	docker run -v $(CURDIR):/tmp/my-vim --rm nvim-build sh -c /tmp/my-vim/docker.sh
	docker build -t nvim .

install:
	$(call link,$(CURDIR),~/.vim)
	$(call link,~/.vim/.vimrc,~/.vimrc)
	mkdir -p ~/.config
	$(call link,$(CURDIR),~/.config/nvim)
	$(call link,$(CURDIR)/.vimrc,~/.vim/init.vim)

python:
	pyenv virtualenv 3.7.4 neovim && \
	pyenv activate neovim && \
	python install -i http://pypi.douban.com/simple/ --trusted-host pypi.douban.com neovim black pylint
