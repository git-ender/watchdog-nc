#!/usr/bin/env bash

LAUNCHERNAME=$(basename -- "$0")
DIRNAME=$(dirname -- "$0")
SCRIPTNAME=${LAUNCHERNAME%_*}.sh

function usage {
	echo ""
	echo "Usage of $LAUNCHERNAME"
	echo ""
	echo "Use $LAUNCHERNAME -d to launch in daemon mode"
	echo "Use $LAUNCHERNAME -C to launch in console mode"
	echo ""
}

# check that command swith are set
if [ -z $1 ] ; then
	usage
	exit 1
fi

if [[ $EUID -ne 0 ]]; then
	echo "Please run this script with root permission" 
	exit 1
fi

case $1 in
	-d) echo "Launching script as deamon"
	    nohup $DIRNAME/$SCRIPTNAME 0<&- &>/dev/null &
	    ;;
	-C) echo "Launching script in DEBUG mode."
            $DIRNAME/$SCRIPTNAME
	    ;;
        *)  usage 
	    ;;
esac
