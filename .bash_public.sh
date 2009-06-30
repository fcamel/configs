alias p='ps auxw'
alias g='grep -i --color'
alias ll='ls -lF --color'
alias ltr='ls -lFtr --color'
alias ls='ls -F --color'
alias scr='screen'
alias h='history'

alias mv='mv -i'
alias cp='cp -i'
alias rm='rm -i'

alias vnc='vncserver -geometry 1440x900 -depth 24'
alias vnc2='vncserver -geometry 1920x1200 -depth 24'

export EDITOR='vim'
export PAGER='less'
export LESS=-ir

export PS1="[\u@wiki \w ]\n$ "

# Mercurial
source /home/hg/extensions/bash-completion
export HGMERGE=kdiff3
export HGENCODING=utf-8

function set_hg_rep() {
    hg_rep=$(pwd | awk -F/ '{ print $5 }')
    if [ "$hg_rep" != "" ]; then
        hg_rep="(\033[1;31m$(pwd | awk -F/ '{ print $5 }')\033[m)"
    fi
    export PS1="[\u@wiki \w $hg_rep]\n$ "
}

function my_cd() {
    \cd $1 && set_hg_rep
}

alias cd=my_cd
