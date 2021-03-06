# Class: graphite
#
# This module manages graphite
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
# [Remember: No empty lines between comments and class definition]
class graphite::web::config (
  $time_zone         = undef,
  $whisper_dir       = '/var/lib/carbon/whisper/',
  $database_name     = '/var/lib/graphite-web/graphite.db',
  $database_engine   = 'django.db.backends.sqlite3',
  $database_user     = '',
  $database_password = '',
  $database_host     = '',
  $database_port     = '',
  ){

  file {'local_settings.py':
    ensure    => file,
    path      => '/etc/graphite-web/local_settings.py',
    owner     => 'root',
    group     => 'root',
    mode      => '0644',
    notify    => Service['httpd'],
    content   => template('graphite/local_settings.py.erb');
  }

  include ::logrotate
  logrotate::file {'graphite-web':
    log        => ['/var/log/graphite-web/error.log', '/var/log/graphite-web/access.log'],
    options    => [
      'daily',
      'missingok',
      'rotate 7',
      'compress',
      'delaycompress',
      'notifempty',
      ],
    postrotate => '/etc/init.d/httpd reload > /dev/null',
  }

}
