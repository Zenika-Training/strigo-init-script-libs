#!/bin/bash

# Set up the repository
echo "deb [arch=amd64] https://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list
wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -

# Install Chrome
apt-get update
apt-get install -y google-chrome-stable
