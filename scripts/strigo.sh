#!/bin/bash

# Force hostname
hostnamectl set-hostname '{{ .STRIGO_RESOURCE_NAME }}'
sed --in-place "0,/^127.0.0.1/s/$/ $(hostnamectl status --static) $(hostnamectl status --static).zenika.labs.strigo.io/" /etc/hosts

# Install https://github.com/canonical/cloud-utils to have 'ec2metadata'
apt-get install -y cloud-utils

# Inject Strigo context
cat <<\EOF > /etc/profile.d/00_strigo_context.sh
# Strigo context
export INSTANCE_NAME='{{ .STRIGO_RESOURCE_NAME }}'
export PUBLIC_DNS={{ .STRIGO_RESOURCE_DNS }}
export PUBLIC_IP=$(ec2metadata --public-ipv4)
export PRIVATE_DNS={{ .STRIGO_RESOURCE_DNS }}
export PRIVATE_IP=$(ec2metadata --local-ipv4)
export HOSTNAME='{{ .STRIGO_RESOURCE_NAME }}'
EOF
