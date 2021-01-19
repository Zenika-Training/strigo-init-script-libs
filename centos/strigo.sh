#!/bin/bash

# Force hostname
hostnamectl set-hostname {{ .STRIGO_RESOURCE_NAME }}
sed --in-place "0,/^127.0.0.1/s/$/ {{ .STRIGO_RESOURCE_NAME }}/" /etc/hosts

yum install -y curl

# Inject Strigo context
cat <<\EOF > /etc/profile.d/00_strigo_context.sh
# Strigo context
export INSTANCE_NAME={{ .STRIGO_RESOURCE_NAME }}
export PUBLIC_DNS={{ .STRIGO_RESOURCE_DNS }}
export PUBLIC_IP=$(curl --silent ifconfig.co)
export PRIVATE_DNS={{ .STRIGO_RESOURCE_DNS }}
export PRIVATE_IP=$(dig +short {{ .STRIGO_RESOURCE_DNS }})
export HOSTNAME={{ .STRIGO_RESOURCE_NAME }}
EOF
