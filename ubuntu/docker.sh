#!/bin/bash

# https://docs.docker.com/engine/install/ubuntu/

# Uninstall old versions
apt-get remove -y docker docker-engine docker.io containerd runc
apt-get update
apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

# Set up the repository
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
apt-key fingerprint 0EBFCD88
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

# Install Docker Engine
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io

# Enable user to use Docker
usermod -aG docker ubuntu
# Force restart tmux session to reload groups
killall -9 /home/ubuntu/.strigo/tmux
