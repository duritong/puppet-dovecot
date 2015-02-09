# centos specific stuff
class dovecot::centos inherits dovecot::base {
  if $::operatingsystemmajrelease < 7 {
    file{'/etc/sysconfig/dovecot':
      source  => ["puppet:///modules/${dovecot::site_source}/sysconfig/${::fqdn}/dovecot",
                  "puppet:///modules/${dovecot::site_source}/sysconfig/${dovecot::type}/dovecot",
                  "puppet:///modules/${dovecot::site_source}/sysconfig/dovecot",
                  'puppet:///modules/dovecot/sysconfig/dovecot' ],
      require => Package['dovecot'],
      notify  => Service['dovecot'],
      owner   => root,
      group   => 0,
      mode    => '0640';
    }
  }
}
