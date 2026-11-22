# ~/.zshrc: Catppuccin Mocha terminal setup

# ---------- Environment ----------
export XDG_CONFIG_HOME="$HOME/.config"      # tools keep configs in ~/.config
export EZA_CONFIG_DIR="$HOME/.config/eza"   # eza ignores XDG on macOS
export EDITOR="code --wait"
export VISUAL="$EDITOR"

# ---------- Shell ----------
setopt INTERACTIVE_COMMENTS                 # allow # comments in pasted commands

# ---------- History ----------
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt SHARE_HISTORY HIST_IGNORE_ALL_DUPS HIST_IGNORE_SPACE HIST_REDUCE_BLANKS

# ---------- Completion ----------
# (Homebrew's completions are added to fpath by `brew shellenv` in ~/.zprofile)
autoload -Uz compinit && compinit
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'   # case-insensitive

# ---------- Autosuggestions ----------
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=#6c7086'             # Catppuccin overlay0
source "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"

# ---------- fzf (Catppuccin Mocha colours + previews) ----------
export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1E1E2E,spinner:#F5E0DC,hl:#F38BA8 \
--color=fg:#CDD6F4,header:#F38BA8,info:#CBA6F7,pointer:#F5E0DC \
--color=marker:#B4BEFE,fg+:#CDD6F4,prompt:#CBA6F7,hl+:#F38BA8 \
--color=selected-bg:#45475A \
--color=border:#6C7086,label:#CDD6F4"
export FZF_CTRL_T_OPTS="--walker-skip .git,node_modules,target --preview 'bat -n --color=always {}'"
export FZF_ALT_C_OPTS="--walker-skip .git,node_modules,target --preview 'eza --tree --level=2 --icons=always --color=always {}'"
source <(fzf --zsh)

# ---------- Tools ----------
eval "$(zoxide init zsh)"          # z <folder>
eval "$(mise activate zsh)"        # Node, Python, ... versions
eval "$(batman --export-env)"      # coloured man pages via bat
eval "$(starship init zsh)"        # prompt

# ---------- Aliases ----------
alias ls='eza --icons=auto --group-directories-first'
alias ll='eza -l --icons=auto --git --group-directories-first'
alias la='eza -la --icons=auto --git --group-directories-first'
alias lt='eza --tree --level=2 --icons=auto'
alias cat='bat --paging=never'
alias lg='lazygit'
alias vi='nvim'
alias vim='nvim'
alias nv='nvim'

# ---------- Syntax highlighting ----------
source "$HOME/.config/zsh/catppuccin_mocha-zsh-syntax-highlighting.zsh"
source "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
