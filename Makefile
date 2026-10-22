OS := $(shell uname)


##@ Utility
.PHONY: help
help:  ## Display this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make <target>\033[36m\033[0m\n"} /^[a-zA-Z\._-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

.PHONY: stow
stow:  ## Install stow
	[[ $(OS) == "Darwin" ]] && brew install stow || sudo apt-get install stow

.PHONY: hooks
hooks:  ## Use the repo's git hooks (gitleaks pre-commit)
	git config core.hooksPath .githooks

.PHONY: macos
macos: hooks personal launchd  ## Install macos settings
	stow -d macos/home/ -t $(HOME)/ .

LAUNCHD_PLIST := com.asdf8601.dotfiles-maintenance.plist

.PHONY: launchd
launchd:  ## Install the monthly maintenance launchd job (copied, launchd ignores symlinked plists)
	cp macos/launchd/$(LAUNCHD_PLIST) $(HOME)/Library/LaunchAgents/
	launchctl bootout gui/$$(id -u)/$(basename $(LAUNCHD_PLIST)) 2>/dev/null || true
	launchctl bootstrap gui/$$(id -u) $(HOME)/Library/LaunchAgents/$(LAUNCHD_PLIST)

.PHONY: ubuntu
ubuntu: hooks personal  ## Install ubuntu settings
	stow -d ubuntu/home/ -t $(HOME)/ .

SEEDTAG_SKILLS_SRC := $(CURDIR)/seedtag/.config/opencode/skills
OPENCODE_SKILLS    := $(HOME)/.config/opencode/skills

PERSONAL_SKILLS_SRC := $(CURDIR)/personal/.claude/skills
SKILL_TARGETS       := $(HOME)/.config/opencode/skills $(HOME)/.pi/agent/skills $(HOME)/.codex/skills $(HOME)/.gemini/antigravity-cli/skills

.PHONY: personal
personal: seedtag skills  ## Install personal settings (includes seedtag and personal skills)
	stow --ignore ".git" -d personal/ -t $(HOME)/ .

.PHONY: skills
skills:  ## Symlink personal/.claude/skills into the other agents (stow covers ~/.claude)
	@for target in $(SKILL_TARGETS); do \
		mkdir -p $$target; \
		for skill in $(PERSONAL_SKILLS_SRC)/*/; do \
			name=$$(basename $$skill); \
			if [ ! -e $$target/$$name ]; then \
				ln -s $${skill%/} $$target/$$name; \
				echo "  LINK: $$target/$$name -> $${skill%/}"; \
			fi; \
		done; \
	done

ESPANSO_MATCH := $(CURDIR)/$(if $(filter Darwin,$(OS)),macos,ubuntu)/home/.config/espanso/match

.PHONY: seedtag
seedtag:  ## Symlink seedtag opencode skills and espanso snippets from the seedtag submodule
	@ln -sfn $(CURDIR)/seedtag/.config/espanso/match/seedtag.yml $(ESPANSO_MATCH)/seedtag.yml
	@mkdir -p $(OPENCODE_SKILLS)
	@for skill in $(SEEDTAG_SKILLS_SRC)/*/; do \
		name=$$(basename $$skill); \
		if [ ! -e $(OPENCODE_SKILLS)/$$name ]; then \
			ln -s $$skill $(OPENCODE_SKILLS)/$$name; \
			echo "  LINK: $$name -> $$skill"; \
		fi; \
	done

.PHONY: pushall
pushall:  ## Push all changes
	git add . && git commit -am "update all" && git push

.PHONY: push
push:  ## Push changes
	git commit -am "update" && git push

.PHONY: pull
pull:  ## Pull changes
	git pull && [[ $(OS) == "Darwin" ]] && make macos || make ubuntu
