#!/bin/bash

stdout=$(mktemp)
stderr=$(mktemp)

for repo in /home/panthyr/repos/*/; do
    echo "-> Switching $repo to master branch"
    cd "$repo" || exit
    if ! git checkout master </dev/null >"$stdout" 2>"$stderr"; then
        echo "*********"
        cat "$stderr" >&2
        echo "*********"
    fi
    rm -f "$stdout" "$stderr"
    echo "-> Pulling for $repo"
    if ! git pull </dev/null >"$stdout" 2>"$stderr"; then
        echo "*********"
        cat "$stderr" >&2
        echo "*********"
    fi
    rm -f "$stdout" "$stderr"

    if [ "$repo" = "shell_scripts" ]; then
        chmod +x ./*.sh
        ls -lah
    fi

    echo "DONE."
done
