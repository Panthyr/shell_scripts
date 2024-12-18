#!/bin/bash

tmpfile=$(mktemp /home/panthyr/XXX)


for repo in /home/panthyr/repos/*/.git
    do 
    branch=$(cat $repo/HEAD)
    branch=${branch##*/}
    if [ $branch != "develop" ]; then
        branch="-->  $branch"
    fi

    echo "${repo%/.git}~$branch" >> "$tmpfile"
done

column -s "~" -t $tmpfile
rm $tmpfile