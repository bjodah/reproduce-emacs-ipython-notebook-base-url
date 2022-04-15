#!/bin/bash
export PATH="$(dirname $BASH_SOURCE)/bin:$PATH"

cat <<EOF>launch-notebook.sh
#!/bin/bash
python3 -m notebook \
   --no-browser \
   --allow-root \
   --NotebookApp.token="" \
   --NotebookApp.allow_origin='*' \
   --NotebookApp.ip="0.0.0.0" \
   --NotebookApp.base_url=foobar
EOF
chmod +x launch-notebook.sh

   # --debug \
   # --show-config \
   # --port=8889 \
   # --NotebookApp.allow_remote_access=True \

cat <<EOF>launch-emacs.sh
#!/bin/bash
emacs -nw --eval '(ein:notebooklist-login "http://localhost:8888/foobar" (lambda (buf url-or-port) (switch-to-buffer buf)))'
EOF
chmod +x launch-emacs.sh

pod-run \
    --container-folder . \
    "$@" \
    -- tmux -2 -S tmux.sock new -s session \
    "./launch-emacs.sh \; split-window -v ./launch-notebook.sh"
