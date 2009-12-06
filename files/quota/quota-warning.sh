#!/bin/sh

PERCENT=$1
FROM="postmaster@example.com"
qwf="/tmp/quota.warning.$$"

echo "From: $FROM
To: $USER
Subject: Your email quota is $PERCENT% full
Content-Type: text/plain; charset="UTF-8"

Deine Mailbox ist nun $PERCENT% full.
Your mailbox is now $PERCENT% full.

Bitte räume deine Mailbox auf.
Please clean up your mailbox.

Volle Mailboxen werden keine Emails mehr empfangen.
Full mailboxes will reject emails." >> $qwf

cat $qwf | /usr/sbin/sendmail -f $FROM "$USER"
rm -f $qwf

exit 0
