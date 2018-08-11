# manage centos specific stuff
class dovecot::centos inherits dovecot::base {
  if $dovecot::upstream_repo_maj_version {
    yum::repo{
      "dovecot-${dovecot::upstream_repo_maj_version}-latest":
        descr    => "Dovecot ${dovecot::upstream_repo_maj_version} CentOS \$releasever - \$basearch",
        baseurl  => "http://repo.dovecot.org/ce-${dovecot::upstream_repo_maj_version}-latest/centos/\$releasever/RPMS/\$basearch",
        gpgkey   => 'https://repo.dovecot.org/DOVECOT-REPO-GPG',
        gpgcheck => 1,
        enabled  => 1,
        priority => 1,
        before   => Package['dovecot'],
    }
  }
}
