# syntax=docker/dockerfile:1.3-labs

FROM debian:bullseye

COPY <<EOF /etc/apt/sources.list 
deb http://mirrors.aliyun.com/debian/ bullseye main non-free contrib
deb-src http://mirrors.aliyun.com/debian/ bullseye main non-free contrib
deb http://mirrors.aliyun.com/debian-security/ bullseye-security main
deb-src http://mirrors.aliyun.com/debian-security/ bullseye-security main
deb http://mirrors.aliyun.com/debian/ bullseye-updates main non-free contrib
deb-src http://mirrors.aliyun.com/debian/ bullseye-updates main non-free contrib
deb http://mirrors.aliyun.com/debian/ bullseye-backports main non-free contrib
deb-src http://mirrors.aliyun.com/debian/ bullseye-backports main non-free contrib
EOF

RUN apt-get update -y

RUN apt install -y build-essential stow tmux git curl fish

# set fish as default shell
RUN chsh -s $(which fish)

# installing terminfo for alacritty
RUN <<EOF
curl https://raw.githubusercontent.com/alacritty/alacritty/master/extra/alacritty.info > /etc/alacritty.info
tic -xe alacritty,alacritty-direct /etc/alacritty.info
EOF

ENV TERM=xterm-256color

# configuring locales
RUN apt install -y locales
RUN <<EOF
echo en_US.UTF-8 UTF-8 > /etc/locale.gen
locale-gen
update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8
EOF

RUN curl -sS https://starship.rs/install.sh -o /tmp/install_starship.sh && \
	sh /tmp/install_starship.sh --yes && \
	rm /tmp/install_starship.sh

RUN apt install lua5.3

RUN git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.11.3

RUN git clone https://github.com/skywind3000/z.lua.git ${HOME}/.z.lua

ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8

WORKDIR /root/src/github.com/inoc603/dotfiles

ADD ./.config ./.config

ADD . .

RUN make link

# RUN zsh -c -i "export TERM=xterm; export zinit_install=true; source .zshrc"
# # RUN zsh -c "export TERM=xterm; export zinit_install=true; source .zshrc"
