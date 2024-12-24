eval "$(/opt/homebrew/bin/brew shellenv)"

# >>> coursier install directory >>>
export PATH="$PATH:/Users/mgreco/Library/Application Support/Coursier/bin"
# <<< coursier install directory <<<
export TAKT_FILE="~/.takt-log/seedtag.csv"

zstyle ':omz:plugins:nvm' lazy yes
export DOCKER_BUILDKIT=1
export COMPOSE_DOCKER_CLI_BUILD=1
export DOTFILES=$HOME/.dotfiles/macos/home
export ZSH=~/.oh-my-zsh
export ZSH_THEME="robbyrussell"



source $ZSH/oh-my-zsh.sh
[[ $commands[kubectl] ]] && source <(kubectl completion zsh)

# source ~/.prompt.zsh
# eval "$(starship init zsh)"

# export TERM=xterm-kitty

# always after any prompt changes
[ -f $HOME/.autoenv/activate.sh ] && source $HOME/.autoenv/activate.sh
[ -f $HOME/.fzf.zsh ] && source $HOME/.fzf.zsh


# The next line updates PATH for the Google Cloud SDK.
if [ -f "$HOME/Downloads/google-cloud-sdk/path.zsh.inc" ]; then . "$HOME/Downloads/google-cloud-sdk/path.zsh.inc"; fi

# The next line enables shell command completion for gcloud.
if [ -f "$HOME/Downloads/google-cloud-sdk/completion.zsh.inc" ]; then . "$HOME/Downloads/google-cloud-sdk/completion.zsh.inc"; fi

if [ -f "$HOME/.cargo/env" ]; then . "$HOME/.cargo/env"; fi


# command -v oh-my-posh >/dev/null && eval "$(oh-my-posh init zsh -c ~/.ohmyposh-config.json)"
command -v mise > /dev/null 2>&1 && eval "$(mise activate zsh)"


addToPath /opt/homebrew/bin
addToPath ~/.pixi/bin
addToPathFront $HOMEBREW_PREFIX/opt/gnu-sed/libexec/gnubin
addToPathFront /opt/nvim/bin

