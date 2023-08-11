FROM debian:bookworm

COPY debian/sources.list /etc/apt/sources.list 

WORKDIR /root/src/github.com/inoc603/dotfiles

RUN apt-get update -y

RUN apt install -y \
	build-essential stow tmux git curl fish \
	lua5.3 exa

# set fish as default shell
RUN chsh -s $(which fish)

# installing terminfo for alacritty
RUN \
curl https://raw.githubusercontent.com/alacritty/alacritty/master/extra/alacritty.info > /etc/alacritty.info && \
tic -xe alacritty,alacritty-direct /etc/alacritty.info
ENV TERM=xterm-256color

# configuring locales
RUN apt install -y locales && \
echo en_US.UTF-8 UTF-8 > /etc/locale.gen && \
locale-gen && \
update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8

# install starship
RUN curl -sS https://starship.rs/install.sh -o /tmp/install_starship.sh && \
	sh /tmp/install_starship.sh --yes && \
	rm /tmp/install_starship.sh

# install neovim
RUN apt install -y ninja-build gettext cmake unzip curl && \
git clone --branch master --depth 1 https://github.com/neovim/neovim /root/src/github.com/neovim/neovim && \
cd /root/src/github.com/neovim/neovim && make CMAKE_BUILD_TYPE=RelWithDebInfo && make install

# install z.lua
RUN git clone https://github.com/skywind3000/z.lua.git .z.lua

# install asdf
RUN git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.12.0

ADD . .

# stow to home directory
RUN make link

# after neovim config is in place, install all the plugins.
RUN nvim --headless "+:Lazy! install" ":TSInstallSync! all" +qa
