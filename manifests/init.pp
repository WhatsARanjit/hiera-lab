class dc (
  $split = 2,
) {

  # Create a random number between 1
  # and $split.
  $dc = fqdn_rand($split-1)+1

  File {
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

  file { [
    '/etc/puppetlabs/facter',
    '/etc/puppetlabs/facter/facts.d',
  ]: }

  file { 'DC fact':
    ensure  => file,
    path    => '/etc/puppetlabs/facter/facts.d/dc.txt',
    content => "dc=DC${dc}",
  }

  if $::clientcert == 'master.puppetlabs.vm' {
    File <| title == "${::settings::confdir}/hiera.yaml" |> {
      source => 'puppet:///modules/dc/hiera.yaml',
    }
  }
}
