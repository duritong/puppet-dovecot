class dovecot::sql::sqlite {
  package{'dovecot-sqlite':
    ensure => installed,
    before => File['/etc/dovecot-sql.conf'],
  }
}
