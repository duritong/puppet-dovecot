# we take rpms from fedora
class dovecot(
  $sqlite = false,
  $pgsql = false,
  $mysql = false,
  $munin_checks = true,
  $manage_shorewall = true
){
  case $operatingsystem {
    centos: { include dovecot::centos }
    default: { include dovecot::base }
  }

  if $dovecot::sqlite or $dovecot::pgsql or $dovecot::mysql {
    include dovecot::sql
  }

  if $dovecot::manage_shorewall {
    include shorewall::rules::pop3
    include shorewall::rules::imap
  }

  if $dovecot::munin_checks {
    include dovecot::munin
  }
}
