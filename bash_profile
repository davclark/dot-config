export EDITOR=vim

export CLICOLOR=1
export GREP_OPTIONS='--color=auto'
# /usr/local/bin is already in the path, but it's AFTER /usr/bin
PATH=/opt/local/bin:/usr/local/bin:$PATH
PATH=$PATH:/Applications/git-annex.app/Contents/MacOS
PATH=$PATH:/usr/local/share/npm/bin:/Applications/Mplus
PATH=$PATH:/opt/BIDMach_0.9.0-osx-x86_64
PATH=/opt/anaconda3/bin:$PATH
PATH=$PATH:$HOME/Library/Android/sdk/platform-tools

# Setup for Spark / PySpark (sadly, that IPYTHON variable is a bit generally named...)
# export IPYTHON=1
# export SPARK_HOME=~/Code/spark-1.3.1-bin-hadoop2.6
# Need to redo this at some point!
# export SPARK_HOME=/opt/anaconda3/share/spark
# export PATH=$SPARK_HOME/bin:$PATH
export PYSPARK_SUBMIT_ARGS='--master local[*] --executor-memory 12g'

fish_style_dir_cmd='CurDir=`pwd|sed -e "s!$HOME!~!"|sed -Ee "s!([^/])[^/]+/!\1/!g"`'
# PROMPT_COMMAND="update_terminal_cwd; $fish_style_dir_cmd"

# This approach is more portable
PROMPT_COMMAND="$fish_style_dir_cmd; $PROMPT_COMMAND"
# The bold is pretty subtle, probably nice to use something else (color?)
bold="\[\e[1m\]"
plain="\[\e[0m\]"
win_title='\[\033]0;\u@\h: \w\007\]'
# The $ is escaped before CurDir because we want it evaluated for each prompt
PS1="${win_title}dav@$(networksetup -getcomputername) \$CurDir$bold\$$plain "

alias skim='open -a Skim'
alias nv='open -a NeoVim'
alias ta='task add'
alias tl='task long'
alias ts='task sync'
alias to='task +OVERDUE'
alias t='task'
alias dm=docker-machine

# simple functions to allow arguments inside of complicated commands
dmenv () {
    eval "$(docker-machine env $1)"
}

tomorrow () {
    task $1 modify due:tomorrow
}

alias condaskel3='conda skeleton pypi --python-version 3.4'
alias condabuild3='conda build --python 3.4'

# rsync + 1:
# Resursive, preserve (sym)Links, preserve Times, Update,
# Zcompress, Verbose, Append onto shorter files, keep Partial transfers,
# transfer (new) Sparse files efficiently, preserve Executability
# Other things you may want: preserve owner (-o) or group (-g) ID,
# check to update based on checksum (-c) - taking some extra time,
# preserve Permissions (-p)
alias rsynd='rsync -rltuzv --append --partial --sparse --executability'

# Because TAQ data is annoying
zipcat() {
    7z x -so $1 2> /dev/null
}

# At one point I liked this for git diffs, etc.
# export LESS=FRX

export LESS=R

if which rbenv > /dev/null
then
    eval "$(rbenv init -)"
fi

if [ -f $(brew --prefix)/etc/bash_completion ]; then
. $(brew --prefix)/etc/bash_completion
fi

# This shouldn't be dependent on the above
complete -C aws_completer aws

source ~/.config/secrets

# OS X and other systems purportedly disagree about locale naming conventions,
# especially once you've used a non-US locale
# I got the below from the net, but this doesn't actually seem to work on Ubuntu
# export LANG="en_US"
# export LANGUAGE=$LANG
# export LC_ALL=$LANG
