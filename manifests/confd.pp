# manage a /etc/dovecot/conf.d file
define dovecot::confd(
  $ensure      = 'present',
  $suffix      = '',
  $content     = false,
){
  $filename = "${name}.conf${suffix}"
  file{"/etc/dovecot/conf.d/${filename}":
    ensure => $ensure,
  }
  if $ensure == 'present' {
    if $content {
      File["/etc/dovecot/conf.d/${filename}"]{
        content => $content
      }
    } else {
      File["/etc/dovecot/conf.d/${filename}"]{
        source  => ["puppet:///modules/${dovecot::site_source}/conf.d/${::fqdn}/${filename}",
                    "puppet:///modules/${dovecot::site_source}/conf.d/${dovecot::type}/${::operatingsystem}.${::operatingsystemmajrelease}/${filename}",
                    "puppet:///modules/${dovecot::site_source}/conf.d/${dovecot::type}/${filename}",
                    "puppet:///modules/${dovecot::site_source}/conf.d/${filename}", ]
      }
    }
    File["/etc/dovecot/conf.d/${filename}"]{
      require => Package['dovecot'],
      notify  => Service['dovecot'],
      owner   => root,
      group   => 0,
      mode    => '0644'
    }
  }
}
