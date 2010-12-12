class dovecot::managesieve(
  $type = 'some_unknown_type',
  $manage_shorewall = true,
  $nagios_checks = {
    'sieve-hostname' => $fqdn,
  }
) {
  package{'dovecot-managesieve':
    ensure => installed,
    before => Service['dovecot'],
  }

  if $dovecot::managesieve::manage_shorewall {
    include shorewall::rules::managesieve
    if $dovecot::managesieve::type == 'proxy' {
      include shorewall::rules::out::managesieve
    }
  }

  if $dovecot::managesieve::nagios_checks {
    nagios::service{"managesieve":
      check_command => "check_managesieve!${dovecot::managesieve::nagios_checks['sieve-hostname']}";
    }
  }
}
