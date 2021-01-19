#!/bin/bash

# https://github.com/cdr/code-server/blob/master/doc/install.md#fedora-centos-rhel-suse

yum install -y curl

# Install code-server
curl -fsSLo /tmp/code-server.rpm https://github.com/cdr/code-server/releases/download/v3.7.4/code-server-3.7.4-amd64.rpm
yum install -y /tmp/code-server.rpm

# Setup code-server
mkdir --parent /home/centos/.config/code-server/
cat <<EOF > /home/centos/.config/code-server/config.yaml
bind-addr: {{ .STRIGO_RESOURCE_DNS }}:9999
auth: password
password: '{{ .STRIGO_WORKSPACE_ID }}'
disable-telemetry: true
EOF
chown -R centos: /home/centos/.config/

# Enable and start code-server
systemctl enable --now code-server@centos

# Display code-server password in terminal
cat <<\EOF > /etc/profile.d/code-server-password.sh
if [ $USER = centos ]; then
  echo -ne '\nCode-server '
  grep '^password:' ~/.config/code-server/config.yaml
  echo
fi
EOF

# Install extensions
#sudo -iu centos code-server code-server --install-extension ...
