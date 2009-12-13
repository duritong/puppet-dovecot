class dovecot::managesieve {
  package{'dovecot-managesieve':
    ensure => installed,
    before => Service['dovecot'],
  }

  if $use_shorewall {
    include shorewall::rules::managesieve
  }
}
