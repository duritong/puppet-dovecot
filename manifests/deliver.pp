class dovecot::deliver {
  include ::dovecot
  file{ [ 'var/log/dovecot/deliver.log',
        'var/log/dovecot/deliver-error.log' ]:
      require => Package['dovecot'],
      before => Service['dovecot'],
      owner => root, group => 12, mode => 0660;
  }
}
