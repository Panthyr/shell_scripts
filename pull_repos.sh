#!/bin/bash

stdout=$(tempfile)
stderr=$(tempfile)


for repo in /home/hypermaq/repos/panthyr*/ ; do
    echo "-> Pulling for $repo"
    cd $repo
    if ! git pull </dev/null >$stdout 2>$stderr; then
        echo "*********"
        cat $stderr >&2
        echo "*********"
    fi
    rm -f $stdout $stderr
    
    if [ $repo = "shell_scripts" ]; then
        chmod +x *.sh
        ls -lah
    fi

echo "DONE."
done
