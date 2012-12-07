class dovecot::munin {
  munin::plugin::deploy{'dovecot':
    source => "dovecot/munin/dovecot",
    config => "env.logfile /var/log/dovecot/infos.log
group mail"
  } -> file{'/var/lib/munin/plugin-state/plugin-dovecot.state':
    ensure => file,
    owner  => munin,
    group  => mail,
    mode   => 0660;
  }
}
