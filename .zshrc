# Versioned Homebrew toolchains (Rustup and Zig matching ZLS 0.16).
typeset -U path PATH
for nvim_toolchain_bin in /opt/homebrew/opt/rustup/bin /opt/homebrew/opt/zig@0.16/bin; do
  [[ -d "$nvim_toolchain_bin" ]] && path=("$nvim_toolchain_bin" $path)
done
unset nvim_toolchain_bin
export PATH

# Interactive shell configuration.
[[ -o interactive ]] || return

# Keep command paths unique, including when this file is sourced again.
typeset -U path PATH
path=("$HOME/.local/bin" $path)
if [[ -d /Applications/ChatGPT.app/Contents/Resources/codex-cli/CodexCLI.app/Contents/MacOS ]]; then
  path=(/Applications/ChatGPT.app/Contents/Resources/codex-cli/CodexCLI.app/Contents/MacOS $path)
fi
# Homebrew on Apple Silicon.
if [[ -d /opt/homebrew/bin ]]; then
  path=(/opt/homebrew/bin /opt/homebrew/sbin $path)
fi
# User-installed .NET SDK and its command-line tools.
if [[ -x "$HOME/.dotnet/dotnet" ]]; then
  export DOTNET_ROOT="$HOME/.dotnet"
  path=("$DOTNET_ROOT" "$DOTNET_ROOT/tools" $path)
fi
export PATH

# Oh My Zsh supplies completions, Git shortcuts, and directory jumping.
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME=""
zstyle ':omz:update' mode reminder
plugins=(git z macos history-substring-search)
if [[ -r "$ZSH/oh-my-zsh.sh" ]]; then
  source "$ZSH/oh-my-zsh.sh"
else
  autoload -Uz compinit
  compinit
fi

# Useful history, shared across terminal windows.
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt SHARE_HISTORY HIST_IGNORE_ALL_DUPS HIST_SAVE_NO_DUPS
setopt HIST_REDUCE_BLANKS HIST_IGNORE_SPACE EXTENDED_HISTORY
setopt AUTO_CD INTERACTIVE_COMMENTS

# Tab opens a menu; match names regardless of capitalization.
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%F{cyan}%d%f'
[[ -n "$LS_COLORS" ]] && zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# Familiar editing keys; arrows search for the text already typed.
bindkey -e
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line
bindkey '^[[3~' delete-char
if (( $+functions[history-substring-search-up] )); then
  bindkey '^[[A' history-substring-search-up
  bindkey '^[[B' history-substring-search-down
fi

# Load the GitHub key into the existing macOS SSH agent.
if [[ -n "$SSH_AUTH_SOCK" && -S "$SSH_AUTH_SOCK" && -r "$HOME/.ssh/id_ed25519_github.pub" ]]; then
  /usr/bin/ssh-add -T "$HOME/.ssh/id_ed25519_github.pub" </dev/null >/dev/null 2>&1 ||
    /usr/bin/ssh-add "$HOME/.ssh/id_ed25519_github" </dev/null >/dev/null 2>&1
fi

# Starship supplies the visual prompt; initialize before widget plugins.
if (( $+commands[starship] )); then
  eval "$(starship init zsh)"
else
  PROMPT='%F{cyan}%~%f %F{green}%#%f '
fi

# Directory shortcuts use quoted paths and work with spaces.
function dev() { builtin cd -- "$HOME/dev"; }
function config() { builtin cd -- "$HOME/.config"; }
function desktop() { builtin cd -- "$HOME/Desktop"; }
function downloads() { builtin cd -- "$HOME/Downloads"; }
alias ..='cd ..'
alias ...='cd ../..'
alias ll='ls -lah'
alias reload='exec zsh -l'

# Shipyard
alias shipyard='python3 ~/dev/personal/shipyard/scripts/shipyard.py'

# macOS supplies ssh-agent; let SSH load keys when a connection needs them.
# Plugins are installed explicitly, never downloaded during shell startup.
ZSH_AUTOSUGGEST_STRATEGY=(history)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=100
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=244'
[[ -r "$ZSH/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] &&
  source "$ZSH/custom/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"

# Syntax highlighting must be sourced after other widgets and key bindings.
[[ -r "$ZSH/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] &&
  source "$ZSH/custom/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# Leave a successful status even if an optional plugin is absent.
true
