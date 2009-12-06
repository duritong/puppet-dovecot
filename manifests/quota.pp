class dovecot::quota {
  file{'/usr/libexec/dovecot/quota-warning.sh':
    source => [ "puppet://$server/modules/site-dovecot/quota/quota-warning.sh",
                "puppet://$server/modules/dovecot/quota/quota-warning.sh" ],
    require => Package['dovecot'],
    before => Service['dovecot'],
    owner => root, group => 0, mode => 0755;
  }
}
