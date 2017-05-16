#!/bin/zsh

# Some tests for the prompt. We compare the prompt using hex encoding
# to prevent all the control characters messing up the prompt.

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

prompt_lean_precmd
prompt_lean_preexec

expect='%F{yellow}%(?.%F{blue}.%B%F{red})%#%f%b '
comphex "prompt" $PROMPT $expect

( cd /tmp
prompt_lean_precmd
prompt_lean_preexec

expect='%F{yellow}%f%F{blue}/tmp%F{242}$vcs_info_msg_0_ %F{yellow}%m%f%f'
comphex "rprompt" $RPROMPT $expect
)

