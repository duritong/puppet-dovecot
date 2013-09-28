# configure a managesieve installation
class dovecot::managesieve(
  $type             = 'some_unknown_type',
  $manage_shorewall = true,
  $nagios_checks    = {
    'sieve-hostname' => $::fqdn,
  }
) {

  if ($::operatingsystem == 'CentOS') and ($::operatingsystemmajrelease < 6) {
    package{'dovecot-managesieve':
      ensure => installed,
      before => Service['dovecot'],
    }
  } else {
    include dovecot::pigeonhole
  }

  if $manage_shorewall {
    include shorewall::rules::managesieve
    if ($type == 'proxy') {
      include shorewall::rules::out::managesieve
    }
  }

  if $nagios_checks {
    nagios::service{'managesieve':
      check_command => "check_managesieve!${nagios_checks['sieve-hostname']}";
    }
  }
}
