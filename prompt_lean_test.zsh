#!/bin/zsh

# Some tests for the prompt. We compare the prompt using hex encoding
# to prevent all the control characters messing up the prompt.

COLOR1="241"
COLOR2="140"

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
        print $b |hexdump -C
        exit 1
    fi
}

source prompt_lean_setup

(
prompt_lean_precmd
prompt_lean_preexec
expect='%F{yellow}%f%f%(?.%F{'$COLOR2'}.%B%F{red})%#%f%b '
comphex "prompt" $PROMPT $expect
)

( cd /tmp
prompt_lean_precmd
prompt_lean_preexec
expect='%F{yellow}%f%F{'$COLOR2'}/tmp%F{'$COLOR1'}$vcs_info_msg_0_ %F{yellow}%m%f%f%f'
comphex "rprompt" $RPROMPT $expect
)

(
function left() { echo left }
PROMPT_LEAN_LEFT=left

prompt_lean_precmd
prompt_lean_preexec
expect='%F{yellow}%fleft%f%(?.%F{'$COLOR2'}.%B%F{red})%#%f%b '
comphex "lean_left" $PROMPT $expect
)

( cd /tmp
function right() { echo right }
PROMPT_LEAN_RIGHT=right

prompt_lean_precmd
prompt_lean_preexec
expect='%F{yellow}%f%F{'$COLOR2'}/tmp%F{'$COLOR1'}$vcs_info_msg_0_ %F{yellow}%m%f%fright%f'
comphex "lean_right" $RPROMPT $expect
)

(
PROMPT_LEAN_TMUX='t'
TMUX='yes'
source prompt_lean_setup # TMUX is only evaluated in setup

prompt_lean_precmd
prompt_lean_preexec
expect='%F{yellow}t%f%f%(?.%F{'$COLOR2'}.%B%F{red})%#%f%b '
comphex "tmux" $PROMPT $expect
)

( cd /tmp
PROMPT_LEAN_CMD_MAX_EXEC_TIME=0.1
sleep 1

prompt_lean_precmd
prompt_lean_preexec
expect='%F{yellow}1s %f%F{'$COLOR2'}/tmp%F{'$COLOR1'}$vcs_info_msg_0_ %F{yellow}%m%f%f%f'
comphex "time" $RPROMPT $expect
)
