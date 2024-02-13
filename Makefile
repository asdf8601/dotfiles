OS := $(shell uname)

.PHONY: stow
stow:
	[[ $(OS) == "Darwin" ]] && brew install stow || sudo apt-get install stow

.PHONY: macos
macos: personal
	stow -d macos/home/ -t $(HOME)/ .

.PHONY: ubuntu
ubuntu: personal
	stow -d ubuntu/home/ -t $(HOME)/ .

.PHONY: personal
personal:
	stow --ignore ".git" -d personal/ -t $(HOME)/ .

.PHONY: pushall
pushall:
	git add . && git commit -am "update all" && git push

.PHONY: push
push:
	git commit -am "update" && git push

.PHONY: pull
pull:
	git pull && [[ $(OS) == "Darwin" ]] && make macos || make ubuntu
