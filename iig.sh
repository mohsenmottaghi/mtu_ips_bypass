#!/bin/bash
# Developed by MOHSEN

echo 'Welcome to Iran Internet Ghost'

BANNER='IIG	|	Version 1.0	|	MOHSEN MOTTAGHI		twitter.com/motmohsen'
DISTRO=`lsb_release -i |cut -f 2`
DISTRO_RELEASE=`lsb_release -r |cut -f 2`
FILE_DNS_SERVER='/tmp/cloudflared-stable-linux-amd64.deb'

function debian_base {
	if [ ! -f "$FILE_DNS_SERVER" ]
		then			
			echo '[+] Start downloading files'
			echo '[+] Please wait ...'
			wget -P /tmp -o /dev/null https://bin.equinox.io/c/VdrWdbjqyF/cloudflared-stable-linux-amd64.deb
			echo '[+] Done.'
		else
			echo '[-] File Found successfully :)'
	fi

	if ! [ -x "$(command -v cloudflared)" ]
		then
			echo '[+] Start Installing'
			dpkg -i /tmp/cloudflared-stable-linux-amd64.deb
			echo '[+] Done.'
	fi
}

function start_dns_server {
	cloudflared proxy-dns &
	cp /etc/resolv.conf /tmp/resolv.conf
	echo 'nameserver 127.0.0.1' > /etc/resolv.conf
}

function setup_network {
	DEVICE=`ip route list | grep default | awk '{print $5}'`
	ip link set dev $DEVICE mtu 400
}

function recovery {
	echo '[+] Start to Recovery'
	DEVICE=`ip route list | grep default | awk '{print $5}'`
	ip link set dev $DEVICE mtu 1400
	cp /tmp/resolv.conf /etc/resolv.conf
	echo '[+] Done.'	
}

function uninstall {
	echo '[+] Start unistall packages.'
	dpkg --remove cloudflared
	echo '[+] Done'
}

function help {
	echo $BANNER
	echo 'Help:'
	echo '		--help , -h , help		For show help of shell script'
	echo '		 '
	echo '		install   , --install		For installing tools and configure network'
	echo ' 		ghost 	  , --ghost		same function as "install"'
	echo ' 		uninstall , --unistall		For uninstall DNS over HTTPS software'
	echo '		recovery  , --recovery		For recovery network setting to original setting'  
}

function main {
	case $DISTRO in
	
		'Ubuntu')
			echo '[+] You will be a Ghost after a while :)'
			debian_base
			start_dns_server
			setup_network
			;;
		*)
			echo 'We don`t support now, you can develop and ...'
			exit
			;;
	esac
}

case $1 in

	'install' | 'ghost' | '--install' | '--ghost' )
		main
		exit
		;;

	'uninstall' | '--unistall')
		uninstall
		exit
		;;

	'recovery' | '--recovery')
		recovery
		exit		
		;;

	* | '--help' | '-h' | 'help')
		help
		exit
		;; 

esac
