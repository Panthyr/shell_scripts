#! /bin/bash
RED='\033[0;31m'
GREEN='\033[1;32m'
NC='\033[0m' # No Color

start_service()
{
    echo -e "STARTING WORKER SERVICE...\n"
    sudo systemctl start p_worker.service
    if [ $? -eq 0 ]
    then
        echo -e "${GREEN}+=====================+"
        echo "| Started succesfully |"
        echo "+=====================+"
        echo -e "${NC}"
    else
        echo -e "${RED}+===============================+"
        echo "| Issue while starting service! |"
        echo "+===============================+"
        echo -e "${NC}"
        sudo systemctl --no-pager status p_worker.service
    fi
}

stop_service()
{
    echo -e "STOPPING WORKER SERVICE...\n"
    sudo systemctl stop p_worker.service
    if [ $? -eq 0 ]
    then
        echo -e "${GREEN}+=====================+"
        echo "| Stopped succesfully |"
        echo "+=====================+"
        echo -e "${NC}"
    else
        echo -e "${RED}+===============================+"
        echo "| Issue while stopping service! |"
        echo "+===============================+"
        echo -e "${NC}"
        sudo systemctl --no-pager status p_worker.service
    fi
}

if [ "$1" = "restart" ]
then
    stop_service
    echo "WAITING 5 SECONDS TO LET SERVICE SHUT DOWN..."
    sleep 5
    start_service
fi

if [ "$1" = "start" ]
then 
    start_service
fi

if [ "$1" = "stop" ]
then 
    stop_service
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
    echo "No argument supplied. Use 'start', 'stop', 'restart', 'status' or 'logs'..."
fi
