#!/bin/bash

cat <<EOF > /etc/systemd/system/tool.service 
[Unit]
Description=Vagrant startup VM
After=libvirtd.service

[Service]
ExecStart=${1}

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable tool
systemctl start tool
