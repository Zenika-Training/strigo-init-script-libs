#!/bin/bash

# https://docs.docker.com/engine/install/ubuntu/

# Define these optional variables if you want to customize the default installation:
# - the JSON content of daemon.json settings
# docker_extra_settings='{"exec-opts":["native.cgroupdriver=systemd"]}'

# Uninstall old versions
dpkg --purge docker docker-engine docker.io containerd runc
apt-get autoremove --purge -y
apt-get update
apt-get install -y \
    jq \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# Set up the repository
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list

# Install Docker Engine
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io

# Enable containers log rotation and compression
docker_base_settings='{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "5k",
    "max-file": "3",
    "compress": "true"
  }
}'
echo "${docker_base_settings}" "${docker_extra_settings:-{\}}" | jq --slurp '.[0] * .[1]' > /etc/docker/daemon.json
systemctl restart docker

# Enable user to use Docker
usermod -aG docker ubuntu
# Force restart session to reload groups
loginctl terminate-user ubuntu
