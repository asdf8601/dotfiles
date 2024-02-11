OS := $(shell uname)

.PHONY: macos
macos:
	stow -d macos/home/ -t $(HOME)/ .
	stow -d personal/ -t $(HOME)/ .

.PHONY: ubuntu
ubuntu:
	stow -d ubuntu/home/ -t $(HOME)/ .
	stow -d personal/ -t $(HOME)/ .

.PHONY: pushall
pushall:
	git add . && git commit -am "update all" && git push

.PHONY: push
push:
	git commit -am "update" && git push

.PHONY: pull
pull:
	git pull && [[ $(OS) == "Darwin" ]] && make macos || make ubuntu
