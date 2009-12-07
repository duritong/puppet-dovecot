class dovecot::expire {
  include ::dovecot
  file{'/etc/dovecot-expire.conf':
    source => [ "puppet://$server/modules/site-dovecot/expire/${fqdn}/dovecot-expire.conf",
                "puppet://$server/modules/site-dovecot/expire/dovecot-expire.conf",
                "puppet://$server/modules/dovecot/expire/${operatingsystem}/dovecot-expire.conf",
                "puppet://$server/modules/dovecot/expire/dovecot-expire.conf" ],
    require => Package['dovecot'],
    notify => Service['dovecot'],
    owner => root, group => 0, mode => 0600;
  }

  file{'/etc/cron.daily/dovecot-expire':
    content => "dovecot --exec-mail ext /usr/libexec/dovecot/expire-tool.sh\n",
    owner => root, group => 0, mode => 0755;
  }

  file{'/usr/libexec/dovecot/expire-tool.sh':
    source => "puppet://$server/modules/dovecot/expire/expire-tool.sh",
    owner => root, group => 0, mode => 0700;
  }

  case $dovecot_expire_type {
    default: { include ::dovecot::expire::sqlite }
  }
}
