#/bin/bash
clear
if [ $(id -u) -eq 0 ]
then
	clear
else
	if echo $(id) |grep sudo > /dev/null
	then
	clear
	echo -e "\033[1;37mVoce não é root"
	echo -e "\033[1;37mSeu usuario esta no grupo sudo"
	echo -e "\033[1;37mPara virar root execute \033[1;31msudo su\033[1;37m ou execute \033[1;31msudo $0\033[0m"
	exit
	else
	clear
	echo -e "Vc nao esta como usuario root, nem com seus direitos (sudo)\nPara virar root execute \033[1;31msu\033[0m e digite sua senha root"
	exit
	fi
cat -n /etc/issue |grep 1 |cut -d' ' -f6,7,8 |sed 's/1//' |sed 's/	//' > /etc/so 
echo -e "\033[1;31mPara a instalação ser correta é preciso o ip.
Digite o ip !\033[0m"
read -p ": " ip
echo -e "\033[1;31mSe usar um DNS ao invés de IP escreva agora.
Escreve o dns !\033[0m"
read -p ": " dns
echo -e "\033[1;31mDe um nome ao Servidor
Digite o nome !\033[0m"
read -p ": " nome
clear

echo -e "\033[1;31m-----> \033[01;37mSeu sistema operacional:\033[1;31m $(cat /etc/so)"
echo -e "\033[1;31m-----> \033[01;37mSeu ip:\033[1;31m $ip"
echo -e "\033[1;31m-----> \033[1;37mSQUID NAS PORTAS:\033[1;31m 80, 8080, 8799 e 3128\033[0m"
echo -e "\033[1;31m-----> \033[1;37mSSH NAS PORTAS: \033[1;31m143 e 22\033[0m"
echo -e "\033[1;31m-----> \033[1;37mSSH NOS IPS: \033[1;31m$ip, localhost e 127.0.0.1\033[0m"


function sshd_config(){ echo "Port 22
Port 143
Protocol 2
KeyRegenerationInterval 3600
ServerKeyBits 1024
SyslogFacility AUTH
LogLevel INFO
LoginGraceTime 120
PermitRootLogin yes
StrictModes yes
RSAAuthentication yes
PubkeyAuthentication yes
IgnoreRhosts yes
RhostsRSAAuthentication no
HostbasedAuthentication no
PermitEmptyPasswords no
ChallengeResponseAuthentication no
PasswordAuthentication yes
X11Forwarding yes
X11DisplayOffset 10
PrintMotd no
PrintLastLog yes
TCPKeepAlive yes
#UseLogin no
AcceptEnv LANG LC_*
Subsystem sftp /usr/lib/openssh/sftp-server
UsePAM yes
GatewayPorts yes
AllowTcpForwarding yes
PermitTunnel yes
Compression yes" > /etc/ssh/sshd_config

}

function addhost(){ echo '#!/bin/bash
echo "Qual host deseja adicionar ?"
read -p ": " host
echo "$host" >> /etc/payloads
squid -k reconfigure > /dev/null 2> /dev/null
squid3 -k reconfigure > /dev/null 2> /dev/null
echo "$host Adicionado" ' > /bin/addhost
chmod a+x /bin/addhost
}

function payloads(){ echo "
echo "
.bookclaro.com.br
.claro.com.ar
.claro.com.br
.claro.com.co
.claro.com.ec
.claro.com.gt
.claro.com.ni
.claro.com.pe
.claro.com.sv
.claro.cr
.clarocurtas.com.br
.claroideas.com
.claroideias.com.br
.claromusica.com
.clarosomdechamada.com.br
.clarovideo.com
.facebook.net
.netclaro.com.br
.oi.com.br
.oimusica.com.br
.speedtest.net
.tim.com.br
.timanamaria.com.br
.vivo.com.br
.ddivulga.com
.clarosomdechamada.com.br
.bradescocelular.com.br
" > /etc/payloads
}

if cat /etc/so |grep -i ubuntu |grep 16 1> /dev/null 2> /dev/null ; then
echo -e "\033[1;37mConfigurando, Aguarde...\033[0m"
apt-get update 1> /dev/null 2> /dev/null
apt-get install -y squid3 1> /dev/null 2> /dev/null
rm /etc/squid3/accept
touch /etc/squid3/payloads
rm /etc/squid3/block
chattr -i /etc/ssh/sshd_config > /dev/null 2> /dev/null
sshd_config
service ssh restart 1> /dev/null 2> /dev/null

echo "
############
#NERDOLOGIA VPS
#by: ColtSeals
############

#PORTAS DE ACESSO NO SQUID
http_port $dns:80
http_port $dns:8080
#http_port 8799
#http_port 3128

# Nome visivel da VPS
visible_hostname $nome|R3V1V3RVPS

###Anonimato do PROXY SQUID
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

# ACL DE CONEXAO
acl local dstdomain localhost
acl iplocal dstdomain 127.0.0.1
acl accept src $ip
acl ip url_regex -i $ip" > /etc/squid/squid.conf
echo 'acl hosts dstdomain -i "/etc/payloads"
acl SSL_ports port 22
acl SSL_ports port 80
acl SSL_ports port 143
acl SSL_ports port 443
acl Safe_ports port 80          # http
acl Safe_ports port 21          # ftp
acl Safe_ports port 443         # https
acl Safe_ports port 70          # gopher
acl Safe_ports port 210         # wais
acl Safe_ports port 1025-65535  # unregistered ports
acl Safe_ports port 280         # http-mgmt
acl Safe_ports port 488         # gss-http
acl Safe_ports port 591         # filemaker
acl Safe_ports port 777         # multiling http
acl CONNECT method CONNECT

# CACHE DO SQUID
cache_mem 256 MB
maximum_object_size_in_memory 32 KB
maximum_object_size 1024 MB
minimum_object_size 0 KB
cache_swap_low 90
cache_swap_high 95
cache_dir ufs /var/spool/squid3 30 16 256
access_log /var/log/squid3/access.log squid
cache_log /var/log/squid3/cache.log
cache_store_log /var/log/squid3/store.log
pid_filename /var/log/squid3/squid3.pid
mime_table /usr/share/squid3/mime.conf
cache_effective_user proxy
cache_effective_group proxy

# ACESSOS ACL
http_access allow local
http_access allow iplocal
http_access allow accept
http_access allow ip
http_access allow hosts
http_access allow CONNECT !SSL_ports
http_access deny !Safe_ports
http_access deny CONNECT
http_access deny all
cache deny all' >> /etc/squid/squid.conf

addhost

echo -e "\033[1;37mPara adicionar novos hosts ao squid execute o comando addhost
os hosts ficam no arquivo /etc/payloads\033[0m"
payloads
service squid restart 1> /dev/null 2> /dev/null

echo -e "\033[01;31mTudo terminado crie um usuario e teste !!\033[0m"
exit 0
fi

if cat /etc/so |grep -i ubuntu 1> /dev/null 2> /dev/null ; then
echo -e "\033[1;37mConfigurando, Aguarde...\033[0m"
apt-get update 1> /dev/null 2> /dev/null
apt-get install -y squid3 1> /dev/null 2> /dev/null

service apache2 stop 1> /dev/null 2> /dev/null
chattr -i /etc/ssh/sshd_config > /dev/null 2> /dev/null
sshd_config
service ssh restart 1> /dev/null 2> /dev/null

echo "
############
#NERDOLOGIA VPS
#by: ColtSeals
############

#PORTAS DE ACESSO NO SQUID
http_port $dns:80
http_port $dns:8080
#http_port 8799
#http_port 3128

# Nome visivel da VPS
visible_hostname $nome|R3V1V3RVPS

###Anonimato do PROXY SQUID
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

# ACL DE CONEXAO
acl local dstdomain localhost
acl iplocal dstdomain 127.0.0.1
acl accept src $ip
acl ip url_regex -i $ip" > /etc/squid/squid.conf
echo 'acl hosts dstdomain -i "/etc/payloads"
acl SSL_ports port 22
acl SSL_ports port 80
acl SSL_ports port 143
acl SSL_ports port 443
acl Safe_ports port 80          # http
acl Safe_ports port 21          # ftp
acl Safe_ports port 443         # https
acl Safe_ports port 70          # gopher
acl Safe_ports port 210         # wais
acl Safe_ports port 1025-65535  # unregistered ports
acl Safe_ports port 280         # http-mgmt
acl Safe_ports port 488         # gss-http
acl Safe_ports port 591         # filemaker
acl Safe_ports port 777         # multiling http
acl CONNECT method CONNECT

# CACHE DO SQUID
cache_mem 256 MB
maximum_object_size_in_memory 32 KB
maximum_object_size 1024 MB
minimum_object_size 0 KB
cache_swap_low 90
cache_swap_high 95
cache_dir ufs /var/spool/squid3 30 16 256
access_log /var/log/squid3/access.log squid
cache_log /var/log/squid3/cache.log
cache_store_log /var/log/squid3/store.log
pid_filename /var/log/squid3/squid3.pid
mime_table /usr/share/squid3/mime.conf
cache_effective_user proxy
cache_effective_group proxy

# ACESSOS ACL
http_access allow local
http_access allow iplocal
http_access allow accept
http_access allow ip
http_access allow hosts
http_access allow CONNECT !SSL_ports
http_access deny !Safe_ports
http_access deny CONNECT
http_access deny all
cache deny all' >> /etc/squid3/squid.conf
payloads
service squid3 restart 1> /dev/null 2> /dev/null
addhost

echo -e "\033[1;37mPara adicionar novos hosts ao squid execute o comando addhost
os hosts ficam no arquivo /etc/payloads\033[0m"
echo -e "\033[01;31mTudo terminado crie um usuario e teste !! \033[0m"
exit 0
fi

if cat /etc/so |grep -i centos 1> /dev/null 2> /dev/null ; then
echo -e "\033[01;37mConfigurando, Aguarde...\033[0m"
yum -y update 1> /dev/null 2> /dev/null
yum install -y squid 1> /dev/null 2> /dev/null

service httpd stop 1> /dev/null 2> /dev/null
chattr -i /etc/ssh/sshd_config > /dev/null 2> /dev/null
sshd_config
service sshd restart 1> /dev/null 2> /dev/null

echo "' >> /etc/squid/squid.conf
payloads
service squid restart 1> /dev/null 2> /dev/null
addhost

echo -e "\033[1;37mPara adicionar novos hosts ao squid execute o comando addhost
os hosts ficam no arquivo /etc/payloads\033[0m"
echo -e "\033[01;31mTudo terminado crie um usuario e teste !! \033[0m"
exit
fi

if cat /etc/so |grep -i debian 1> /dev/null 2> /dev/null ; then
echo -e "\033[01;37mConfigurando, Aguarde...\033[0m"
apt-get update 1> /dev/null 2> /dev/null
apt-get install -y squid3 1> /dev/null 2> /dev/null
service apache2 stop 1> /dev/null 2> /dev/null
chattr -i /etc/ssh/sshd_config > /dev/null 2> /dev/null
sshd_config

service ssh restart 1> /dev/null 2> /dev/null

echo "
############
#NERDOLOGIA VPS
#by: ColtSeals
############

#PORTAS DE ACESSO NO SQUID
http_port $dns:80
http_port $dns:8080
#http_port 8799
#http_port 3128

# Nome visivel da VPS
visible_hostname $nome|R3V1V3RVPS

###Anonimato do PROXY SQUID
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

# ACL DE CONEXAO
acl local dstdomain localhost
acl iplocal dstdomain 127.0.0.1
acl accept src $ip
acl ip url_regex -i $ip" > /etc/squid/squid.conf
echo 'acl hosts dstdomain -i "/etc/payloads"
acl SSL_ports port 22
acl SSL_ports port 80
acl SSL_ports port 143
acl SSL_ports port 443
acl Safe_ports port 80          # http
acl Safe_ports port 21          # ftp
acl Safe_ports port 443         # https
acl Safe_ports port 70          # gopher
acl Safe_ports port 210         # wais
acl Safe_ports port 1025-65535  # unregistered ports
acl Safe_ports port 280         # http-mgmt
acl Safe_ports port 488         # gss-http
acl Safe_ports port 591         # filemaker
acl Safe_ports port 777         # multiling http
acl CONNECT method CONNECT

# CACHE DO SQUID
cache_mem 256 MB
maximum_object_size_in_memory 32 KB
maximum_object_size 1024 MB
minimum_object_size 0 KB
cache_swap_low 90
cache_swap_high 95
cache_dir ufs /var/spool/squid3 30 16 256
access_log /var/log/squid3/access.log squid
cache_log /var/log/squid3/cache.log
cache_store_log /var/log/squid3/store.log
pid_filename /var/log/squid3/squid3.pid
mime_table /usr/share/squid3/mime.conf
cache_effective_user proxy
cache_effective_group proxy

# ACESSOS ACL
http_access allow local
http_access allow iplocal
http_access allow accept
http_access allow ip
http_access allow hosts
http_access allow CONNECT !SSL_ports
http_access deny !Safe_ports
http_access deny CONNECT
http_access deny all
cache deny all' >> /etc/squid3/squid.conf
payloads
service squid3 restart 1> /dev/null 2> /dev/null
addhost

echo -e "\033[1;37mPara adicionar novos hosts ao squid execute o comando addhost
os hosts ficam no arquivo /etc/payloads\033[0m"
echo -e "\033[01;31mTudo terminado crie um usuario e teste !! \033[0m"
exit 0
fi

if cat /etc/issue |grep -i kernel 1> /dev/null 2> /dev/null ; then
echo -e "\033[01;31mConfigurando, Aguarde...\033[0m"
yum -y update 1> /dev/null 2> /dev/null
yum install -y squid 1> /dev/null 2> /dev/null

service httpd stop 1> /dev/null 2> /dev/null
chattr -i /etc/ssh/sshd_config > /dev/null 2> /dev/null
sshd_config
service sshd restart 1> /dev/null 2> /dev/null

echo "
############
#NERDOLOGIA VPS
#by: ColtSeals
############

#PORTAS DE ACESSO NO SQUID
http_port $nome:80
http_port $nome:8080
#http_port 8799
#http_port 3128

# Nome visivel da VPS
visible_hostname $nome|R3V1V3RVPS

###Anonimato do PROXY SQUID
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

# ACL DE CONEXAO
acl local dstdomain localhost
acl iplocal dstdomain 127.0.0.1
acl accept src $ip
acl ip url_regex -i $ip" > /etc/squid/squid.conf
echo 'acl hosts dstdomain -i "/etc/payloads"
acl SSL_ports port 22
acl SSL_ports port 80
acl SSL_ports port 143
acl SSL_ports port 443
acl Safe_ports port 80          # http
acl Safe_ports port 21          # ftp
acl Safe_ports port 443         # https
acl Safe_ports port 70          # gopher
acl Safe_ports port 210         # wais
acl Safe_ports port 1025-65535  # unregistered ports
acl Safe_ports port 280         # http-mgmt
acl Safe_ports port 488         # gss-http
acl Safe_ports port 591         # filemaker
acl Safe_ports port 777         # multiling http
acl CONNECT method CONNECT

# CACHE DO SQUID
cache_mem 256 MB
maximum_object_size_in_memory 32 KB
maximum_object_size 1024 MB
minimum_object_size 0 KB
cache_swap_low 90
cache_swap_high 95
cache_dir ufs /var/spool/squid3 30 16 256
access_log /var/log/squid3/access.log squid
cache_log /var/log/squid3/cache.log
cache_store_log /var/log/squid3/store.log
pid_filename /var/log/squid3/squid3.pid
mime_table /usr/share/squid3/mime.conf
cache_effective_user proxy
cache_effective_group proxy

# ACESSOS ACL
http_access allow local
http_access allow iplocal
http_access allow accept
http_access allow ip
http_access allow hosts
http_access allow CONNECT !SSL_ports
http_access deny !Safe_ports
http_access deny CONNECT
http_access deny all
cache deny all' >> /etc/squid/squid.conf
payloads
service squid restart 1> /dev/null 2> /dev/null
addhost

echo -e "\033[1;37mPara adicionar novos hosts ao squid execute o comando addhost
os hosts ficam no arquivo /etc/payloads\033[0m"
echo -e "\033[01;31mTudo terminado crie um usuario e teste !! \033[0m"
exit
fi

echo -e "\033[01;31mConfigurando, Aguarde...\033[0m"

yum -y update 1> /dev/null 2> /dev/null
yum install -y squid 1> /dev/null 2> /dev/null
apt-get update > /dev/null 2> /dev/null
apt-get install -y squid3 > /dev/null 2>/dev/null
service httpd stop 1> /dev/null 2> /dev/null
service apache2 stop >/dev/null 2> /dev/null
chattr -i /etc/ssh/sshd_config > /dev/null 2> /dev/null
sshd_config
service sshd restart 1> /dev/null 2> /dev/null
service ssh restart > /dev/null 2> /dev/null
echo "
############
#NERDOLOGIA VPS
#by: ColtSeals
############

#PORTAS DE ACESSO NO SQUID
http_port $nome:80
http_port $nome:8080
#http_port 8799
#http_port 3128

# Nome visivel da VPS
visible_hostname $nome|R3V1V3RVPS

###Anonimato do PROXY SQUID
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

# ACL DE CONEXAO
acl local dstdomain localhost
acl iplocal dstdomain 127.0.0.1
acl accept src $ip
acl ip url_regex -i $ip" > /etc/squid/squid.conf
echo 'acl hosts dstdomain -i "/etc/payloads"
acl SSL_ports port 22
acl SSL_ports port 80
acl SSL_ports port 143
acl SSL_ports port 443
acl Safe_ports port 80          # http
acl Safe_ports port 21          # ftp
acl Safe_ports port 443         # https
acl Safe_ports port 70          # gopher
acl Safe_ports port 210         # wais
acl Safe_ports port 1025-65535  # unregistered ports
acl Safe_ports port 280         # http-mgmt
acl Safe_ports port 488         # gss-http
acl Safe_ports port 591         # filemaker
acl Safe_ports port 777         # multiling http
acl CONNECT method CONNECT

# CACHE DO SQUID
cache_mem 256 MB
maximum_object_size_in_memory 32 KB
maximum_object_size 1024 MB
minimum_object_size 0 KB
cache_swap_low 90
cache_swap_high 95
cache_dir ufs /var/spool/squid3 30 16 256
access_log /var/log/squid3/access.log squid
cache_log /var/log/squid3/cache.log
cache_store_log /var/log/squid3/store.log
pid_filename /var/log/squid3/squid3.pid
mime_table /usr/share/squid3/mime.conf
cache_effective_user proxy
cache_effective_group proxy

# ACESSOS ACL
http_access allow local
http_access allow iplocal
http_access allow accept
http_access allow ip
http_access allow hosts
http_access allow CONNECT !SSL_ports
http_access deny !Safe_ports
http_access deny CONNECT
http_access deny all
cache deny all' >> /etc/squid*/squid.conf
payloads
service squid restart 1> /dev/null 2> /dev/null
service squid3 restart > /dev/null 2> /dev/null
addhost
echo -e "\033[1;37mPara adicionar novos hosts ao squid execute o comando addhost
os hosts ficam no arquivo /etc/payloads\033[0m"
echo -e "\033[01;31mTudo terminado crie um usuario e teste !! \033[0m"
