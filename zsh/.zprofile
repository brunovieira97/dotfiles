# Env variables
export SSH_AUTH_SOCK=~/.1password/agent.sock

# Add Homebrew to PATH
eval "$(/opt/homebrew/bin/brew shellenv)"

# Homebrew completions
FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"

autoload -Uz compinit && compinit