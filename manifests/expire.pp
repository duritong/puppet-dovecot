class dovecot::expire(
  $type = 'script',
  $mail_location = 'absent',
  $expire_days = '14',
  $directories = 'Trash\|Junk'
) {
  include ::dovecot

  file{'/etc/cron.daily/dovecot-expire':
    owner => root, group => 0, mode => 0755;
  }
  if $dovecot::expire::type == 'legacy' or $dovecot::expire::type == 'mixed' {
    case $dovecot::expire::mail_location {
      'absent': { fail("Need to set \$mail_location on ${::fqdn}!") }
    }
    File['/etc/cron.daily/dovecot-expire']{
      content => "find ${dovecot::expire::mail_location} -regex '.*/\\.\\(${dovecot::expire::directories}\\)\\(/.*\\)?\\/\\(cur\\|new\\)/.*' -type f -ctime +${dovecot::expire::days} -delete\n"
    }
  } else {
    File['/etc/cron.daily/dovecot-expire']{
      content => "dovecot --exec-mail ext /usr/libexec/dovecot/expire-tool.sh\n"
    }
  }

  if $dovecot::expire::type != 'legacy' {
    file{'/etc/dovecot-expire.conf':
      source => [ "puppet:///modules/site_dovecot/expire/${::fqdn}/dovecot-expire.conf",
                  "puppet:///modules/site_dovecot/expire/dovecot-expire.conf",
                  "puppet:///modules/dovecot/expire/${::operatingsystem}/dovecot-expire.conf",
                  "puppet:///modules/dovecot/expire/dovecot-expire.conf" ],
      require => Package['dovecot'],
      notify => Service['dovecot'],
      owner => root, group => 0, mode => 0600;
    }

    file{'/usr/libexec/dovecot/expire-tool.sh':
      source => "puppet:///modules/dovecot/expire/expire-tool.sh",
      owner => root, group => 0, mode => 0700;
    }
  }

  case $dovecot::expire::type {
    'legacy': { info("no need to include anything for legacy type") }
    'mixed': { include ::dovecot::expire::sqlite }
    default: { include ::dovecot::expire::sqlite }
  }
}
