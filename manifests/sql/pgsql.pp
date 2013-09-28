# manages pgsql adaption
class dovecot::sql::pgsql {
  package{'dovecot-pgsql':
    ensure => installed,
    before => File['/etc/dovecot/dovecot-sql.conf.ext'],
  }

  if str2bool($::selinux) and ($::operatingsystem == 'CentOS') and ($::operatingsystemmajrelease > 5) {
    selinux::policy{
      'dovecot-postgres':
        te_source => 'puppet:///modules/dovecot/selinux/postgres/dovecot-postgres.te',
        require   => Package['dovecot-pgsql'],
        before    => Service['dovecot'],
    }
  }
}
