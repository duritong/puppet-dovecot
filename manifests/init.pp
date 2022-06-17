# we take rpms from fedora
class dovecot (
  String[1] $type = 'some_unkown_type',
  Boolean $pgsql = false,
  Boolean $mysql = false,
  Optional[String[1]] $sql_config_content = undef,
  Optional[Variant[Hash[String,String],Boolean]] $nagios_checks = {
    'imap-hostname' => $facts['networking']['fqdn'],
    'pop3-hostname' => $facts['networking']['fqdn'],
    'ip4_and_ip6'   => ('ip6' in $facts['networking'] and $facts['networking']['ip6'] !~ /^fe80/),
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

  if $pgsql or $mysql {
    include dovecot::sql
  }

  if $manage_firewall {
    include firewall::rules::pop3
    include firewall::rules::imap
    if $type == 'proxy' {
      include firewall::rules::out::imap
      include firewall::rules::out::pop3
    }
  }

  if $munin_checks {
    include dovecot::munin
  }

  if $nagios_checks {
    if $nagios_checks['ip4_and_ip6'] {
      nagios::service {
        'check_imap_ip4':
          check_command => "check_imap_ip4!${nagios_checks['imap-hostname']}!143";
        'check_imap_ip4_ssl':
          check_command => "check_imap_ip4_ssl!${nagios_checks['imap-hostname']}!993";
        'check_pop3_ip4':
          check_command => "check_pop3_ip4!${nagios_checks['pop3-hostname']}!110";
        'check_pop3_ip4_ssl':
          check_command => "check_pop3_ip4_ssl!${nagios_checks['pop3-hostname']}!995";
        'check_imap_ip6':
          check_command => "check_imap_ip6!${nagios_checks['imap-hostname']}!143";
        'check_imap_ip6_ssl':
          check_command => "check_imap_ip6_ssl!${nagios_checks['imap-hostname']}!993";
        'check_pop3_ip6':
          check_command => "check_pop3_ip6!${nagios_checks['pop3-hostname']}!110";
        'check_pop3_ip6_ssl':
          check_command => "check_pop3_ip6_ssl!${nagios_checks['pop3-hostname']}!995";
      }
    } else {
      nagios::service {
        'check_imap':
          check_command => "check_imap!${nagios_checks['imap-hostname']}!143";
        'check_imap_ssl':
          check_command => "check_imap_ssl!${nagios_checks['imap-hostname']}!993";
        'check_pop3':
          check_command => "check_pop3!${nagios_checks['pop3-hostname']}!110";
        'check_pop3_ssl':
          check_command => "check_pop3_ssl!${nagios_checks['pop3-hostname']}!995";
      }
    }
  }
}
