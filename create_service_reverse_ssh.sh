#!/bin/bash

if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit
fi

FILENAME="/etc/systemd/system/reverse_ssh.service"

echo "Enter port number for this station (ie. 30052 for MSO)"
read -r PORT_NUMBER

cat >$FILENAME <<EOF

[Unit]
Description=Reverse SSH to Enhydra
After=network.target

[Service]
User=panthyr
ExecStart=/usr/bin/ssh -p 9022 -v -g -N -T -o "ServerAliveInterval 10" -o "ExitOnForwardFailure yes" -R $PORT_NUMBER:127.0.0.1:22 -l panthyr enhydra.naturalsciences.be
Restart=always
RestartSec=5s
StartLimitInterval=0
# append only works starting at systemd 240
StandardOutput=append:/home/panthyr/data/logs/service_reserse_ssh_stdout.log
StandardError=append:/home/panthyr/data/logs/service_reverse_ssh_stderr.log
alias=reverse_ssh

[Install]
WantedBy=multi-user.target
EOF

chmod 644 $FILENAME

echo "Created service file $FILENAME using port $PORT_NUMBER"

systemctl daemon-reload && systemctl enable reverse_ssh.service && systemctl start reverse_ssh.service

echo "Status: "
systemctl status reverse_ssh.service
