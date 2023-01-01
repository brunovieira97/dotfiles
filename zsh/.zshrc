# Env variables
export ZSH="$HOME/.oh-my-zsh"

export JAVA_HOME="/Library/Java/JavaVirtualMachines/openjdk-17.jdk/Contents/Home"
export PATH="$JAVA_HOME/bin:$PATH"

export CLICOLOR=1
export GPG_TTY=$TTY

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
	zsh-autosuggestions
)

# Oh-My-Zsh setup
source $ZSH/oh-my-zsh.sh

# Aliases
alias l='ls -lho'
alias ll='ls -Aho'
alias cat='bat'
alias qrcode='curl qrcode.show -d'

# iTerm2 shell integration
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
