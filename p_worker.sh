#! /bin/bash
RED='\033[0;31m[47m'
GREEN='\033[1;32m'
NC='\033[0m' # No Color

if [ "$1" = "start" ]
then 
    sudo systemctl start p_worker.service
    if [ $? -eq 0 ]
    then
        echo -e "${GREEN}+=====================+"
        echo "| Started succesfully |"
        echo "+=====================+"
    else
        echo -e "${RED}+===============================+"
        echo "| Issue while starting service! |"
        echo "+===============================+"
        echo ""
        sudo systemctl status p_worker.service
    fi
fi

if [ "$1" = "stop" ]
then 
    sudo systemctl stop p_worker.service
    if [ $? -eq 1 ]
    then
        echo -e "${GREEN}+=====================+"
        echo "| Stopped succesfully |"
        echo "+=====================+"
    else
        echo -e "${RED}+===============================+"
        echo "| Issue while stopping service! |"
        echo "+===============================+"
        echo ""
        sudo systemctl status p_worker.service
    fi
fi 

if [ "$1" = "status" ]
then 
    sudo systemctl status p_worker.service
fi

if [ "$1" = "logs" ]
then
    journalctl -u p_worker.service -b
fi

if [ -z "$1" ]
then
    echo "No argument supplied. Use 'start', 'stop', 'status' or 'logs'..."
fi