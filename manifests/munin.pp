# configure munin plugins
class dovecot::munin {

  munin::plugin::deploy{'dovecot':
    source => 'dovecot/munin/dovecot',
    config => "env.logfile /var/log/dovecot/infos.log
group ${dovecot::shared_group}"
  } -> file{'/var/lib/munin/plugin-state/plugin-dovecot.state':
    ensure => file,
    owner  => munin,
    group  => $dovecot::shared_group,
    mode   => '0660';
  }
}
