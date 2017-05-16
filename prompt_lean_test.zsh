#!/bin/zsh

setopt nomatch
print $PROMPT
source prompt_lean_setup
prompt_lean_precmd
prompt_lean_preexec

echo $PROMPT | od
echo $PROMPT

expect='%F{yellow}%(?.%F{blue}.%B%F{red})%#%f%b\n'
echo $expect | od
echo $expect 

if [[ $PROMPT = $expect ]]; then
    print "  OK"
else
    print "FAIL"
fi
