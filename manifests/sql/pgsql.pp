# manages pgsql adaption
class dovecot::sql::pgsql {
  package{'dovecot-pgsql':
    ensure  => installed,
    require => Package['dovecot'],
    before  => File['/etc/dovecot/dovecot-sql.conf.ext'],
  }

  selinux::policy{
    'dovecot-postgres':
      te_source => 'puppet:///modules/dovecot/selinux/postgres/dovecot-postgres.te',
      require   => Package['dovecot-pgsql'],
      before    => Service['dovecot'],
  }

  if $dovecot::manage_shorewall {
    include shorewall::rules::out::postgres
  }
}
