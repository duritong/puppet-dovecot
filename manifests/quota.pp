# manages quota warning
class dovecot::quota(
  $source = ["puppet:///modules/${dovecot::site_source}/quota/quota-warning.sh",
              'puppet:///modules/dovecot/quota/quota-warning.sh' ],
) {
  file{'/usr/libexec/dovecot/quota-warning.sh':
    source  => $source,
    require => Package['dovecot'],
    before  => Service['dovecot'],
    owner   => root,
    group   => 0,
    mode    => '0755';
  }
  selinux::policy{
    'dovecot-quota-warning':
      te_source => 'puppet:///modules/dovecot/selinux/quota-warning/dovecot-quota-warning.te',
      require   => Package['dovecot'],
      before    => Service['dovecot'],
  }
}
