#!/bin/bash

# https://github.com/cdr/code-server/blob/master/doc/install.md#debian-ubuntu

apt-get install -y curl

# Install code-server
curl -fsSLo /tmp/code-server.deb https://github.com/cdr/code-server/releases/download/v3.7.1/code-server_3.7.1_amd64.deb
apt-get install -y /tmp/code-server.deb

# Setup code-server
mkdir --parent /home/ubuntu/.config/code-server/
cat <<EOF > /home/ubuntu/.config/code-server/config.yaml
bind-addr: {{ .STRIGO_RESOURCE_0_DNS }}:9999
auth: password
password: '{{ .STRIGO_WORKSPACE_ID }}'
disable-telemetry: true
EOF
chown -R ubuntu: /home/ubuntu/.config/

# Enable and start code-server
systemctl enable --now code-server@ubuntu

# Display code-server password in terminal
cat <<\EOF > /etc/profile.d/code-server-password.sh
if [ $USER = ubuntu ]; then
  echo -ne '\nCode-server '
  grep '^password:' ~/.config/code-server/config.yaml
  echo
fi
EOF
