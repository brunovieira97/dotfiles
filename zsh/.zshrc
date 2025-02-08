# Env variables
export ZSH="$HOME/.oh-my-zsh"

export CLICOLOR=1
export GPG_TTY=$TTY
export HOMEBREW_NO_ENV_HINTS=1

export PATH="${ASDF_DATA_DIR:-$HOME/.asdf}/shims:$PATH:/Users/bruno/.local/bin"

# Theme to load
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# History commands timestamp
# Default formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
HIST_STAMPS="yyyy-mm-dd"

# Plugins
# Standard plugins = $ZSH/plugins/
# Custom plugins = $ZSH_CUSTOM/plugins/
plugins=(
	docker
	docker-compose
	fast-syntax-highlighting
	git
	macos
)

# Oh-My-Zsh setup
source $ZSH/oh-my-zsh.sh

# Aliases
alias l='ls -lho'
alias ll='ls -Aho'
alias cat='bat'
alias qrcode='curl qrcode.show -d'
alias sizerank='du -sh * 2>/dev/null | sort -hr'

# iTerm2 shell integration
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# 1Password CLI completions
eval "$(op completion zsh)"; compdef _op op

# ASDF
. ~/.asdf/plugins/java/set-java-home.zsh
