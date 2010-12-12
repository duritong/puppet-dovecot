class dovecot::managesieve(
  $type = 'some_unknown_type',
  $manage_shorewall = true,
  $check_nagios = {
    'hostname' => $fqdn,
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

  if $dovecot::managesieve::check_nagios {
    nagios::serve{"managesieve":
      check_command => "check_tcp!${dovecot::managesieve::check_nagios['hostname]}!2000";
    }
  }
}
