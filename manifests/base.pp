# the base installation for dovecot
class dovecot::base {
  package{'dovecot':
    ensure => installed,
  }

  file{'/etc/dovecot/dovecot.conf':
    source  => ["puppet:///modules/${dovecot::site_source}/config/${::fqdn}/dovecot.conf",
                "puppet:///modules/${dovecot::site_source}/config/${dovecot::type}/${::operatingsystem}.${::operatingsystemmajrelease}/dovecot.conf",
                "puppet:///modules/${dovecot::site_source}/config/${dovecot::type}/dovecot.conf",
                "puppet:///modules/${dovecot::site_source}/config/dovecot.conf",
                "puppet:///modules/dovecot/config/${::operatingsystem}/dovecot.conf",
                'puppet:///modules/dovecot/config/dovecot.conf' ],
    require => Package['dovecot'],
    notify  => Service['dovecot'],
    owner   => root,
    group   => $dovecot::config_group,
    mode    => '0640';
  }

  service{'dovecot':
    ensure => running,
    enable => true,
  }
}
