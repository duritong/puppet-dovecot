# we take rpms from fedora
class dovecot(
  $sqlite = false,
  $pgsql = false,
  $mysql = false,
  $nagios_checks = {
    'hostname' => 'fqdn',
  },
  $munin_checks = true,
  $manage_shorewall = true
){
  case $operatingsystem {
    centos: { include dovecot::centos }
    default: { include dovecot::base }
  }

  if $dovecot::sqlite or $dovecot::pgsql or $dovecot::mysql {
    include dovecot::sql
  }

  if $dovecot::manage_shorewall {
    include shorewall::rules::pop3
    include shorewall::rules::imap
  }

  if $dovecot::munin_checks {
    include dovecot::munin
  }

  if $dovecot::nagios_checks {
    if $dovecot::nagios_checks['hostname'] == 'fqdn' {
      $host_to_check = $fqdn
    } else {
      $host_to_check = $dovecot::nagios_checks['hostname']
    }
    nagios::service{
      "check_imap":
        check_command => "check_imap!${host_to_check}!143";
      "check_imap_ssl":
        check_command => "check_imap_ssl!${host_to_check}!993";
      "check_pop3":
        check_command => "check_pop3!${host_to_check}!110";
      "check_pop3_ssl":
        check_command => "check_pop3_ssl!${host_to_check}!995";
    }
  }
}
