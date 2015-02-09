# sql integration for dovecot
class dovecot::sql {
  file{'/etc/dovecot/dovecot-sql.conf.ext':
    require => Package['dovecot'],
    notify  => Service['dovecot'],
    owner   => root,
    group   => 0,
    mode    => '0600';
  }

  if $dovecot::sql_config_content {
    File['/etc/dovecot/dovecot-sql.conf.ext']{
      content => $dovecot::sql_config_content
    }
  } else {
    File['/etc/dovecot/dovecot-sql.conf.ext']{
      source  => ["puppet:///modules/${dovecot::site_source}/sql/${::fqdn}/dovecot-sql.conf",
                  "puppet:///modules/${dovecot::site_source}/sql/${dovecot::type}/dovecot-sql.conf",
                  "puppet:///modules/${dovecot::site_source}/sql/dovecot-sql.conf",
                  "puppet:///modules/site/sql/${::operatingsystem}/dovecot-sql.conf",
                  'puppet:///modules/site/sql/dovecot-sql.conf' ]
    }
  }

  if ($::operatingsystem == 'CentOS') and ($::operatingsystemmajrelease < 6) {
    File['/etc/dovecot/dovecot-sql.conf.ext']{
      path => '/etc/dovecot-sql.conf'
    }
  }

  if $dovecot::mysql {
    include ::dovecot::sql::mysql
  }
  if $dovecot::pgsql {
    include ::dovecot::sql::pgsql
  }
  if $dovecot::sqlite {
    include ::dovecot::sql::sqlite
  }
}
