#!/bin/bash

# failfast
set -e

# Define these optional variable if you want to customize the default installation,
# then copy-paste the remainder of the script:
# - the version of docker-compose to install (leave undefined to install the last one)
# docker_compose_version=2.0.1

# Install docker-compose (last released version by default)
# https://docs.docker.com/compose/install/

apt-get install -y curl
last_docker_compose_release=$(curl -sL -H "Accept: application/vnd.github.v3+json" https://api.github.com/repos/docker/compose/releases/latest | grep -Po 'docker/compose/releases/tag/v\K[^"]*')
docker_compose_version=${docker_compose_version:-${last_docker_compose_release}}

if [ ${docker_compose_version%%.*} -ge 2 ]; then
  mkdir --parent /usr/local/libexec/docker/cli-plugins
  curl -fsSLo /usr/local/libexec/docker/cli-plugins/docker-compose "https://github.com/docker/compose/releases/download/v${docker_compose_version}/docker-compose-$(uname -s)-$(uname -m)"
  chmod +x /usr/local/libexec/docker/cli-plugins/docker-compose

  # Backward compatibility
  ln -s /usr/local/libexec/docker/cli-plugins/docker-compose /usr/local/bin/docker-compose
else
  curl -fsSLo /usr/local/bin/docker-compose "https://github.com/docker/compose/releases/download/${docker_compose_version}/docker-compose-$(uname -s)-$(uname -m)"
  chmod +x /usr/local/bin/docker-compose

  # Add docker-compose completion
  curl -fsSLo /etc/bash_completion.d/docker-compose "https://raw.githubusercontent.com/docker/compose/${docker_compose_version}/contrib/completion/bash/docker-compose"
fi
