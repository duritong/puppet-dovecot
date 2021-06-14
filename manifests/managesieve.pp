# configure a managesieve installation
class dovecot::managesieve (
  String[1] $type = 'some_unknown_type',
  Boolean $manage_firewall = true,
  Optional[Variant[Hash,Boolean[false]]] $nagios_checks = {
    'sieve-hostname' => $facts['networking']['fqdn'],
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
    nagios::service { 'managesieve':
      check_command => "check_managesieve!${nagios_checks['sieve-hostname']}";
    }
  }
}
