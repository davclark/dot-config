export EDITOR=vim

export CLICOLOR=1
export GREP_OPTIONS='--color=auto'
# /usr/local/bin is already in the path, but it's AFTER /usr/bin
PATH=/opt/local/bin:/usr/local/bin:$PATH
PATH=$PATH:/Applications/git-annex.app/Contents/MacOS
PATH=$PATH:/usr/local/share/npm/bin:/Applications/Mplus
export PATH="/opt/anaconda/bin:$PATH"

fish_style_dir_cmd='CurDir=`pwd|sed -e "s!$HOME!~!"|sed -Ee "s!([^/])[^/]+/!\1/!g"`'
# PROMPT_COMMAND="update_terminal_cwd; $fish_style_dir_cmd"

# This approach is more portable
PROMPT_COMMAND="$fish_style_dir_cmd; $PROMPT_COMMAND"
# The bold is pretty subtle, probably nice to use something else (color?)
bold="\[\e[1m\]"
plain="\[\e[0m\]"
win_title='\[\033]0;\u@\h: \w\007\]'
# The $ is escaped before CurDir because we want it evaluated for each prompt
PS1="${win_title}dav@Trade \$CurDir$bold\$$plain "

alias dct="ssh davclark@dlab-collaboratool.berkeley.edu"
alias skim='open -a Skim'

# At one point I liked this for git diffs, etc.
# export LESS=FRX

if which rbenv > /dev/null
then
    eval "$(rbenv init -)"
fi

if [ -f $(brew --prefix)/etc/bash_completion ]; then
. $(brew --prefix)/etc/bash_completion
fi

# OS X and other systems purportedly disagree about locale naming conventions,
# especially once you've used a non-US locale
# I got the below from the net, but this doesn't actually seem to work on Ubuntu
# export LANG="en_US"
# export LANGUAGE=$LANG
# export LC_ALL=$LANG
