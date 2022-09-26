#!/bin/bash

stdout=$(tempfile)
stderr=$(tempfile)


for d in /home/hypermaq/repos/panthyr*/ ; do
    echo "-> Pulling for $d"
    cd $d
    if ! git pull </dev/null >$stdout 2>$stderr; then
        echo "*********"
        cat $stderr >&2
        echo "*********"
    fi
    rm -f $stdout $stderr
    
chmod +x /home/hypermaq/repos/shell_scripts/*.sh

echo "DONE."
done
