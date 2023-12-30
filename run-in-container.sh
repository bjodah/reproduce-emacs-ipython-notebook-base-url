#!/bin/bash
set -euo pipefail
export PATH="$(dirname $BASH_SOURCE)/bin:$PATH"

read -p "Enter password (may be empty): " PASSWORD

if [[ "$PASSWORD" == "" ]]; then
    NOTEBOOK_ARGS="--NotebookApp.token=''"
else
    if ! python3 -c "from notebook.auth import passwd" >/dev/null; then
        echo "We need to generate a password hash using notebook-6.x, but it is unavailable"
        echo "a throwaway virtualenv will be set up to generate the hash. Pass an empty password"
        echo "to circumvent this, (or install notebook-6.x into the base env of 'python3')"
        read -p "OK to proceed? [Y/n]" OK_TO_PROCEED
        if [[ $OK_TO_PROCEED == n || $OK_TO_PROCEED == N ]]; then
            exit 0
        fi
        if ! which virtualenv >/dev/null; then
            >&2 echo "The command 'virtualenv' is not on path, aborting."
            exit 1
        fi
        TEMP_ENV_DIR=$(mktemp -d)
        cleanup() {
            rm -r "$TEMP_ENV_DIR"
        }
        trap cleanup TERM EXIT
        virtualenv $TEMP_ENV_DIR
        $TEMP_ENV_DIR/bin/pip install 'notebook<7';
        PASSWORD_SHA1=$($TEMP_ENV_DIR/bin/python -c "from notebook.auth import passwd; print(passwd(\"$PASSWORD\", algorithm='sha1'), end='')")
        echo $PASSWORD_SHA1
    else
        PASSWORD_SHA1=$(python3 -c "from notebook.auth import passwd; print(passwd(\"$PASSWORD\", algorithm='sha1'), end='')")
    fi
    set -x
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
   --NotebookApp.ip="127.0.0.1" \
   $NOTEBOOK_ARGS
EOF
chmod +x launch-notebook.sh

   # --debug \
   # --show-config \
   # --port=8889 \
   # --NotebookApp.allow_remote_access=True \

cat <<EOF>launch-emacs.sh
#!/bin/bash
emacs -nw --eval '(ein:notebooklist-login "http://127.0.0.1:8888/${BASE_URL}" (lambda (buf url-or-port) (switch-to-buffer buf)))'
EOF
chmod +x launch-emacs.sh

pod-run \
    --container-folder . \
    -e LC_ALL=en_US.UTF-8 \
    -e LANG=en_US.UTF-8 \
    "$@" \
    -- tmux -2 -S tmux.sock new -s session \
    "./launch-notebook.sh \; split-window -v ./launch-emacs.sh"
