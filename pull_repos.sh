#!/bin/bash

stdout=$(mktemp)
stderr=$(mktemp)

for repo in /home/panthyr/repos/*/; do
    cd "$repo" || exit
    branch=$(git symbolic-ref --short HEAD)
    echo "-> Pulling for $repo, branch $branch"
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
