After having used [prompt pure]() for about a year, I felt that a two-line
prompt was not for me. Also not utilizing the right side of the terminal seemed
a missed opportunity. Still there is much to like: the elapsed time of
a process, the coloring of the prompt if the exit code of the process isn't 0,
git integration. So I took "pure", mixed in my ideas of what a prompt should
look like and came up with "lean" - a 1 line prompt that stays out of your face.

So lean is an evolution (complete rewrite) of pure, with the following changes:

* Defaults to a very sparse setup, only showing information you need at the moment.
* Never displays your username (assuming you know who you are).
* When tmux is active it shows a yellow 't' (I disabled the tmux bar, so this is some
    visual indication that tmux is active).
* Show remote host if logged in through SSH.
* All in one line, most stuff in the right prompt, leaving the left prompt nice and clean
* shows background jobs (in the left prompt)
* show (dirty) git repos
* shortens path if needed (longer then 70% of your screen)

When lean starts, only 2 characters show on the screen '%' on the left and '~' on the right. All
other info is omitted (like the user and system you are on), and shown only when needed.

Here are some screencasts on how things look. TODO
