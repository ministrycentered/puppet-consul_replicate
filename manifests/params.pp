class consul_replicate::params {
  $version = '0.2.0'
  
  case $::architecture {
    'x86_64', 'amd64': { $arch = 'amd64' }
    'i386':            { $arch = '386'   }
    default:           { fail("Unsupported kernel architecture: ${::architecture}") }
  }

  case $::operatingsystem {
    ubuntu: {
      $bin_dir      = '/usr/local/bin'
      $download_url = "https://releases.hashicorp.com/consul-replicate/${version}/consul-replicate_linux_${arch}.zip"
    }
    default: { fail("Unsupported operating system: ${::operatingsystem}") }
  }
}
