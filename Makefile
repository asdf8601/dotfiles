OS := $(shell uname)


##@ Utility
.PHONY: help
help:  ## Display this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make <target>\033[36m\033[0m\n"} /^[a-zA-Z\._-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

.PHONY: stow
stow:  ## Install stow

	[[ $(OS) == "Darwin" ]] && brew install stow || sudo apt-get install stow

.PHONY: macos
macos: personal  ## Install macos settings

	stow -d macos/home/ -t $(HOME)/ .

.PHONY: ubuntu
ubuntu: personal  ## Install ubuntu settings


	stow -d ubuntu/home/ -t $(HOME)/ .

.PHONY: personal
personal:  ## Install personal settings

	stow --ignore ".git" -d personal/ -t $(HOME)/ .

.PHONY: pushall
pushall:  ## Push all changes

	git add . && git commit -am "update all" && git push

.PHONY: push
push:  ## Push changes

	git commit -am "update" && git push

.PHONY: pull
pull:  ## Pull changes

	git pull && [[ $(OS) == "Darwin" ]] && make macos || make ubuntu
