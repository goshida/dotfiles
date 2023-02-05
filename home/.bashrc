#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

test -r /usr/share/git/completion/git-completion.bash && . /usr/share/git/completion/git-completion.bash
test -r /usr/share/bash-completion/completions/nmcli && . /usr/share/bash-completion/completions/nmcli
test -r /usr/bin/aws_completer && complete -C aws_completer aws

eval "$(starship init bash)"

alias sudo='sudo -v && sudo'

alias diff='diff --color=auto'
alias diff-ii='diff --color=auto -E -b -w'

function hugo-post() {
  hugo new posts/`date '+%Y/%m/%d'`/$1/index.md
}

