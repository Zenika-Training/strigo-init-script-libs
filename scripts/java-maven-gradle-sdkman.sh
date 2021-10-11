#!/bin/bash

apt-get update
apt-get purge default-jdk java-common
apt-get install -y curl zip

# Define these 3 optional variables if you want to customize the default installation,
# then copy-paste the remainder of the script:
java_version=17.0.0-tem
mvn_version=3.8.3
gradle_version=7.2

# https://sdkman.io/install
# Run install with ubuntu user
sudo -H -u ubuntu bash <<EOF
curl -s "https://get.sdkman.io" | bash
source "/home/ubuntu/.sdkman/bin/sdkman-init.sh"
sdk install java $java_version
sdk install maven $mvn_version
sdk install gradle $gradle_version
EOF

# Force restart tmux session to reload env variable
killall -9 /home/ubuntu/.strigo/tmux
