# configure munin plugins
class dovecot::munin {
  munin::plugin::deploy{'dovecot':
    source => 'dovecot/munin/dovecot',
    config => "env.logfile /var/log/maillog\nuser root",
  } -> file{'/var/lib/munin-node/plugin-state/plugin-dovecot.state':
    owner => root,
    group => 0,
    mode  => '0660';
  }
}
