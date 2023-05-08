#!/bin/bash

if [ "$EUID" -ne 0 ]; then
  echo "Please run as root"
  exit
fi

FILENAME="/etc/systemd/system/p_worker.service"

cat >$FILENAME <<EOF
[Unit]
Description=Panthyr worker
After=multi-user.target
ConditionPathExists=/home/panthyr/.local/bin/worker
[Service]
WorkingDirectory=/home/panthyr
Type=simple
User=panthyr
ExecStart=/bin/bash -c '/home/panthyr/.local/bin/worker'
# append only works starting at systemd 240
StandardOutput=append:/home/panthyr/data/logs/service_stdout.log
StandardError=append:/home/panthyr/data/logs/service_stderr.log
Restart=on-success
RestartSec=5s
[Install]
WantedBy=multi-user.target
Alias=p_worker
EOF

chmod 644 $FILENAME

echo "Created service file $FILENAME"

systemctl daemon-reload && systemctl enable p_worker.service && systemctl start p_worker.service

echo "Status: "
systemctl status p_worker.service
