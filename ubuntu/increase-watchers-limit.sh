#!/bin/bash

# Increase filesystem watches for `autoreload` (https://www.npmjs.com/package/autoreload#troubleshooting)
echo fs.inotify.max_user_watches=524288 | tee -a /etc/sysctl.conf
sysctl -p
