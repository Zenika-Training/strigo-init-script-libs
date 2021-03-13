#!/bin/bash

# https://docs.docker.com/compose/install/

COMPOSE_VERSION=1.28.2

# Install docker-compose
curl -fsSLo /usr/local/bin/docker-compose "https://github.com/docker/compose/releases/download/${COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)"
chmod +x /usr/local/bin/docker-compose

# Add docker-compose completion
curl -fsSLo /etc/bash_completion.d/docker-compose "https://raw.githubusercontent.com/docker/compose/${COMPOSE_VERSION}/contrib/completion/bash/docker-compose"
