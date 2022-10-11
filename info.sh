echo ""
echo "=============================="
echo "      UPTIME AND LOGINS       "
echo "=============================="
w # uptime information and who is logged in
echo ""
echo "Current date/time: $(date +"%d/%m/%Y %H:%M")"
echo ""
echo "=============================="
echo "         DISK USAGE           "
echo "=============================="
df -h -x tmpfs -x udev # disk usage, minus def and swap
echo ""
echo "           MEMORY             "
echo "=============================="
free
echo "=============================="
echo "USE ~/scripts/p_worker.sh logs TO CHECK WORKER SERVICE STATUS."
echo "USE ~/scripts/csl.sh TO CHECK SYSTEM LOGS FOR CRON MESSAGES."
echo "=============================="
echo "       WORKER SERVICE         "
echo "=============================="
systemctl status p_worker.service
