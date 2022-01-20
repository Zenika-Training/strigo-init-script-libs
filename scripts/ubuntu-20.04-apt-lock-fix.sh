#!/bin/bash

# Remove unattended-upgrades to avoid conflicts with apt running twice
apt-get remove -y unattended-upgrades
