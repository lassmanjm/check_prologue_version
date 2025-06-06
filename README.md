# Check Prologue Version

A simple bash script to scrape [the Prologue App Store page](https://apps.apple.com/us/app/prologue/id1459223267) to check for major version updates. 

## Usage:

```
check_prologue_version/run.sh -r $EMAIL_ADDRESS -v $WANTED_MAJOR_VERSION -l
```

## Flags:
    * -r: Recipient of email <b>(required)</b>
    * -v: Wanted major version (default `4`)
    * -l: Whether to log to /tmp/logs/check_prologue_version.log

## Crontab:

To create a simple cron job, run:

```
crontab -e
```
Then, add the following line, updating the path to the binary and setting the flags/schedule as you wish:

```
0 11 * * * check_prologue_version/run.sh -r me@someaddress.com
```

This will run the script once a day at 11 A.M.

NOTE: This script requires [msmtp](https://wiki.archlinux.org/title/Msmtp), which must be 
set up for email notifications. You can alter the script and change the method notifications
if you'd prefer.



