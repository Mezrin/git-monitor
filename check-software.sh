#!/bin/bash

#####
##### Send test email
#####
php "$(dirname $(readlink -f $0))/send-email.php" --subject='git-monitor check' --body="Test email to check SMTP software. Time: $(date +'%F %T')"
