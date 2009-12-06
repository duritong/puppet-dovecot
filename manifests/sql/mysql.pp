class dovecot::sql::mysql {
  package{'dovecot-mysql':
    ensure => installed,
    before => File['/etc/dovecot-sql.conf'],
  }
}
