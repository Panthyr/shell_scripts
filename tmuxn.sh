#!/bin/bash

if tmux attach; then
    exit 0
fi
tmux new-session \; split-window -h \; split-window -v \;
