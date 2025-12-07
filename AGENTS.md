# AGENTS.md - AI Coding Guidelines

## Build/Install Commands
- `make macos` - Install macOS dotfiles (includes personal)
- `make ubuntu` - Install Ubuntu dotfiles (includes personal)
- `make personal` - Install personal/sensitive configs only
- `make stow` - Install GNU stow dependency
- No tests or linting - this is a dotfiles repository

## Repository Structure
- `macos/home/`, `ubuntu/home/` - Platform-specific configs symlinked to $HOME
- `personal/` - Sensitive configs (tokens, secrets) - gitignored content
- `install/` - Installation scripts for tools/packages

## Code Style
- **Shebang**: Use `#!/usr/bin/env bash` or `#!/usr/bin/env zsh` (portable)
- **Functions**: `function name() { ... }` or `name() { ... }`
- **Variables**: `lowercase_with_underscores` for local, `UPPERCASE` for exports
- **Conditionals**: Prefer `[[ ]]` over `[ ]` for bash/zsh
- **Comments**: Use `# comment` style; section folding with `# section {{{` / `# }}}`
- **Error handling**: Use `set -e` in scripts where appropriate

## Naming Conventions
- Scripts: lowercase with hyphens (`git-split.sh`, `tmux-sessionizer`)
- Config files: dotfile convention (`.zshrc`, `.gitconfig`)
- Directories: lowercase, no spaces

## Symlink Management
Uses GNU `stow` to symlink configs. Structure mirrors $HOME (e.g., `macos/home/.zshrc` -> `~/.zshrc`).
