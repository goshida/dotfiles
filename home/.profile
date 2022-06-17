# XDG Base Directory
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share

export LANG=en_US.UTF-8

export SCREENRC=$XDG_CONFIG_HOME/screen/screenrc
export STARSHIP_CONFIG=$XDG_CONFIG_HOME/starship/starship.toml

export AWS_VAULT_BACKEND=pass
export AWS_VAULT_PASS_PREFIX=aws-vault
export AWS_SESSION_TOKEN_TTL=0h
export GPG_TTY=$(tty)

