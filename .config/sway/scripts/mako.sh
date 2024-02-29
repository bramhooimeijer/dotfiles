#!/bin/sh

STATUS_DND_ENABLED_STR='{"text":"Do Not Disturb","class":"notifications-off","percentage":0, "tooltip":"Notifications Disabled (DND)"}'
STATUS_DND_DISABLED_STR='{"text":"Notifications On","class":"notifications-on","percentage":100, "tooltip":"Notifications Enabled"}'

function status_dnd() {
	makoctl mode | grep -q dnd
}

function enable_dnd() {
	makoctl mode -a dnd > /dev/null && print_status
}

function disable_dnd() {
	makoctl mode -r dnd > /dev/null && print_status
}

function print_status() {
	status_dnd && echo $STATUS_DND_ENABLED_STR || echo $STATUS_DND_DISABLED_STR
}


case $1 in
	-s | --status)
		print_status
	;;
	-d | --dnd | --notifications-off)
		enable_dnd
	;;
	-n | --dnd-off | --notifications-on)
		disable_dnd
	;;
	-t | --toggle)
		status_dnd && disable_dnd || enable_dnd
	;;
	*)

	;;
esac

