# manage centos specific stuff
class dovecot::centos inherits dovecot::base {
  if $dovecot::upstream_repo_version {
    yum::repo{
      "dovecot-${dovecot::upstream_repo_version}":
        descr    => "Dovecot ${dovecot::upstream_repo_version} CentOS \$releasever - \$basearch",
        baseurl  => "http://repo.dovecot.org/ce-${dovecot::upstream_repo_version}/centos/\$releasever/RPMS/\$basearch",
        gpgkey   => 'https://repo.dovecot.org/DOVECOT-REPO-GPG',
        gpgcheck => 1,
        enabled  => 1,
        priority => 1,
        before   => Package['dovecot'],
    }
  }
}
