About
=====

After having used [prompt pure](https://github.com/sindresorhus/pure) for about
a year, I felt that a two-line prompt was not for me. Also not utilizing the
right side of the terminal seemed a missed opportunity. Still there is much to
like: the elapsed time of a process, the coloring of the prompt if the exit
code of the process isn't 0, git integration. So I took "pure", mixed in my
ideas of what a prompt should look like and came up with "lean" - a 1 line
prompt that stays out of your face.

So lean is an evolution of pure, with the following changes:

* Defaults to a very sparse setup, only showing information you need at the
moment.
* Comes with the perfect prompt character. Author went through the entire ASCII
range to find it (and found it pretty quickly!)
* Never displays your username (assuming you know who you are).
* When tmux is active it shows a yellow 't' (I disabled the tmux bar, so this
is some visual indication that tmux is active). If you don't want this
indicator, you can always set `PROMPT_LEAN_TMUX=""` prior to loading this
plugin (or prior to sourcing `zgen`, etc.).
* Show remote host if logged in through SSH.
* All in one line, most stuff in the right prompt, leaving the left prompt nice
and clean
* Shows background jobs (in the left prompt)
* Show (dirty) git repos
* Shortens path if needed (longer then 70% of your screen)
* Uses `PROMPT_LEAN_LEFT` and `PROMPT_LEAN_RIGHT` to allow customization of the left
  and/or right side of the prompt.
* For a configurable insertmode indicator, set the `PROMPT_LEAN_VIMODE` and `PROMPT_LEAN_VIMODE_FORMAT`
variables. 
  `PROMPT_LEAN_VIMODE_FORMAT` defaults to `"%F{red}[NORMAL]%f"`

When lean starts, only 2 characters show on the screen '%' on the left and '~'
on the right. All other info is omitted (like the user and system you are on),
and shown only when needed.

Here is a [screencast](https://asciinema.org/a/d1b5wccq23kglwwhaymoi8z5i)
showing the prompt.
*Note*: for some reason the screencast does not show the space between the '%'
character and the start of the command line. **NOTE** This
[issue](https://github.com/miekg/lean/issues/2) has been fixed.

[![asciicast](https://asciinema.org/a/d1b5wccq23kglwwhaymoi8z5i.png)](https://asciinema.org/a/d1b5wccq23kglwwhaymoi8z5i)

Installation
===========

If you use [zgen](https://github.com/tarjoilija/zgen) you can add the following
to your `~/.zshrc`:

```
zgen load miekg/lean
```

and force reload with `zgen reset && source~/.zshrc`.
