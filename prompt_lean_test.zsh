#!/bin/zsh

# Some tests for the prompt. We compare the prompt using hex encoding
# to prevent all the control characters messing up the prompt.

COLOR1="242"
COLOR2="110"
COLOR3="150"

function comphex() {
    local name="$1"
    local a="$2"
    local b="$3"

    ah=$(print $a | hexdump)
    bh=$(print $b | hexdump)

    if [[ $ah == $bh ]]; then
        print "  OK - $name"
    else
        print "FAIL - $name"
        print $a |hexdump -C
        echo
        print $b |hexdump -C
        exit 1
    fi
}

source prompt_lean_setup

(
prompt_lean_precmd
prompt_lean_preexec
expect='%F{'$COLOR3'}%f%f%(?.%F{'$COLOR2'}.%B%F{red})%#%f%b '
comphex "prompt" $PROMPT $expect
)

( cd /tmp
prompt_lean_precmd
prompt_lean_preexec
expect='%F{'$COLOR3'}%f%F{'$COLOR2'}/tmp%F{'$COLOR1'}$vcs_info_msg_0_%f%f'
comphex "rprompt" $RPROMPT $expect
)

(
function left() { echo left }
PROMPT_LEAN_LEFT=left

prompt_lean_precmd
prompt_lean_preexec
expect='%F{'$COLOR3'}%fleft%f%(?.%F{'$COLOR2'}.%B%F{red})%#%f%b '
comphex "lean_left" $PROMPT $expect
)

( cd /tmp
function right() { echo right }
PROMPT_LEAN_RIGHT=right

prompt_lean_precmd
prompt_lean_preexec
expect='%F{'$COLOR3'}%f%F{'$COLOR2'}/tmp%F{'$COLOR1'}$vcs_info_msg_0_%fright%f'
comphex "lean_right" $RPROMPT $expect
)

(
PROMPT_LEAN_TMUX='t'
TMUX='yes'
source prompt_lean_setup # TMUX is only evaluated in setup

prompt_lean_precmd
prompt_lean_preexec
expect='%F{'$COLOR3'}t%f%f%(?.%F{'$COLOR2'}.%B%F{red})%#%f%b '
comphex "tmux" $PROMPT $expect
)

( cd /tmp
PROMPT_LEAN_CMD_MAX_EXEC_TIME=0.1
sleep 1

prompt_lean_precmd
prompt_lean_preexec
expect='%F{'$COLOR3'}1s %f%F{'$COLOR2'}/tmp%F{'$COLOR1'}$vcs_info_msg_0_%f%f'
comphex "time" $RPROMPT $expect
)

( LONGDIR="/tmp/app/src/main/java/com/example"
mkdir -p $LONGDIR && cd $LONGDIR
abbr_dir=$(COLUMNS=100 PROMPT_LEAN_PATH_PERCENT=34 prompt_lean_abbr_shrink)
comphex "abbr-shrink-unchanged" $abbr_dir $LONGDIR
)

( LONGDIR="/tmp/app/src/main/java/com/example"
mkdir -p $LONGDIR && cd $LONGDIR
abbr_dir=$(COLUMNS=100 PROMPT_LEAN_PATH_PERCENT=33 prompt_lean_abbr_shrink)
comphex "abbr-shrink-1" $abbr_dir "/t/app/src/main/java/com/example"
)

( LONGDIR="/tmp/app/src/main/java/com/example"
mkdir -p $LONGDIR && cd $LONGDIR
abbr_dir=$(COLUMNS=100 PROMPT_LEAN_PATH_PERCENT=5 prompt_lean_abbr_shrink)
comphex "abbr-shrink-full" $abbr_dir "/t/a/s/m/j/c/example"
)
