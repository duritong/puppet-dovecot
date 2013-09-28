# manage a /etc/dovecot/conf.d file
define dovecot::confd(
  $ensure = 'present',
  $suffix = '',
){
  $filename = "${name}.conf${suffix}"
  file{"/etc/dovecot/conf.d/${filename}":
    ensure => $ensure,
  }
  if $ensure == 'present' {
    File["/etc/dovecot/conf.d/${filename}"]{
      source  => ["puppet:///modules/site_dovecot/conf.d/${::fqdn}/${filename}",
                  "puppet:///modules/site_dovecot/conf.d/${dovecot::type}/${filename}",
                  "puppet:///modules/site_dovecot/conf.d/${filename}", ],
      require => Package['dovecot'],
      notify  => Service['dovecot'],
      owner   => root,
      group   => 0,
      mode    => '0644'
    }
  }
}
