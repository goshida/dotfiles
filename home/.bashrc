#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

test -r /usr/share/git/completion/git-completion.bash && . /usr/share/git/completion/git-completion.bash
test -r /usr/bin/aws_completer && complete -C aws_completer aws

eval "$(starship init bash)"

alias sudo='sudo -v && sudo '

alias diff-ii='diff -E -b -w'

alias mount-nfs='sudo mount -t nfs -o user,noauto,rw 192.168.3.25:/volume1/share /mnt/nfs/'

