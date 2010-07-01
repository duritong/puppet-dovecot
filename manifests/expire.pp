class dovecot::expire {
  include ::dovecot

  file{'/etc/cron.daily/dovecot-expire':
    owner => root, group => 0, mode => 0755;
  }
  if $dovecot_expire_type == 'legacy' or $dovecot_expire_type == 'mixed' {
    case $dovecot_mail_location {
      '': { fail("Need to set \$dovecot_mail_location on $fqdn!") }
    }
    case $dovecot_expire_dirs {
      '': { $dovecot_expire_dirs = 'Trash\|Junk' }
    }
    case $dovecot_expire_days {
      '': { $dovecot_expire_days = '14' }
    }
    File['/etc/cron.daily/dovecot-expire']{
      content => "find ${dovecot_mail_location} -regex '.*/\.\(${dovecot_expire_dirs}\)\(/.*\)?\/\(cur\|new\)/.*' -type f -ctime +${dovecot_expire_days} -delete\n"
    }
  } else {
    File['/etc/cron.daily/dovecot-expire']{
      content => "dovecot --exec-mail ext /usr/libexec/dovecot/expire-tool.sh\n"
    }
  }

  if $dovecot_expire_type != 'legacy' {
    file{'/etc/dovecot-expire.conf':
      source => [ "puppet://$server/modules/site-dovecot/expire/${fqdn}/dovecot-expire.conf",
                  "puppet://$server/modules/site-dovecot/expire/dovecot-expire.conf",
                  "puppet://$server/modules/dovecot/expire/${operatingsystem}/dovecot-expire.conf",
                  "puppet://$server/modules/dovecot/expire/dovecot-expire.conf" ],
      require => Package['dovecot'],
      notify => Service['dovecot'],
      owner => root, group => 0, mode => 0600;
    }

    file{'/usr/libexec/dovecot/expire-tool.sh':
      source => "puppet://$server/modules/dovecot/expire/expire-tool.sh",
      owner => root, group => 0, mode => 0700;
    }
  }

  case $dovecot_expire_type {
    'legacy': { info("no need to include anything for legacy mode") }
    'mixed': { include ::dovecot::expire::sqlite }
    default: { include ::dovecot::expire::sqlite }
  }
}
