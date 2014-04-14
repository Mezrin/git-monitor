#!/bin/bash

#####
##### Settings
#####
PID_FILE="$(dirname $(readlink -f $0))/git-monitor.pid"
LOG_FILE="$(dirname $(readlink -f $0))/git-monitor.log"


echo "-> $(date +'%F %T') >>> Starting to check git repos" >> ${LOG_FILE}


#####
##### Check lock file
#####
if [ -e ${PID_FILE} ]; then
    echo "-> $(date +'%F %T') >>> Lock file exists. Another process is already launched. Exit" >> ${LOG_FILE}
    exit 1
else
    echo "$$" > ${PID_FILE}
fi


#####
##### Check git repositories
#####
EMAIL_BODY=''


#####
##### Check git repo
#####
URL='url'
BRANCH='master'
COMMIT='commit'

$(dirname $(readlink -f $0))/check-gitrepo.sh ${URL} ${BRANCH} ${COMMIT} >> ${LOG_FILE} 2>&1
if [ $? -ne '0' ]; then
    EMAIL_BODY="${EMAIL_BODY} Check branch ${BRANCH} in repo ${URL}."
fi


#####
##### Send email if changes have been found
#####
if [ ${#EMAIL_BODY} -ne '0' ]; then
    EMAIL_BODY="${EMAIL_BODY} Current time - $(date +'%F %T')"
    php "$(dirname $(readlink -f $0))/send-email.php" --subject='git-monitor notification' --body="${EMAIL_BODY}"
fi


#####
##### Delete lock file
#####
rm -f ${PID_FILE}


echo "-> $(date +'%F %T') >>> Finfished to check git repos" >> ${LOG_FILE}
