# we take rpms from fedora
class dovecot(
  $type               = 'some_unkown_type',
  $sqlite             = false,
  $pgsql              = false,
  $mysql              = false,
  $sql_config_content = false,
  $use_syslog         = true,
  $nagios_checks      = {
    'imap-hostname' => $::fqdn,
    'pop3-hostname' => $::fqdn,
  },
  $munin_checks       = true,
  $manage_shorewall   = true,
  $config_group       = 0,
){

  case $::operatingsystem {
    centos: { include dovecot::centos }
    default: { include dovecot::base }
  }

  if $dovecot::sqlite or $dovecot::pgsql or $dovecot::mysql {
    include dovecot::sql
  }

  if $dovecot::manage_shorewall {
    include shorewall::rules::pop3
    include shorewall::rules::imap
    if $type == 'proxy' {
      include shorewall::rules::out::imap
      include shorewall::rules::out::pop3
    }
  }

  if $dovecot::munin_checks {
    include dovecot::munin
  }

  if $dovecot::nagios_checks {
    nagios::service{
      'check_imap':
        check_command => "check_imap!${dovecot::nagios_checks['imap-hostname']}!143";
      'check_imap_ssl':
        check_command => "check_imap_ssl!${dovecot::nagios_checks['imap-hostname']}!993";
      'check_pop3':
        check_command => "check_pop3!${dovecot::nagios_checks['pop3-hostname']}!110";
      'check_pop3_ssl':
        check_command => "check_pop3_ssl!${dovecot::nagios_checks['pop3-hostname']}!995";
    }
  }
}
