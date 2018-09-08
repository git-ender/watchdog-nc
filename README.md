This script is an exercise. Altough it works it not intended to be used in production without furher testing

# Watchdog for linux services

This script continuosly check for the status of a given service and try to restart it. If it fail to restart, the watchdog exit and send a proper message. 
It is composed by 3 file
    
 * watchdog_launcher.sh # use this script for launching the watchdog
 * watchdog.sh # the watchdog itself
 * watchdog.cfg # config file for the script, see variables
    
### How to install

Simply copy all the 3 files in a proper directory, like /usr/local/bin/watchdog. If you want to run it automatically at boot add
* @reboot /path/to/watchdog_launcher.sh

in your crontab file. Check your distribution manual for further detail.

### Variables

Edit the watchdog.cfg file

 * MYSERVICE=myservice # name of the service to be watched, i.e. httpd
 * MAX_RETRY=5 # number of the retries after which the watchdog will stop trying
 * RETRY_INTERVAL=10 # interval between restart attempative
 * CHECK_INTERVAL=30 # interval between check for service
 * RECIPIENT=myemail@my_email_provider.com # a valid email for sending report. Please be sure your mail client or server is properly configured
 * WATCHDOG_LOG_FILE=/path/to/mylog.txt # path for log. Please be sure that folder exist

### How to launch

Use the provided launcher to run the watchdog. It must be runned with root permission.

"watchdog_launcher.sh -d" will launch the script in deamon mode.
"watchdog_launcher.sh -C" will launch the script with in console mode. It could be useful for test or debugging.
