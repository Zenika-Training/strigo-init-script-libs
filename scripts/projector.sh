#!/bin/bash

# failfast
set -e

# Define these 2 optional variables if you want to customize the default installation,
# then copy-paste the remainder of the script:
# - the name of the IDE to install (defaults to "IntelliJ IDEA Community Edition 2020.3.4")
# Note: to get the list of available IDEs, launch `projector find`
# projector_ide_name="IntelliJ IDEA Community Edition 2020.3.4"
# - the password to protect access to projector (defaults to no password)
# projector_password="class-specific-random-password"

projector_ide_name=${projector_ide_name:-IntelliJ IDEA Community Edition 2020.3.4}  # Latest projector-tested IDE
projector_config_name=strigo

# Install projector-installer
# https://github.com/JetBrains/projector-installer
apt-get update
apt-get install -y --no-install-recommends python3 python3-pip python3-cryptography less libxext6 libxrender1 libxtst6 libfreetype6 libxi6
pip3 install projector-installer

# Setup projector
sudo -u ubuntu projector --accept-license ide autoinstall --config-name "${projector_config_name}" --ide-name "${projector_ide_name}" --hostname {{ .STRIGO_RESOURCE_DNS }}
if [ -n "${projector_password}" ]; then
  cat << EOF >> ~ubuntu/.projector/configs/${projector_config_name}/config.ini
[PASSWORDS]
password = ${projector_password}
ro_password = ${projector_password}
EOF
  sudo -u ubuntu projector --accept-license config rebuild "${projector_config_name}"
fi

# Create, enable and start projector config service
cat << EOF > /lib/systemd/system/projector@.service
[Unit]
Description=Jetbrains Projector - ${projector_config_name}
After=network.target

[Service]
Type=exec
ExecStart=/home/ubuntu/.projector/configs/${projector_config_name}/run.sh
Restart=always
User=%i

[Install]
WantedBy=default.target
EOF
systemctl enable --now projector@ubuntu

# Add user settings
sudo -u ubuntu mkdir --parent ~ubuntu/.local/share/JetBrains/consentOptions/
sudo -u ubuntu touch ~ubuntu/.local/share/JetBrains/consentOptions/accepted
echo -n "rsch.send.usage.stat:1.1:0:$(date +%s%3N)" > ~ubuntu/.local/share/JetBrains/consentOptions/accepted  # Don't send anonymous statistics
