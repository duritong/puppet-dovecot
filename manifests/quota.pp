# manages quota warning
class dovecot::quota {
  file{'/usr/libexec/dovecot/quota-warning.sh':
    source  => ["puppet:///modules/${dovecot::site_source}/quota/quota-warning.sh",
                'puppet:///modules/dovecot/quota/quota-warning.sh' ],
    require => Package['dovecot'],
    before  => Service['dovecot'],
    owner   => root,
    group   => 0,
    mode    => '0755';
  }
}
