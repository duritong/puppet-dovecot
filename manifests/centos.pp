class dovecot::centos inherits dovecot::base {
  file{'/etc/sysconfig/dovecot':
    source => [ "puppet:///modules/site-dovecot/sysconfig/${fqdn}/dovecot",
                "puppet:///modules/site-dovecot/sysconfig/${dovecot_type}/dovecot",
                "puppet:///modules/site-dovecot/sysconfig/dovecot",
                "puppet:///modules/dovecot/sysconfig/dovecot" ],
    require => Package['dovecot'],
    notify => Service['dovecot'],
    owner => root, group => mail, mode => 0640;
  }
}
