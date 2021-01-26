#!/bin/bash

# https://docs.docker.com/engine/install/centos/

# Uninstall old versions
yum remove -y docker \
    docker-client \
    docker-client-latest \
    docker-common \
    docker-latest \
    docker-latest-logrotate \
    docker-logrotate \
    docker-engine

# Set up the repository
yum install -y yum-utils
yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo

# Install Docker Engine
yum install -y docker-ce \
    docker-ce-cli \
    containerd.io

# Revert https://github.com/moby/moby/pull/41297 which cause problems
sed --in-place 's/^\(After=.*\) multi-user.target\(.*\)/\1\2/' /usr/lib/systemd/system/docker.service
systemctl daemon-reload

# Start Docker
systemctl enable docker
systemctl start docker

# Enable user to use Docker
usermod -aG docker centos
# Force restart tmux session to reload groups
killall -9 /home/centos/.strigo/tmux
