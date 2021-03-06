# Class: tftp::params
#
#   TFTP class parameters.
class tftp::params {
  $address    = '0.0.0.0'
  $port       = '69'
  $options    = '--secure'
  $binary     = '/usr/sbin/in.tftpd'
  $inetd      = true

  case $::osfamily {
    'debian': {
      $package  = 'tftpd-hpa'
      $defaults = true
      $username = 'tftp'
      case $facts['operatingsystem'] {
        'debian': {
          $directory  = '/srv/tftp'
          $hasstatus  = false
          $provider   = undef
        }
        'ubuntu': {
          # ubuntu now uses systemd
          if versioncmp($facts['operatingsystemrelease'], '15.04') >= 0 {
            $provider = 'systemd'
          } else {
            $provider   = 'upstart'
          }
          $directory  = '/var/lib/tftpboot'
          $hasstatus  = true
        }
        default: {
          fail "${facts['operatingsystem']} is not supported"
        }
      }
    }
    'redhat': {
      $package    = 'tftp-server'
      $username   = 'nobody'
      $defaults   = false
      $directory  = '/var/lib/tftpboot'
      $hasstatus  = false
      $provider   = 'base'
    }
    default: {
      $package    = 'tftpd'
      $username   = 'nobody'
      $defaults   = false
      $hasstatus  = false
      $provider   = undef
      warning("tftp:: ${facts['operatingsystem']} may not be supported")
    }
  }
}
