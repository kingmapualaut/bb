#!/bin/bash

yum install -y squid httpd-tools
chkconfig squid on
# Copy config from github
curl -o /etc/squid/squid.conf https://raw.githubusercontent.com/kingmapualaut/bb/master/Cen7/squid.conf
# Add user
htpasswd -bc /etc/squid/.htpasswd user $PROXY_PASS
systemctl start squid
systemctl status squid
