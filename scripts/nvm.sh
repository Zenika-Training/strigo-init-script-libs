#!/bin/bash


# https://github.com/nvm-sh/nvm

# Define NVM_DIR before cf. install.sh nvm script
export NVM_DIR="/home/ubuntu/.nvm" && mkdir -p $NVM_DIR && chown ubuntu $NVM_DIR

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.37.2/install.sh | bash

# Append to ubuntu profile
echo 'export NVM_DIR="$HOME/.nvm"' >> /home/ubuntu/.bashrc
echo '[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm' >> /home/ubuntu/.bashrc

# Dot source the files to ensure that variables are available within the current shell
. /home/ubuntu/.nvm/nvm.sh
. /home/ubuntu/.profile
. /home/ubuntu/.bashrc

# Install node lts
nvm install --lts
