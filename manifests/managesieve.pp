class dovecot::managesieve {
  include dovecot::sieve
  package{'dovecot-managesieve':
    ensure => installed,
    before => Service['dovecot'],
  }
}
