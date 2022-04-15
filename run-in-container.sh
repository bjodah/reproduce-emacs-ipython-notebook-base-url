#!/bin/bash

FILE_SHARE_ROOT=${WORK_ROOT:-/tmp/mnt-file-share}
mkdir -p $FILE_SHARE_ROOT

cat <<EOF>>$FILE_SHARE_ROOT/.tmux.conf
unbind C-b
set -g prefix 'C-\'
bind 'C-\' send-prefix
set -g mouse on
set -g default-terminal "screen-256color"
set -g status-style "bg=blue"
set -g remain-on-exit on  # cf. respawn-pane & respawn-pane -k
set -g history-limit 15000  # default is 2000 lines
EOF

cat <<EOF>>$FILE_SHARE_ROOT/host-notebook.sh
#!/bin/bash
python3 -m notebook --config-file /fshare/jupyer_notebook_config.py
EOF
podrun \
    --container-folder env \
    --image docker.io/silex/emacs:28.1-ci-cask \
    -- tmux -2 -S tmux.sock -f /work/.tmux.conf new -s emacs -nw --eval '(load-file "/fshare/open-notebook-list.el")' \
    \; split-window -h "python3 -m notebook"
EOF
