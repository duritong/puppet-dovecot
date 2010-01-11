class dovecot::sieve {
  include ::dovecot
  package{'dovecot-sieve':
    ensure => installed,
    before => Service['dovecot'],
  }

  file{'/var/lib/dovecot-sieve':
    ensure => directory,
    owner => root, group => 0, mode => 0644;
  }
  file{'/var/lib/dovecot-sieve/global':
    source => [ "puppet://$server/modules/site-dovecot/sieve/${fqdn}/global/",
                "puppet://$server/modules/site-dovecot/sieve/global/",
                "puppet://$server/modules/dovecot/sieve/${operatingsystem}/global/",
                "puppet://$server/modules/dovecot/sieve/global/",
                "puppet://$server/modules/common/empty/" ],
    ensure => directory,
    recurse => true,
    purge => true,
    force => true,
    notify => Exec['compile_global_sieve'],
    owner => root, group => root, mode => 0644;
  }
  file{'/var/lib/dovecot-sieve/default.sieve':
    source => [ "puppet://$server/modules/site-dovecot/sieve/${fqdn}/default.sieve",
                "puppet://$server/modules/site-dovecot/sieve/default.sieve",
                "puppet://$server/modules/dovecot/sieve/${operatingsystem}/default.sieve",
                "puppet://$server/modules/dovecot/sieve/default.sieve" ],
    notify => Exec['compile_default_sieve'],
    owner => root, group => root, mode => 0644;
  }

  exec{'compile_default_sieve':
    command => 'sievec /var/lib/dovecot-sieve/default.sieve',
    creates => '/var/lib/dovecot-sieve/default.svbin',
    require => File['/var/lib/dovecot-sieve/default.sieve'],
  }
  exec{'compile_global_sieve':
    command => 'sievec /var/lib/dovecot-sieve/global/',
    refreshonly => true,
  }
}
