#!/bin/sh
# Created by https://www.hostingtermurah.net
# Modified by 0123456

#Requirement
if [ ! -e /usr/bin/curl ]; then
    apt-get -y update && apt-get -y upgrade
	apt-get -y install curl
fi
# initializing var
export DEBIAN_FRONTEND=noninteractive
OS=`uname -m`;
MYIP=$(curl -4 icanhazip.com)
if [ $MYIP = "" ]; then
   MYIP=`ifconfig | grep 'inet addr:' | grep -v inet6 | grep -vE '127\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | cut -d: -f2 | awk '{ print $1}' | head -1`;
fi
MYIP2="s/xxxxxxxxx/$MYIP/g";

# go to root
cd

# install squid3
apt-get -y install squid
cat > /etc/squid/squid.conf <<-END
acl manager proto cache_object
acl localhost src 127.0.0.1/32 ::1
acl to_localhost dst 127.0.0.0/8 0.0.0.0/32 ::1
acl localnet src 192.168.99.0/24
acl checker src 203.92.128.158
acl SSL_ports port 443
acl Safe_ports port 80		# http
acl Safe_ports port 21		# ftp
acl Safe_ports port 443		# https
acl Safe_ports port 70		# gopher
acl Safe_ports port 210		# wais
acl Safe_ports port 1025-65535	# unregistered ports
acl Safe_ports port 280		# http-mgmt
acl Safe_ports port 488		# gss-http
acl Safe_ports port 591		# filemaker
acl Safe_ports port 777		# multiling http
acl CONNECT method CONNECT
acl HEAD method HEAD
acl terlarang url_regex -i "/etc/squid3/terlarang.txt"
acl DOMAIN dstdomain musiccssg.digi.com.my facebook.com p1.com.my mini5-5.opera-mini.net weixin.qq.com v1.hotlink.com.my torrent.bitchdeezer.info era.fm p85.bitchdeezer.info p1.bitchdeezer.info p2.bitchdeezer.info p3.bitchdeezer.info p4.bitchdeezer.info p26.bitchdeezer.info n1.bitchdeezer.info n2.bitchdeezer.info n3.bitchdeezer.info 
http_access deny terlarang
http_access allow all
http_access deny all
acl all src 0.0.0.0/0
http_access allow all
http_access allow localnet
http_access allow localhost

http_port 8888
http_port 8080
http_port 8000
http_port 80
http_port 3128
## header list ( DENY all -> ALLOW only listed )
via off
forwarded_for off
request_header_access Allow allow all 
request_header_access Authorization allow all 
request_header_access WWW-Authenticate allow all 
request_header_access Proxy-Authorization allow all 
request_header_access Proxy-Authenticate allow all 
request_header_access Cache-Control allow all 
request_header_access Content-Encoding allow all 
request_header_access Content-Length allow all 
request_header_access Content-Type allow all 
request_header_access Date allow all 
request_header_access Expires allow all 
request_header_access Host allow all 
request_header_access If-Modified-Since allow all 
request_header_access Last-Modified allow all 
request_header_access Location allow all 
request_header_access Pragma allow all 
request_header_access Accept allow all 
request_header_access Accept-Charset allow all 
request_header_access Accept-Encoding allow all 
request_header_access Accept-Language allow all 
request_header_access Content-Language allow all 
request_header_access Mime-Version allow all 
request_header_access Retry-After allow all 
request_header_access Title allow all 
request_header_access Connection allow all 
request_header_access Proxy-Connection allow all 
request_header_access User-Agent allow all 
request_header_access Cookie allow all 
request_header_access All deny all
visible_hostname musiccssg.digi.com.my
cache_mgr radhsyn@smk2nba.sch.id

cache_effective_user proxy
cache_mem 16 MB
maximum_object_size 10240 KB

minimum_object_size 8 KB
maximum_object_size_in_memory 16 KB
cache_dir ufs /var/spool/squid 10000 16 256
END
sed -i $MYIP2 /etc/squid/squid.conf;
service squid restart

wget https://gitlab.com/azli5083/debian8/raw/master/googlecloud && bash googlecloud && rm googlecloud
