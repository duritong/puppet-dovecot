# configure logrotate correctly
class dovecot::logrotate {
  include ::logrotate
  augeas {
    'logrotate_dovecot':
      context => '/files/etc/logrotate.d/dovecot/rule',
      changes => ['set file /var/log/dovecot/*.log', 'set rotate 3', 'set schedule weekly',
                  'set compress compress', 'set sharedscripts sharedscripts',
                  'set create/mode 0660', 'set create/owner root', 'set create/group mail',
                  'set postrotate "/bin/kill -USR1 `cat /var/run/dovecot/master.pid 2>/dev/null` 2> /dev/null || true"' ],
  }
}
