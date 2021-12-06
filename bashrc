# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

export EDITOR=vim

if [ -x /usr/bin/wslview ]
then
    export BROWSER=wslview
fi

# Go (installed globally)
export GOPATH=$HOME/gopath
PATH=$GOPATH/bin:/usr/local/go:$PATH

# Rust
if [ -f ~/.cargo/env ]
then
    source "$HOME/.cargo/env"
fi

export CLICOLOR=1
# export GREP_OPTIONS='--color=auto'
if [[ $WSL2 ]]; then
    export GPG_TTY=$(tty)
fi
alias grep='grep --color=auto'

# Setup for Spark / PySpark (sadly, that IPYTHON variable is a bit generally named...)
# export IPYTHON=1
# export SPARK_HOME=~/Code/spark-1.3.1-bin-hadoop2.6
# Need to redo this at some point!
# export SPARK_HOME=/opt/anaconda3/share/spark
# export PATH=$SPARK_HOME/bin:$PATH
export PYSPARK_SUBMIT_ARGS='--master local[*] --executor-memory 12g'

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi


fish_style_dir_cmd='CurDir=`pwd|sed -e "s!$HOME!~!"|sed -Ee "s!([^/])[^/]+/!\1/!g"`'
# PROMPT_COMMAND="update_terminal_cwd; $fish_style_dir_cmd"

# This approach is more portable
PROMPT_COMMAND="$fish_style_dir_cmd; $PROMPT_COMMAND"

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# The bold is pretty subtle, so we only use it as a fallback if there's no color
bold="\[\e[1m\]"
plain="\[\e[0m\]"
green="\[\e[01;32m\]"
blue="\[\e[01;34m\]"

# I don't think this does anything on Ubuntu
# win_title='\[\033]0;\u@\h: \w\007\]'

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# The following is in double-quotes so it gets one round of variable expansion
# at time of definition (thus, the \$ before CurDir)
# The $ is escaped before CurDir because we want it evaluated for each prompt
# We also just put a literal $ at the end, since we are always dav
# That debian_chroot thing was in the default prompt... figured I'd leave it
# there
if [ "$color_prompt" = yes ]; then
    PS1="${debian_chroot:+($debian_chroot)}$green\u@\h$plain:$blue\$CurDir$plain\$(__git_ps1)\\\$ "
else
    PS1="${debian_chroot:+($debian_chroot)}\u@\h:\$CurDir\$(__git_ps1)$bold\\\$$plain "
fi

# color support of ls
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

alias ta='task add'
alias tl='task long'
alias ts='task sync'
alias to='task +OVERDUE'
alias t='task'
alias dm=docker-machine

alias be='bundle exec'

# simple functions to allow arguments inside of complicated commands
dmenv () {
    eval "$(docker-machine env $1)"
}

dbash () {
    docker exec -it $1 bash
}

tomorrow () {
    task $1 modify due:tomorrow
}

# alias condaskel3='conda skeleton pypi --python-version 3.6'
# alias condabuild3='conda build --python 3.6'

# rsync + 1:
# Resursive, preserve (sym)Links, preserve Times, Update,
# Zcompress, Verbose, Append onto shorter files, keep Partial transfers,
# transfer (new) Sparse files efficiently, preserve Executability
# Other things you may want: preserve owner (-o) or group (-g) ID,
# check to update based on checksum (-c) - taking some extra time,
# preserve Permissions (-p)
alias rsynd='rsync -rltuzv --append --partial --sparse --executability'

# Note that the below uses the named portainer_data volume
alias portainer='docker run --rm -d -p 9000:9000 -v /var/run/docker.sock:/var/run/docker.sock -v portainer_data:/data portainer/portainer'

alias sshec2='ssh -oStrictHostKeyChecking=accept-new -i ~/.ssh/dav-testing.pem -L 10000:localhost:10000'

# Because TAQ data is annoying
zipcat() {
    7z x -so $1 2> /dev/null
}


# It's annoyingly hard sometimes to delete an image...
recursive_docker_rmi() {
  for image in $(docker images --quiet --filter "since=${1}")
  do
    if [ $(docker history --quiet ${image} | grep ${1}) ]
    then
      recursive_remove_image "${image}"
    fi
  done
  echo "Removing: ${1}"
  docker rmi -f ${1}
}

# At one point I liked this for git diffs, etc.
# export LESS=FRX

export LESS=R

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

if which rbenv > /dev/null
then
    eval "$(rbenv init -)"
fi

if which aws > /dev/null
then
    complete -C aws_completer aws
fi

if [ -f ~/.config/secrets ]
then
  source ~/.config/secrets
fi

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/dav/mambaforge/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/dav/mambaforge/etc/profile.d/conda.sh" ]; then
        . "/home/dav/mambaforge/etc/profile.d/conda.sh"
    else
        export PATH="/home/dav/mambaforge/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
