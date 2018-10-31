# manage the pigeonhole package
class dovecot::pigeonhole {
  package{'dovecot-pigeonhole':
    ensure  => present,
    require => Package['dovecot'],
  }
}
