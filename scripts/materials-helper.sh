#!/bin/bash

apt-get install -y --no-install-recommends unzip python3 python3-pip
pip3 install gdown

GDOWN_RETRY_MAX=5

function gdown {
  local retries=${GDOWN_RETRY_MAX}
  until [ ${retries} -lt 1 ]; do
    if command gdown $@; then
      break
    fi
    retries=$(( retries - 1 ))
    echo "gdown failed, retrying in 1 seconds..." >&2
    sleep 1
  done
  if [ ${retries} -lt 1 ]; then
    echo "gdown failed ${GDOWN_RETRY_MAX} times, giving up." >&2
    return 1
  fi
}
