#!/usr/bin/env bash

STATUS=0
SCRIPTNAME=$(basename -- "$0")
SCRIPTNAME="${SCRIPTNAME%.*}"

source $(dirname $0)/$SCRIPTNAME.cfg

function tee_log {
	tee -a $WATCHDOG_LOG_FILE
	}

# check mail is installed
if  [ ! $(which mail) ] ; then
	echo "[$(date "+%FT%T")] No compatible mail client is installed or present in PATH. Exiting" | tee_log
        echo "Please install mailx or mailutils" | tee_log
	exit 2
fi

echo "[$(date "+%FT%T")] Launching watchdog for $MYSERVICE" | tee_log

while true ; do

	RESTART=0
	# check service status
	service $MYSERVICE status  > /dev/null 2>&1
	STATUS=$?
       	
	# check if service is present
	if [[ $STATUS -eq 4 ]] ; then
		echo "Service $MYSERVICE is not installed or script misconfigured. Exiting, please check and rerun script"  | tee_log
		exit 2
	elif [[ $STATUS -ne 0 ]] ; then 
		FAIL_DATE=$(date "+%FT%T")
		# trying restart
		for i in $(seq 1 $MAX_RETRY) ; do
               		echo -n "[$(date "+%FT%T")] Service $MYSERVICE is down. Trying to restart, trying # $i... " | tee_log
			if service $MYSERVICE start > /dev/null 2>&1 ; then
				echo "Success." | tee_log 
				RESTART=1
				break
			else
				echo "Failed" | tee_log
				sleep "$RETRY_INTERVAL"
			fi
        	done
		if [[ $RESTART -eq 1 ]] ; then 
			# service is running again, hurray
			echo "Service $MYSERVICE went down at [$FAIL_DATE] but it has been restarted after $i retries" | tee_log 
			echo "Service $MYSERVICE went down at [$FAIL_DATE] but it has been restarted after $i retries" | mail -s "[$HOSTNAME] Service $MYSERVICE restarted" $RECIPIENT
		else
			# no way to restart, exiting script
			echo "Service $MYSERVICE went down at [$FAIL_DATE] and it could not be restart after $MAX_RETRY tries" | tee_log 
			echo "Service $MYSERVICE went down at [$FAIL_DATE] and it could not be restart after $MAX_RETRY tries" | mail -s "[$HOSTNAME] Service $MYSERVICE DOWN" $RECIPIENT
			exit 2
		fi
	fi
	sleep $CHECK_INTERVAL
done
