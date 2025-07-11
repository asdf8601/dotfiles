export PATH="$PATH:/opt/homebrew/bin:$HOME/.pixi/bin:$HOMEBREW_PREFIX/opt/gnu-sed/libexec/gnubin:/opt/nvim/bin"
eval "$(/opt/homebrew/bin/brew shellenv)"

# source ~/.common.sh
# >>> coursier install directory >>>
export PATH="$PATH:/Users/mgreco/Library/Application Support/Coursier/bin"
# <<< coursier install directory <<<
export TAKT_TARGET_HOURS=7:30
export TAKT_FILE="/Users/mgreco/.takt-log/seedtag.csv"
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

HISTSIZE=100000
SAVEHIST=100000

setopt BANG_HIST                 # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY          # Write the history file in the ":start:elapsed;command" format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
setopt HIST_VERIFY               # Don't execute immediately upon history expansion.
# setopt HIST_BEEP                 # Beep when accessing nonexistent history.

# command -v oh-my-posh >/dev/null && eval "$(oh-my-posh init zsh -c ~/.ohmyposh-config.json)"
# command -v mise > /dev/null 2>&1 && eval "$(mise activate zsh)"
