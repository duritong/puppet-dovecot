class dovecot::sql {
  include ::dovecot
  file{'/etc/dovecot-sql.conf':
    source => [ "puppet://$server/modules/site-dovecot/sql/${fqdn}/dovecot-sql.conf",
                "puppet://$server/modules/site-dovecot/sql/${dovecot_type}/dovecot-sql.conf",
                "puppet://$server/modules/site-dovecot/sql/dovecot-sql.conf",
                "puppet://$server/modules/site/sql/${operatingsystem}/dovecot-sql.conf",
                "puppet://$server/modules/site/sql/dovecot-sql.conf" ],
    require => Package['dovecot'],
    notify => Service['dovecot'],
    owner => root, group => 0, mode => 0600;
  }

  if ($dovecot_sql_type=='mysql'){
    include ::dovecot::sql::mysql
  } else {
    include ::dovecot::sql::pgsql
  }
}
