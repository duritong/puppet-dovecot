# we take rpms from fedora
class dovecot (
  String[1] $type = 'some_unkown_type',
  Boolean $pgsql = false,
  Boolean $mysql = false,
  Optional[String[1]] $sql_config_content = undef,
  Optional[Hash] $nagios_checks = {
    'imap-hostname' => $facts['networking']['fqdn'],
    'pop3-hostname' => $facts['networking']['fqdn'],
  },
  Boolean $munin_checks = true,
  Boolean $manage_firewall = true,
  Variant[String[1],Integer] $config_group = 0,
  String[1] $site_source = 'site_dovecot',
  Optional[String[1]] $upstream_repo_version = undef,
) {
  case $facts['os']['name'] {
    'CentOS': { include dovecot::centos }
    default: { include dovecot::base }
  }

  if $dovecot::pgsql or $dovecot::mysql {
    include dovecot::sql
  }

  if $dovecot::manage_firewall {
    include firewall::rules::pop3
    include firewall::rules::imap
    if $type == 'proxy' {
      include firewall::rules::out::imap
      include firewall::rules::out::pop3
    }
  }

  if $dovecot::munin_checks {
    include dovecot::munin
  }

  if $dovecot::nagios_checks {
    nagios::service {
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
