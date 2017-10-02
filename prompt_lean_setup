# lean prompt theme
# by Miek Gieben: https://github.com/miekg/lean
#
# Base on Pure by Sindre Sorhus: https://github.com/sindresorhus/pure
# Colors used: (see Vim's paramount theme)
# 241 is the gray that is used.
# 140 is the blue.
#
# MIT License

COLOR1=${PROMPT_LEAN_COLOR1-"241"}
COLOR2=${PROMPT_LEAN_COLOR2-"140"}

PROMPT_LEAN_TMUX=${PROMPT_LEAN_TMUX-"t "}
PROMPT_LEAN_PATH_PERCENT=${PROMPT_LEAN_PATH_PERCENT-60}

prompt_lean_help() {
  cat <<'EOF'
This is a one line prompt that tries to stay out of your face. It utilizes
the right side prompt for most information, like the CWD. The left side of
the prompt is only a '%'. The only other information shown on the left are
the jobs numbers of background jobs. When the exit code of a process isn't
zero the prompt turns red. If a process takes more then 5 (default) seconds
to run the total running time is shown in the next prompt.

Configuration:

PROMPT_LEAN_TMUX: used to indicate being in tmux, set to "t ", by default
PROMPT_LEAN_LEFT: executed to allow custom information in the left side
PROMPT_LEAN_RIGHT: executed to allow custom information in the right side
PROMPT_LEAN_COLOR1: jobs and VCS info indicator color
PROMPT_LEAN_COLOR2: prompt character and directory color
PROMPT_LEAN_VIMODE: used to determine wither or not to display indicator
PROMPT_LEAN_VIMODE_FORMAT: Defaults to "%F{red}[NORMAL]%f"

You can invoke it thus:

  prompt lean

EOF
}

# turns seconds into human readable time, 165392 => 1d 21h 56m 32s
prompt_lean_human_time() {
    local tmp=$1
    local days=$(( tmp / 60 / 60 / 24 ))
    local hours=$(( tmp / 60 / 60 % 24 ))
    local minutes=$(( tmp / 60 % 60 ))
    local seconds=$(( tmp % 60 ))
    (( $days > 0 )) && echo -n "${days}d "
    (( $hours > 0 )) && echo -n "${hours}h "
    (( $minutes > 0 )) && echo -n "${minutes}m "
    echo "${seconds}s "
}

# fastest possible way to check if repo is dirty
prompt_lean_git_dirty() {
    # check if we're in a git repo
    command git rev-parse --is-inside-work-tree &>/dev/null || return
    # check if it's dirty
    local umode="-uno" #|| local umode="-unormal"
    command test -n "$(git status --porcelain --ignore-submodules ${umode} 2>/dev/null | head -100)"

    (($? == 0)) && echo ' +'
}

# displays the exec time of the last command if set threshold was exceeded
prompt_lean_cmd_exec_time() {
    local stop=$EPOCHSECONDS
    local start=${cmd_timestamp:-$stop}
    integer elapsed=$stop-$start
    (($elapsed > ${PROMPT_LEAN_CMD_MAX_EXEC_TIME:=5})) && prompt_lean_human_time $elapsed
}

prompt_lean_preexec() {
    cmd_timestamp=$EPOCHSECONDS

    # shows the current dir and executed command in the title when a process is active
    print -Pn "\e]0;"
    echo -nE "$PWD:t: $2"
    print -Pn "\a"
}

prompt_lean_pwd() {
    local lean_path="`print -Pn '%~'`"
    if (($#lean_path / $COLUMNS.0 * 100 > ${PROMPT_LEAN_PATH_PERCENT:=60})); then
        print -Pn '...%2/'
        return
    fi
    print "$lean_path"
}

prompt_lean_precmd() {
    vcs_info
    rehash

    local jobs
    local prompt_lean_jobs
    unset jobs
    for a (${(k)jobstates}) {
        j=$jobstates[$a];i="${${(@s,:,)j}[2]}"
        jobs+=($a${i//[^+-]/})
    }
    # print with [ ] and comma separated
    prompt_lean_jobs=""
    [[ -n $jobs ]] && prompt_lean_jobs="%F{"$COLOR1"}["${(j:,:)jobs}"] "

    local lean_vimode_default="%F{red}[NORMAL]%f"
    #If LEAN_VIMODE is set, set lean_vimode_indicator to either PROMPT_LEAN_VIMOD_FORMAT or a default value
    local lean_vimode_indicator="${PROMPT_LEAN_VIMODE:+${PROMPT_LEAN_VIMODE_FORMAT:-${lean_vimode_default}}}"

    prompt_lean_vimode="${${KEYMAP/vicmd/$lean_vimode_indicator}/(main|viins)/}"

    setopt promptsubst
    local vcs_info_str='$vcs_info_msg_0_' # avoid https://github.com/njhartwell/pw3nage
    PROMPT="$prompt_lean_jobs%F{yellow}${prompt_lean_tmux}%f`$PROMPT_LEAN_LEFT`%f%(?.%F{"$COLOR2"}.%B%F{red})%#%f%b "
    RPROMPT="%F{yellow}`prompt_lean_cmd_exec_time`%f$prompt_lean_vimode%F{"$COLOR2"}`prompt_lean_pwd`%F{"$COLOR1"}$vcs_info_str`prompt_lean_git_dirty`$prompt_lean_host%f`$PROMPT_LEAN_RIGHT`%f"

    unset cmd_timestamp # reset value since `preexec` isn't always triggered
}

function zle-keymap-select {
    prompt_lean_precmd
    zle reset-prompt
}

prompt_lean_setup() {
    prompt_opts=(cr percent sp subst)

    zmodload zsh/datetime
    autoload -Uz add-zsh-hook
    autoload -Uz vcs_info

    [[ "$PROMPT_LEAN_VIMODE" != '' ]] && zle -N zle-keymap-select

    add-zsh-hook precmd prompt_lean_precmd
    add-zsh-hook preexec prompt_lean_preexec

    zstyle ':vcs_info:*' enable git
    zstyle ':vcs_info:git*' formats ' %b'
    zstyle ':vcs_info:git*' actionformats ' %b|%a'

    [[ "$SSH_CONNECTION" != '' ]] && prompt_lean_host=" %F{yellow}%m%f"
    [[ "$TMUX" != '' ]] && prompt_lean_tmux=$PROMPT_LEAN_TMUX

    return 0
}

prompt_lean_setup "$@"
