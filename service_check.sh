#!/bin/bash 

tmux new-session -s dropcheck_watch -d 'mtr -b -i1 -oL 8.8.8.8'
tmux split-window -t dropcheck_watch -c  -h 'mtr -b -i1 -oL 2001:4860:4860::8888'
tmux attach-session -t dropcheck_watch
