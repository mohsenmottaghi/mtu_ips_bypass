#!/bin/bash
# Bypass IPSs with Packet Fragmentation | Developed by MOHSEN
BANNER='BIPF	|	Version 1.1	|	MOHSEN MOTTAGHI		twitter.com/motmohsen'
PATH='/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin'
DEVICE=`ip route list | grep default | awk '{print $5}'`

debian_base() {
	if [ ! -f "/tmp/cloudflared-stable-linux-amd64.deb" ]
		then			
			echo '[+] Start downloading files. Please wait ...'
			wget -P /tmp -o /dev/null https://bin.equinox.io/c/VdrWdbjqyF/cloudflared-stable-linux-amd64.deb
			echo '[+] Done.'
		else
			echo '[-] File Found successfully :)'
	fi

	if ! [ -x "$(command -v cloudflared)" ]
		then
			echo '[+] Start Installing .deb package.'
			sudo dpkg -i /tmp/cloudflared-stable-linux-amd64.deb
			echo '[+] Done.'
	fi
}

start() {
	sudo cloudflared proxy-dns &
	sudo cp /etc/resolv.conf /tmp/resolv.conf && sudo echo 'nameserver 127.0.0.1' > /etc/resolv.conf
	sudo ip link set dev $DEVICE mtu 400
}

stop() {
	echo '[+] Try to stop service and set default values'
	sudo ip link set dev $DEVICE mtu 1400
	sudo cp /tmp/resolv.conf /etc/resolv.conf
	sudo kill -15 `ps aux |grep "cloudflared proxy-dns" | grep -v grep | awk '{print $2}'`
	echo '[+] Done.'	
}

uninstall() {
	stop && echo 'unistall packages.'
	sudo dpkg --remove cloudflared
	echo '[+] Done.'
}

help() {
	echo -e 'Welcome to m-bipf\n' $BANNER
	echo -e '\nHelp:\n'
	echo ' 		start 	  , --start 		Try to start service'
	echo '		stop 	  , --stop 		For stop network setting to original setting'  
	echo '		install   , --install 		For installing tools and configure network'
	echo ' 		uninstall , --uninstall 	For uninstall DNS over HTTPS software'
}

main_func() {
	case `lsb_release -i |cut -f 2` in
	
		'Ubuntu' | 'Kali')
			if [ "`lsb_release -r |cut -f 2`" == "18.04" ] | [ "`lsb_release -r |cut -f 2`" == "2019.2" ]
			then
				debian_base && start
			else
				echo 'We don`t support now, you can develop and ...'
			fi
			;;
		*)
			echo 'We don`t support now, you can develop and ...'
			;;
	esac
}

case $1 in

	'install' | '--install' )
		main_func && start && exit
		;;
	'uninstall' | '--uninstall')
		uninstall && exit
		;;
	'stop' | '--stop')
		stop && exit		
		;;
	'start' | '--start')
		start && exit		
		;;
	*)
		help && exit
		;;
esac
