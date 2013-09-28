# manage a mysql installation
class dovecot::sql::mysql {
  package{'dovecot-mysql':
    ensure => installed,
    before => File['/etc/dovecot/dovecot-sql.conf.ext'],
  }

  if str2bool($::selinux) and ($::operatingsystem == 'CentOS') and ($::operatingsystemmajrelease > 5) {
    selinux::policy{
      'dovecot-mysql':
        te_source => 'puppet:///modules/dovecot/selinux/postgres/dovecot-mysql.te',
        require   => Package['dovecot-mysql'],
        before    => Service['dovecot'],
    }
  }
}
