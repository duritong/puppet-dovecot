# manage a mysql installation
class dovecot::sql::mysql {
  package{'dovecot-mysql':
    ensure => installed,
    before => File['/etc/dovecot/dovecot-sql.conf.ext'],
  }

  if $dovecot::manage_shorewall {
    include shorewall::rules::out::mysql
  }
}
