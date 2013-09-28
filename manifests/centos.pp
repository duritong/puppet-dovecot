# centos specific stuff
class dovecot::centos inherits dovecot::base {
  file{'/etc/sysconfig/dovecot':
    source  => ["puppet:///modules/site_dovecot/sysconfig/${::fqdn}/dovecot",
                "puppet:///modules/site_dovecot/sysconfig/${dovecot::type}/dovecot",
                'puppet:///modules/site_dovecot/sysconfig/dovecot',
                'puppet:///modules/dovecot/sysconfig/dovecot' ],
    require => Package['dovecot'],
    notify  => Service['dovecot'],
    owner   => root,
    group   => 0,
    mode    => '0640';
  }
}
