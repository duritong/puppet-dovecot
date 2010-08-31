class dovecot::base {
  package{'dovecot':
    ensure => installed,
  }

  file{'/etc/dovecot.conf':
    source => [ "puppet:///modules/site-dovecot/config/${fqdn}/dovecot.conf",
                "puppet:///modules/site-dovecot/config/${dovecot_type}/dovecot.conf",
                "puppet:///modules/site-dovecot/config/dovecot.conf",
                "puppet:///modules/dovecot/config/${operatingsystem}/dovecot.conf",
                "puppet:///modules/dovecot/config/dovecot.conf" ],
    require => Package['dovecot'],
    notify => Service['dovecot'],
    owner => root, group => mail, mode => 0640;
  }

  file{'/var/log/dovecot':
    ensure => directory,
    require => Package['dovecot'],
    before => Service['dovecot'],
    owner => dovecot, group => 12, mode => 0660,
  }
  file{ [ '/var/log/dovecot/error.log',
          '/var/log/dovecot/infos.log' ]:
      require => Package['dovecot'],
      before => Service['dovecot'],
      owner => root, group => 12, mode => 0660;
  }

  include dovecot::logrotate

  service{'dovecot':
    ensure => running,
    enable => true,
  }
}
