#!/bin/bash

# increase watchers limit to 524288
echo fs.inotify.max_user_watches=524288 | sudo tee -a /etc/sysctl.conf
sudo sysctl -p