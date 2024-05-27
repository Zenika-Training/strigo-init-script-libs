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
  --standalone --cert-name labs.strigo.io --domain '{{ .STRIGO_RESOURCE_DNS }}' || true

if [ ! -f /etc/letsencrypt/live/labs.strigo.io/privkey.pem ]; then
  # Fallback to self-signed certificate
  mkdir -p /etc/letsencrypt/{live,archive}/labs.strigo.io/
  openssl req -newkey rsa:2048 -x509 -days 7 -nodes \
    -subj "/CN={{ .STRIGO_RESOURCE_DNS }}" \
    -addext "subjectAltName=DNS:{{ .STRIGO_RESOURCE_DNS }},IP:${PUBLIC_IP:-127.0.0.1}" \
    -addext "keyUsage=critical,digitalSignature,keyEncipherment" \
    -addext "extendedKeyUsage=serverAuth,clientAuth" \
    -addext "certificatePolicies=2.23.140.1.2.1" \
    -keyout /etc/letsencrypt/archive/labs.strigo.io/privkey.pem \
    -out /etc/letsencrypt/archive/labs.strigo.io/cert.pem
  cp /etc/letsencrypt/archive/labs.strigo.io/cert.pem /etc/letsencrypt/archive/labs.strigo.io/chain.pem
  cp /etc/letsencrypt/archive/labs.strigo.io/cert.pem /etc/letsencrypt/archive/labs.strigo.io/fullchain.pem
  ln -s /etc/letsencrypt/archive/labs.strigo.io/* /etc/letsencrypt/live/labs.strigo.io/
fi

# Give read access to ubuntu user
setfacl --modify user:ubuntu:rX /etc/letsencrypt/{live,archive}
setfacl --modify user:ubuntu:rX /etc/letsencrypt/archive/labs.strigo.io/privkey*.pem

# Set env vars to TLS files
cat <<\EOF > /etc/profile.d/tls_certificate.sh
# Let's Encrypt TLS certificate
export TLS_PRIVKEY=/etc/letsencrypt/live/labs.strigo.io/privkey.pem
export TLS_CERT=/etc/letsencrypt/live/labs.strigo.io/cert.pem
export TLS_CHAIN=/etc/letsencrypt/live/labs.strigo.io/chain.pem
export TLS_FULLCHAIN=/etc/letsencrypt/live/labs.strigo.io/fullchain.pem
EOF
. /etc/profile.d/tls_certificate.sh
