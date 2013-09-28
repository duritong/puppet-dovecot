# configure munin plugins
class dovecot::munin {

  munin::plugin::deploy{'dovecot':
    source => 'dovecot/munin/dovecot',
  } -> file{'/var/lib/munin/plugin-state/plugin-dovecot.state':
    ensure => file,
    mode   => '0660';
  }
  if $dovecot::use_syslog {
    Munin::Plugin::Deploy['dovecot']{
      config => 'env.logfile /var/log/maillog
user root'
    }
    File['/var/lib/munin/plugin-state/plugin-dovecot.state']{
      owner  => root,
      group  => 0,
    }
  } else {
    Munin::Plugin::Deploy['dovecot']{
      config => 'env.logfile /var/log/dovecot/infos.log
group mail'
    }
    File['/var/lib/munin/plugin-state/plugin-dovecot.state']{
      owner  => munin,
      group  => mail,
    }
  }
}
