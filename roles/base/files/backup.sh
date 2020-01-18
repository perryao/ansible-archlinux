#!/bin/bash

export AWS_PROFILE=${AWS_PROFILE:-}
export AWS_BUCKET_NAME=${AWS_BUCKET_NAME:-}
export AWS_DEFAULT_REGION=us-east-1

# Your GPG key
enc_key=4E1B3FF967422387
sign_key=441174477E0BA498

# The S3 destination followed by bucket name
DEST="s3+http://${AWS_BUCKET_NAME}/backups/$(hostname)"

# Set up some variables for logging
# LOGFILE="/var/log/duplicity/backup.log"
# DAILYLOGFILE="/var/log/duplicity/backup.daily.log"
# FULLBACKLOGFILE="/var/log/duplicity/backup.full.log"
HOST=`hostname`
DATE=`date +%Y-%m-%d`
TODAY=$(date +%d%m%Y)

is_running=$(ps -ef | grep duplicity  | grep python | wc -l)

# if [ ! -d /var/log/duplicity ];then
#   mkdir -p /var/log/duplicity
# fi

# if [ ! -f $FULLBACKLOGFILE ]; then
#   touch $FULLBACKLOGFILE
# fi

if [ $is_running -eq 0 ]; then
  # Clear the old daily log file
  # cat /dev/null > ${DAILYLOGFILE}

    # Trace function for logging, don't change this
    trace () {
      stamp=`date +%Y-%m-%d_%H:%M:%S`
      # echo "$stamp: $*" >> ${DAILYLOGFILE}
      echo "$stamp: $*"
    }

    # How long to keep backups for
    OLDER_THAN="1M"

    # The source of your backup
    SOURCE=~

    FULL=full
    # tail -1 ${FULLBACKLOGFILE} | grep ${TODAY} > /dev/null
    # if [ $? -ne 0 -a $(date +%d) -eq 1 ]; then
    #   FULL=full
    # fi;

    trace "Backup for local filesystem started"

    trace "... removing old backups"

    duplicity remove-older-than ${OLDER_THAN} ${DEST}

    trace "... backing up filesystem"

    duplicity \
      ${FULL} \
      --encrypt-key=${enc_key} \
      --sign-key=${sign_key} \
      --include=/home/mike/code \
      --exclude=/** \
      --exclude=/home/mike/go \
      --exclude=/home/mike/n \
      --exclude=/home/mike/aur \
      --exclude=/home/mike/Android \
      --exclude=/home/mike/.android \
      --exclude=/home/mike/.cache \
      --exclude=/home/mike/.conan \
      --exclude=/home/mike/.gradle \
      --exclude=/home/mike/.local \
      --exclude=/home/mike/.rustup \
      --exclude=/home/mike/.config \
      --exclude=/home/mike/.npm \
      --exclude=/home/mike/.minikube \
      --exclude=/home/mike/.AndroidStudio3.5 \
      --exclude=**/node_modules/** \
      --exclude=/home/mike/.mozilla \
      --exclude=/home/mike/.cargo \
      --exclude=/home/mike/.vagrant.d \
      --exclude=/home/mike/.ivy2 \
      --exclude=/home/mike/.sbt \
      --exclude=/home/mike/.mill \
      ${SOURCE} ${DEST}

    trace "Backup for local filesystem complete"
    trace "------------------------------------"

    # Send the daily log file by email
    #cat "$DAILYLOGFILE" | mail -s "Duplicity Backup Log for $HOST - $DATE" $MAILADDR
    # BACKUPSTATUS=`cat "$DAILYLOGFILE" | grep Errors | awk '{ print $2 }'`
    # if [ "$BACKUPSTATUS" != "0" ]; then
    # cat "$DAILYLOGFILE" | mail -s "Duplicity Backup Log for $HOST - $DATE" $MAILADDR
    # elif [ "$FULL" = "full" ]; then
    #     echo "$(date +%d%m%Y_%T) Full Back Done" >> $FULLBACKLOGFILE
    # fi

    # Append the daily log file to the main log file
    # cat "$DAILYLOGFILE" >> $LOGFILE

    # Reset the ENV variables. Don't need them sitting around
    # unset AWS_ACCESS_KEY_ID
    # unset AWS_SECRET_ACCESS_KEY
  fi
