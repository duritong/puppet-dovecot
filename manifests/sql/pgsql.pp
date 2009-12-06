class dovecot::sql::pgsql {
  package{'dovecot-pgsql':
    ensure => installed,
    before => File['/etc/dovecot-sql.conf'],
  }
}
