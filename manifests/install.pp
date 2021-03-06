class consul_replicate::install {

  exec { 'Download consul-replicate binary':
    command => "wget -q --no-check-certificate ${consul_replicate::download_url} -O /tmp/consul-replicate-${consul_replicate::version}.zip",
    path    => $::path,
    unless  => "test -s ${consul_replicate::bin_dir}/consul-replicate-${consul_replicate::version}",
    } ->

    exec { 'Extract consul-replicate binary':
      command     => "unzip /tmp/consul-replicate-${consul_replicate::version}.zip && mv -f /tmp/consul-replicate ${consul_replicate::bin_dir}/consul-replicate-${consul_replicate::version}",
      path        => $::path,
      refreshonly => true,
      subscribe   => Exec['Download consul-replicate binary'],
      notify      => Service['consul-replicate'],
      } ->

      file { "${consul_replicate::bin_dir}/consul-replicate-${consul_replicate::version}":
        ensure => file,
        owner  => 'root',
        group  => 'root',
        mode   => '0555',
        } ->

        file { "${consul_replicate::bin_dir}/consul-replicate":
          ensure  => link,
          target  => "${consul_replicate::bin_dir}/consul-replicate-${consul_replicate::version}",
          require => File["${consul_replicate::bin_dir}/consul-replicate-${consul_replicate::version}"],
          } ->

          file { '/etc/init/consul-replicate.conf':
            ensure  => present,
            mode    => '0444',
            owner   => 'root',
            group   => 'root',
            content => template('consul_replicate/consul-replicate.upstart.erb')
            } ->
            
            file { '/etc/init.d/consul-replicate':
              ensure => link,
              target => '/lib/init/upstart-job',
              owner  => root,
              group  => root,
              mode   => '0755',
            }

            group { $consul_replicate::group:
              ensure => present
            }

            user { $consul_replicate::user:
              ensure  => present,
            }
}
