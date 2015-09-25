# configure a managesieve installation
class dovecot::managesieve(
  $type             = 'some_unknown_type',
  $manage_shorewall = true,
  $legacy_port      = false,
  $nagios_checks    = {
    'sieve-hostname' => $::fqdn,
  }
) {

  include dovecot::pigeonhole

  if $manage_shorewall {
    class{'shorewall::rules::managesieve':
      legacy_port => $legacy_port,
    }
    if ($type == 'proxy') {
      class{'shorewall::rules::out::managesieve':
        legacy_port => $legacy_port,
      }
    }
  }

  if $nagios_checks {
    nagios::service{'managesieve':
      check_command => "check_managesieve!${nagios_checks['sieve-hostname']}";
    }
    if $legacy_port {
      nagios::service{'managesieve_legacy':
        check_command => "check_managesieve_legacy!${nagios_checks['sieve-hostname']}";
      }
    }
  }
}
