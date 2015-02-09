# manages a sieve installation
class dovecot::sieve {
  include ::dovecot
  file{'/var/lib/dovecot-sieve':
    ensure  => directory,
    owner   => root,
    group   => 0,
    mode    => '0644';
  }
  if ($::operatingsystem == 'CentOS') and ($::operatingsystemmajrelease < 6) {
    package{'dovecot-sieve':
      ensure => installed,
      before => [ Service['dovecot'], File['/var/lib/dovecot-sieve'] ]
    }
  } else {
    include dovecot::pigeonhole
    File['/var/lib/dovecot-sieve']{
      require => Package['dovecot-pigeonhole']
    }
  }

  file{
    '/var/lib/dovecot-sieve/global':
      ensure  => directory,
      recurse => true,
      purge   => true,
      force   => true,
      notify  => Exec['compile_global_sieve'],
      owner   => root,
      group   => root,
      mode    => '0644';
    '/var/lib/dovecot-sieve/default.sieve':
      source  => ["puppet:///modules/${dovecot::site_source}/sieve/${::fqdn}/default.sieve",
                  "puppet:///modules/${dovecot::site_source}/sieve/default.sieve",
                  "puppet:///modules/dovecot/sieve/${::operatingsystem}/default.sieve",
                  'puppet:///modules/dovecot/sieve/default.sieve' ],
      notify  => Exec['compile_default_sieve'],
      owner   => root,
      group   => root,
      mode    => '0644';
  }

  exec{
    'compile_default_sieve':
      command     => 'sievec /var/lib/dovecot-sieve/default.sieve',
      creates     => '/var/lib/dovecot-sieve/default.svbin',
      require     => File['/var/lib/dovecot-sieve/default.sieve'];
    'compile_global_sieve':
      command     => 'sievec /var/lib/dovecot-sieve/global/',
      refreshonly => true,
      require     => File['/var/lib/dovecot-sieve/global'];
  }
}
