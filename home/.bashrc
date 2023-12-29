#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

test -r /usr/share/bash-completion/completions/nmcli && . /usr/share/bash-completion/completions/nmcli
test -r /usr/share/bash-completion/completions/git && . /usr/share/bash-completion/completions/git
test -r /usr/share/bash-completion/completions/gh && . /usr/share/bash-completion/completions/gh
test -r /usr/share/bash-completion/completions/aws && . /usr/share/bash-completion/completions/aws

eval "$(starship init bash)"

alias sudo='sudo -v && sudo'

alias diff='diff --color=auto'
alias diff-ii='diff --color=auto -E -b -w'

alias grep='grep --color=auto'

alias cd-gitroot='cd $(git rev-parse --show-toplevel)'

alias open='xdg-open'

alias echo-path='echo $PATH | tr ":" "\n" | sort'

