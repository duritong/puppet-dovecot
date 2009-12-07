class dovecot::munin {
  munin::plugin::deploy{'dovecot':
    source => "dovecot/munin/dovecot",
    config => "env.logfile /var/log/dovecot/infos.log
group mail"
  }
}
