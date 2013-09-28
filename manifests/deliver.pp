# manages things if you use
# dovecot also for delivery
class dovecot::deliver {
  include ::dovecot
  if !$dovecot::use_syslog {
    file{ [ '/var/log/dovecot/deliver.log',
            '/var/log/dovecot/deliver-error.log' ]:
      require => Package['dovecot'],
      before  => Service['dovecot'],
      owner   => root,
      group   => $dovecot::auth_group,
      mode    => '0660';
    }
  }
}
