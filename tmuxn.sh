#!/bin/bash
tmux attach
if [ $? -eq 0 ]
then
    exit 0
fi
tmux new-session \; split-window -h \; split-window -v \;
