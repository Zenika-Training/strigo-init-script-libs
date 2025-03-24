#!/bin/bash

# failfast
set -e

# Define these optional variables if you want to customize the default installation:
# - the version of code-server to install (leave undefined to install the last one)
# code_server_version=3.7.2
# - the port of code-server (default: 9999)
# code_server_port=9999
# - the code-server extensions to install (space-separated names)
# code_server_extensions="ms-azuretools.vscode-docker coenraads.bracket-pair-colorizer-2"
# Note: install code-server after installing docker if you plan to use a docker extension
# - the JSON content of code-server settings (here, to preset a dark theme)
# code_server_settings='{"workbench.startupEditor": "none", "workbench.colorTheme": "Default Dark+"}'
# - the TLS certificate paths
# code_server_tls_key_path="/etc/letsencrypt/live/labs.strigo.io/privkey.pem"
# code_server_tls_cert_path="/etc/letsencrypt/live/labs.strigo.io/fullchain.pem"

# Install code-server (last released version by default)
# https://github.com/coder/code-server/blob/main/docs/install.md#debian-ubuntu
apt-get update
apt-get install -y curl jq
last_code_server_release=$(curl -sL -H "Accept: application/vnd.github.v3+json" https://api.github.com/repos/coder/code-server/releases/latest | grep -Po '/code-server/releases/tag/v\K[^"]*')
code_server_version=${code_server_version:-${last_code_server_release}}
curl -fsSLo /tmp/code-server.deb "https://github.com/coder/code-server/releases/download/v${code_server_version}/code-server_${code_server_version}_amd64.deb"
apt-get install -y /tmp/code-server.deb

code_server_user=${code_server_user:-ubuntu}
code_server_user_homedir=$(getent passwd ${code_server_user} | cut -d: -f6)

# Setup code-server
mkdir --parent ${code_server_user_homedir}/.config/code-server/
cat << EOF > ${code_server_user_homedir}/.config/code-server/config.yaml
bind-addr: {{ .STRIGO_RESOURCE_DNS }}:${code_server_port:-9999}
auth: password
password: '{{ .STRIGO_WORKSPACE_ID }}'
disable-telemetry: true
EOF
if [ -n "${code_server_tls_cert_path}" ] && [ -n "${code_server_tls_key_path}" ]; then
  cat << EOF >> ${code_server_user_homedir}/.config/code-server/config.yaml
cert: ${code_server_tls_cert_path}
cert-key: ${code_server_tls_key_path}
EOF
elif [ -n "${code_server_tls_cert_path}" ] || [ -n "${code_server_tls_chain_path}" ]; then
  echo "One of TLS key or cert is missing, skipping TLS configuration" >&2
fi
chown -R ${code_server_user}: ${code_server_user_homedir}/.config/

# Enable and start code-server
systemctl enable --now code-server@${code_server_user}

# Display code-server password in terminal
cat << EOF > /etc/profile.d/code-server-terminal.sh
if [ "\$USER" = "${code_server_user}" ]; then
  echo -ne '\nCode-server '
  grep '^password:' ~/.config/code-server/config.yaml
  echo
fi
EOF

# Displays the message about code-server version in the trainer terminal only
if [ "{{ .STRIGO_USER_EMAIL }}" = "{{ .STRIGO_EVENT_HOST_EMAIL }}" ]; then
  # defines the message about the code-server version
  if [ "${code_server_version}" = "${last_code_server_release}" ]; then
      code_server_version_message="The last release version of code server is installed (${last_code_server_release})"
  else
      code_server_version_message="!!! Version ${code_server_version} of code server is installed, but a newer release exists (${last_code_server_release})"
  fi

  cat << EOF >> /etc/profile.d/code-server-terminal.sh
if [ "\$USER" = "${code_server_user}" ]; then
  echo -e "${code_server_version_message}. Trainees do not see this message."
fi
EOF
fi

# Install extensions, if any
if [[ ${code_server_extensions} && ${code_server_extensions-_} ]]; then
  code_server_extensions_array=($code_server_extensions)
  for code_server_extension in ${code_server_extensions_array[@]}; do
    sudo -iu ${code_server_user} code-server --install-extension ${code_server_extension}

    if [ "${code_server_extension}" = "coenraads.bracket-pair-colorizer-2" ]; then
      # fixes bracket colorization (https://github.com/coder/code-server/issues/544#issuecomment-776139127) until code-server 3.11?
      sudo ln -s /usr/lib/code-server/lib/vscode/node_modules /usr/lib/code-server/lib/vscode/node_modules.asar
    fi
  done
fi

# Adds user settings
code_server_base_settings='{
  "workbench.startupEditor": "none",
  "security.workspace.trust.enabled": false,
  "telemetry.enableTelemetry": false,
  "telemetry.telemetryLevel": "off",
  "files.exclude": {
    "**/.*": { "when": ".bashrc" }
  }
}'
mkdir --parent ${code_server_user_homedir}/.local/share/code-server/User/
echo "${code_server_base_settings}" "${code_server_settings:-{\}}" | jq --slurp '.[0] * .[1]' > ${code_server_user_homedir}/.local/share/code-server/User/settings.json
chown -R ${code_server_user}: ${code_server_user_homedir}/.local/

# Force restart session to reload terminal(always ubuntu user)
loginctl terminate-user ubuntu
