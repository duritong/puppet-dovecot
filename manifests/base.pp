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
  if ($::operatingsystem == 'CentOS') and ($::operatingsystemmajrelease < 6) {
    File['/etc/dovecot/dovecot.conf']{
      path => '/etc/dovecot.conf'
    }
  }
  if !$dovecot::use_syslog {
    file{
      '/var/log/dovecot':
        ensure  => directory,
        require => Package['dovecot'],
        before  => Service['dovecot'],
        owner   => dovecot,
        group   => mail,
        mode    => '0660';
      [ '/var/log/dovecot/error.log',
        '/var/log/dovecot/infos.log' ]:
        require => Package['dovecot'],
        before  => Service['dovecot'],
        owner   => root,
        group   => mail,
        mode    => '0660';
    }

    include dovecot::logrotate
  }

  service{'dovecot':
    ensure => running,
    enable => true,
  }
}
