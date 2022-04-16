#!/bin/bash
set -euo pipefail
export PATH="$(dirname $BASH_SOURCE)/bin:$PATH"

read -p "Enter password (may be empty): " PASSWORD

if [[ "$PASSWORD" == "" ]]; then
    NOTEBOOK_ARGS="--NotebookApp.token=''"
else
    set -x
    PASSWORD_SHA1=$(python3 -c "from notebook.auth import passwd; print(passwd(\"$PASSWORD\", algorithm='sha1'), end='')")
    NOTEBOOK_ARGS="--NotebookApp.token='' --NotebookApp.password=\"${PASSWORD_SHA1}\""
fi

read -p "Enter base_url, e.g. 'foobar' (may be empty): " BASE_URL

if [[ "$BASE_URL" == "" ]]; then
    :
else
    NOTEBOOK_ARGS="--NotebookApp.base_url=${BASE_URL} $NOTEBOOK_ARGS"
fi

cat <<EOF>launch-notebook.sh
#!/bin/bash
python3 -m notebook \
   --no-browser \
   --allow-root \
   --NotebookApp.allow_origin='*' \
   --NotebookApp.ip="0.0.0.0" \
   $NOTEBOOK_ARGS
EOF
chmod +x launch-notebook.sh

   # --debug \
   # --show-config \
   # --port=8889 \
   # --NotebookApp.allow_remote_access=True \

cat <<EOF>launch-emacs.sh
#!/bin/bash
emacs -nw --eval '(ein:notebooklist-login "http://localhost:8888/${BASE_URL}" (lambda (buf url-or-port) (switch-to-buffer buf)))'
EOF
chmod +x launch-emacs.sh

pod-run \
    --container-folder . \
    "$@" \
    -- tmux -2 -S tmux.sock new -s session \
    "./launch-notebook.sh \; split-window -v ./launch-emacs.sh"
