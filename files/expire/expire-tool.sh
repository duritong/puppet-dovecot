#!/bin/bash
MAIL_PLUGINS=${MAIL_PLUGINS//imap_quota/}
MAIL_PLUGINS=${MAIL_PLUGINS//mail_log/} 

exec ${0%.sh} "$@"
