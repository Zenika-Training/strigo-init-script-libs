#!/usr/bin/env sh

# Create a simple static public web server
# ----------------------------------------------------------------------------------------------------

apt-get update
apt-get install -y nginx
usermod -a -G www-data ubuntu
chown -R ubuntu:www-data /var/www
chmod 2775 /var/www
find /var/www -type d -exec chmod 2775 {} \;
find /var/www -type f -exec chmod 0664 {} \;
ln -s /var/www/html /home/ubuntu/www
