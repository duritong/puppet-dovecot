# manages a sieve installation
class dovecot::sieve {
  include ::dovecot
  include dovecot::pigeonhole
  # create different path
  # so that delivery can happen
  # under a different user than
  # dovecot.
  selinux::fcontext{
    '/var/lib/dovecot-sieve(/.*)?':
      setype => 'dovecot_var_lib_t';
  } -> file{
    '/var/lib/dovecot-sieve':
      ensure  => directory,
      require => Package['dovecot-pigeonhole'],
      seltype => 'dovecot_var_lib_t',
      owner   => 'root',
      group   => 0,
      mode    => '0644';
    '/var/lib/dovecot-sieve/global':
      ensure  => directory,
      recurse => true,
      purge   => true,
      force   => true,
      notify  => Exec['compile_global_sieve'],
      seltype => 'dovecot_var_lib_t',
      owner   => 'root',
      group   => 0,
      mode    => '0644';
    '/var/lib/dovecot-sieve/default.sieve':
      source  => ["puppet:///modules/${dovecot::site_source}/sieve/${::fqdn}/default.sieve",
                  "puppet:///modules/${dovecot::site_source}/sieve/default.sieve",
                  "puppet:///modules/dovecot/sieve/${::operatingsystem}/default.sieve",
                  'puppet:///modules/dovecot/sieve/default.sieve' ],
      notify  => Exec['compile_default_sieve'],
      seltype => 'dovecot_var_lib_t',
      owner   => 'root',
      group   => 0,
      mode    => '0644';
  }

  exec{
    'compile_default_sieve':
      command     => 'sievec /var/lib/dovecot-sieve/default.sieve',
      creates     => '/var/lib/dovecot-sieve/default.svbin';
    'compile_global_sieve':
      command     => 'sievec /var/lib/dovecot-sieve/global/',
      refreshonly => true;
  }
}
