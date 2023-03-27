#!/bin/bash
# based on https://koenwoortman.com/tmux-sessions-should-be-nested-with-care-unset-tmux-to-force/

session_name="panthyr"

if ! tmux has-session -t=$session_name; then
    TMUX='' tmux new-session -d -s "$session_name" \; split-window -h \; split-window -v \;
fi

# Attach if outside of tmux, switch if you're in tmux.
if [[ -z "$TMUX" ]]; then
    tmux attach -t "$session_name"
else
    tmux switch-client -t "$session_name"
fi
