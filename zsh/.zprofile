# Env variables
export SSH_AUTH_SOCK=~/.ssh/ssh-agent.sock

# SSH: reuse same agent for multiple sessions
ssh-add -l 2> /dev/null > /dev/null
[ $? -ge 2 ] && ssh-agent -a "$SSH_AUTH_SOCK" > /dev/null

# Add Homebrew to PATH
eval "$(/opt/homebrew/bin/brew shellenv)"

# Homebrew completions
FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
