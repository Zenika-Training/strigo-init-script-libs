#!/bin/bash

# Install certbot
apt-get update
apt-get install -y --no-install-recommends certbot acl

# Create certificate
if [[ -n "${ZEROSSL_EAB_KID}" && -n "${ZEROSSL_EAB_HMAC_KEY}" ]]; then
  # https://github.com/zerossl/zerossl-bot/blob/master/zerossl-bot.sh
  ZEROSSL_OPTS="--eab-kid ${ZEROSSL_EAB_KID} --eab-hmac-key ${ZEROSSL_EAB_HMAC_KEY} --server https://acme.zerossl.com/v2/DV90"
fi
certbot certonly --non-interactive --agree-tos --register-unsafely-without-email \
   ${ZEROSSL_OPTS} \
  --standalone --cert-name labs.strigo.io --domain '{{ .STRIGO_RESOURCE_DNS }}'

# Give read access to ubuntu user
setfacl --modify user:ubuntu:rX /etc/letsencrypt/{live,archive}
setfacl --modify user:ubuntu:rX /etc/letsencrypt/archive/labs.strigo.io/privkey1.pem

# Set env vars to TLS files
cat <<\EOF > /etc/profile.d/tls_certificate.sh
# Let's Encrypt TLS certificate
export TLS_PRIVKEY=/etc/letsencrypt/live/labs.strigo.io/privkey.pem
export TLS_CERT=/etc/letsencrypt/live/labs.strigo.io/cert.pem
export TLS_CHAIN=/etc/letsencrypt/live/labs.strigo.io/chain.pem
export TLS_FULLCHAIN=/etc/letsencrypt/live/labs.strigo.io/fullchain.pem
EOF
. /etc/profile.d/tls_certificate.sh
