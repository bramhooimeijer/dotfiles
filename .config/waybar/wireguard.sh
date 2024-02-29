#!/bin/sh

STATUS_CONNECTED_STR='{"text":"Connected","class":"connected","percentage":100}'
STATUS_DISCONNECTED_STR='{"text":"Disconnected","class":"disconnected","percentage":0}'

function askpass() {
	foot -a ffloat bash -c '/usr/bin/systemd-ask-password | wl-copy'
	wl-paste
}


function status_wireguard() {
	nmcli -f TYPE connection show --active | grep -q wireguard
}

function toggle_wireguard() {
	SUDO_ASKPASS=$0 sudo -A ls /etc/wireguard | grep '.conf$' | sed 's/.conf$//' | fzf
}


case $1 in
	-s | --status)
		status_wireguard && echo $STATUS_CONNECTED_STR || echo $STATUS_DISCONNECTED_STR
	;;
	-t | --toggle)
		toggle_wireguard
	;;
	*)
		askpass
	;;
esac
