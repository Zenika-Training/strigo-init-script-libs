#!/bin/bash

# failfast
set -e

# Define these 2 variables if you want to customize the default installation,
# then copy-paste the remainder of the script:
# - the version of code-server to install (leave undefined to install the last one)
# code_server_version=3.7.2
# - the code-server extensions to install (space-separated names)
# code_server_extensions="ms-azuretools.vscode-docker coenraads.bracket-pair-colorizer-2"
# Note: install code-server after installing docker if you plan to use a docker extension
# - the JSON content of code-server settings (here, to make the terminal a JSON shell + dark theme)
# (see https://code.visualstudio.com/docs/editor/integrated-terminal#_shell-arguments)
# code_server_settings='{ "terminal.integrated.shellArgs.linux": ["-l"], "workbench.colorTheme": "Default Dark+"}'

# https://github.com/cdr/code-server/blob/master/doc/install.md#debian-ubuntu

apt-get install -y curl

# Install code-server
apt-get install -y curl
last_code_server_release=$(curl -s -H "Accept: application/vnd.github.v3+json" https://api.github.com/repos/cdr/code-server/releases/latest | grep -Po 'cdr/code-server/releases/tag/v\K[^"]*')
code_server_version=${code_server_version:-${last_code_server_release}}
# Defines the message about the code-server version displayed in the trainer terminal
if [ "${code_server_version}" = "${last_code_server_release}" ]; then
    code_server_version_message="The last release version of code server is installed (${last_code_server_release})"
else
    code_server_version_message="!!! Version ${code_server_version} of code server is installed, but a newer release exists (${last_code_server_release})"
fi
curl -fsSLo /tmp/code-server.deb "https://github.com/cdr/code-server/releases/download/v${code_server_version}/code-server_${code_server_version}_amd64.deb"
apt-get install -y /tmp/code-server.deb

# Setup code-server
mkdir --parent /home/ubuntu/.config/code-server/
cat << EOF > /home/ubuntu/.config/code-server/config.yaml
bind-addr: {{ .STRIGO_RESOURCE_DNS }}:9999
auth: password
password: '{{ .STRIGO_WORKSPACE_ID }}'
disable-telemetry: true
EOF
chown -R ubuntu: /home/ubuntu/.config/

# Enable and start code-server
systemctl enable --now code-server@ubuntu

# Display code-server password in terminal
cat << EOF > /etc/profile.d/code-server-password.sh
if [ \$USER = ubuntu ]; then
  # displays the message about code-server version to the trainer only
  if [ "{{ .STRIGO_USER_EMAIL }}" = "{{ .STRIGO_EVENT_HOST_EMAIL }}" ]; then
    echo -ne "\n${code_server_version_message}. Trainees do not see this message."
  fi
  echo -ne '\nCode-server '
  grep '^password:' ~/.config/code-server/config.yaml
  echo
fi
EOF

# Install extensions, if any
if [[ ${code_server_extensions} && ${code_server_extensions-_} ]]; then
  code_server_extensions_array=($code_server_extensions)
  for code_server_extension in ${code_server_extensions_array[@]}; do
    sudo -iu ubuntu code-server code-server --install-extension ${code_server_extension}
  done
fi

# Adds user settings, if any
if [[ ${code_server_settings} && ${code_server_settings-_} ]]; then
  echo ${code_server_settings} > /home/ubuntu/.local/share/code-server/User/settings.json
  chown ubuntu:ubuntu /home/ubuntu/.local/share/code-server/User/settings.json
fi
