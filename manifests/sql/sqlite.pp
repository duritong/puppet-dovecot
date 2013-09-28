# manages sqlite adaption
class dovecot::sql::sqlite {
  if ($::operatingsystem == 'CentOS') and ($::operatingsystemmajrelease < 6) {
    package{'dovecot-sqlite':
      ensure => installed,
      before => File['/etc/dovecot/dovecot-sql.conf.ext'],
    }
  }
}
