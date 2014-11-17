#!/bin/bash

# check arguments
case "$1" in

-h)	echo -e "\nNAME"
	echo -e "\tmake_rabe-server\n"
	echo "SYNOPSIS"
	echo -e "\t./make_rabe-server [-f ISO file]\n"
	echo "DESCRIPTION"
	echo -e "\tCreate Remote Acquisition Boot Environment (RABE) server installation ISO.\n"
	echo -e "\t[-f ISO file]"
	echo -e "\t\tmanual Ubuntu Server x86_64 installation ISO input\n"
	exit
	;;
-f)	echo -e "\n[make_rabe-server] STARTED (manual)"
	echo "[make_rabe-server] USING $2"
	ISOSRC=$2
	;;
*)	echo -e "\n[make_rabe-server] STARTED (automatic)"
	if [ -e images/ubuntu-14.04.1-server-amd64.iso ]; then
		echo "[make_rabe-server] USING ubuntu-14.04.1-server-amd64.iso"
	else
		echo -e "[make_rabe-server] DOWNLOADING AND USING ubuntu-14.04.1-server-amd64.iso\n\n"
		mkdir -p images/
		wget --directory-prefix=images/ http://releases.ubuntu.com/14.04.1/ubuntu-14.04.1-server-amd64.iso
	fi
	ISOSRC=images/ubuntu-14.04.1-server-amd64.iso
	;;
esac

SELECTION=""

# check selection
while [ "$SELECTION" != "Q" ]; do
	echo -e "\nSelect one of the following options:"
	echo "[1] Create basic RABE server installation ISO"
	echo -e "[Q] Quit\n"
	
	read SELECTION
	
	case $SELECTION in
	
	1)	source scripts/authoring/rabe-server_basic.sh
		SELECTION="Q"
		break
		;;
	Q)	break
		;;
	*)	echo "Invalid selection! Please try again."
		;;
	esac
done

echo -e "\n[make_rabe-server] ENDED\n"