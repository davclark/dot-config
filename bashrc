# Have a look at .bashrc.system in your home dir for more good stuff

export EDITOR=vim

export CLICOLOR=1
export GREP_OPTIONS='--color=auto'

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

# I don't think this does anything on Ubuntu
# win_title='\[\033]0;\u@\h: \w\007\]'

# The $ is escaped before CurDir because we want it evaluated for each prompt
# We also just put a literal $ at the end, since we are always dav
# That debian_chroot thing was in the default prompt... figured I'd leave it
# there
PS1="${debian_chroot:+($debian_chroot)}\u@\h:\$CurDir$bold\$$plain "

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

docker-bash () {
    docker exec -i -t $1 bash
}

tomorrow () {
    task $1 modify due:tomorrow
}

alias condaskel3='conda skeleton pypi --python-version 3.5'
alias condabuild3='conda build --python 3.5'

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

if which aws > /dev/null
then
    complete -C aws_completer aws
fi

# source ~/.config/secrets
