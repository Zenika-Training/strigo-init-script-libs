#!/usr/bin/env sh

# Define these optional variables if you want to customize the default installation,
# then copy-paste the remainder of the script:
# - the port of the HTTP server (defaults to 9997)
# http_server_port=9997

apt-get update
apt-get install -y --no-install-recommends python3

sudo -u ubuntu mkdir --parent ~ubuntu/public/

# Create, enable and start http server service
cat << EOF > /lib/systemd/system/http-server@.service
[Unit]
Description=Simple static public web server
After=network.target

[Service]
Type=exec
ExecStart=/usr/bin/python3 -m http.server ${http_server_port:-9997} --directory /home/%i/public/
Restart=always
User=%i

[Install]
WantedBy=default.target
EOF
systemctl enable --now http-server@ubuntu
