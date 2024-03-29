#!/bin/bash
echo ""
echo "=============================="
echo "      UPTIME AND LOGINS       "
echo "=============================="
w # uptime information and who is logged in
echo ""
echo ""
echo "=============================="
echo "         DISK USAGE           "
echo "=============================="
df -h -x tmpfs -x udev # disk usage, minus def and swap
echo ""
echo "=============================="
echo "            USAGE             "
echo "=============================="
echo "USE p_worker.sh status TO CHECK WORKER SERVICE STATUS"
echo "USE p_worker.sh logs TO CHECK WORKER SERVICE LOGS"
echo "USE csl.sh TO CHECK SYSTEM LOGS FOR CRON MESSAGES."
echo ""
echo "=============================="
echo "       WORKER SERVICE         "
echo "=============================="
systemctl --full --no-pager status p_worker.service
