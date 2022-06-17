# configure a managesieve installation
class dovecot::managesieve (
  String[1] $type = 'some_unknown_type',
  Boolean $manage_firewall = true,
  Optional[Variant[Hash,Boolean[false]]] $nagios_checks = {
    'sieve-hostname' => $facts['networking']['fqdn'],
    'ip4_and_ip6'    => ('ip6' in $facts['networking'] and $facts['networking']['ip6'] !~ /^fe80/)
  }
) {
  include dovecot::pigeonhole

  if $manage_firewall {
    include firewall::rules::managesieve
    if ($type == 'proxy') {
      include firewall::rules::out::managesieve
    }
  }

  if $nagios_checks {
    if $nagios_checks['ip4_and_ip6'] {
      nagios::service {
        'managesieve_ip4':
          check_command => "check_managesieve_ip4!${nagios_checks['sieve-hostname']}";
        'managesieve_ip6':
          check_command => "check_managesieve_ip6!${nagios_checks['sieve-hostname']}";
      }
    } else {
      nagios::service { 'managesieve':
        check_command => "check_managesieve!${nagios_checks['sieve-hostname']}";
      }
    }
  }
}
