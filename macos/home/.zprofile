eval "$(/opt/homebrew/bin/brew shellenv)"
export PATH="$PATH:/opt/homebrew/bin:$HOME/.pixi/bin:$HOMEBREW_PREFIX/opt/gnu-sed/libexec/gnubin:/opt/nvim/bin"

# source ~/.common.sh
# >>> coursier install directory >>>
export PATH="$PATH:/Users/mgreco/Library/Application Support/Coursier/bin"
# <<< coursier install directory <<<

export TAKT_FILE="~/.takt-log/seedtag.csv"
export TAKT_EDITOR="nvim"

# zstyle ':omz:plugins:nvm' lazy yes
export DOCKER_BUILDKIT=1
export BUILDX_EXPERIMENTAL=1
export COMPOSE_DOCKER_CLI_BUILD=1
export DOTFILES=$HOME/.dotfiles/macos/home

export ZSH=~/.oh-my-zsh
export ZSH_THEME="robbyrussell"

# The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOME/Downloads/google-cloud-sdk/path.zsh.inc" ]; then . "$HOME/Downloads/google-cloud-sdk/path.zsh.inc"; fi

# The next line enables shell command completion for gcloud.
if [ -f "$HOME/Downloads/google-cloud-sdk/completion.zsh.inc" ]; then . "$HOME/Downloads/google-cloud-sdk/completion.zsh.inc"; fi

if [ -f "$HOME/.cargo/env" ]; then . "$HOME/.cargo/env"; fi


# command -v oh-my-posh >/dev/null && eval "$(oh-my-posh init zsh -c ~/.ohmyposh-config.json)"
command -v mise > /dev/null 2>&1 && eval "$(mise activate zsh)"
