class dovecot::managesieve {
  package{'dovecot-managesieve':
    ensure => installed,
    before => Service['dovecot'],
  }
}
