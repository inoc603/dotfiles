FROM alpine:edge

RUN apk add --update-cache \
	git \
	libtermkey \
	unibilium \
	python \
	py2-pip \
	python-dev \
	g++ \
	make \
	go

RUN pip install neovim

ADD ./tmp/bin/nvim /usr/local/bin/nvim
ADD ./tmp/share/nvim /usr/local/share
ADD ./tmp/lib/* /usr/local/lib/

ADD . /root/.vim

WORKDIR /root/.vim

RUN make clean bundle ycm vim-go install
