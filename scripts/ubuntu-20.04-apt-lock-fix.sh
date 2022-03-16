#!/bin/bash

# Setup lock waiting in dpkg (15 minutes timeout instead of 0)
echo 'DPkg::Lock::Timeout "900";' > /etc/apt/apt.conf.d/99-dpkg-timeout

# Remove unattended-upgrades to avoid conflicts with apt running twice
apt-get remove -y unattended-upgrades
