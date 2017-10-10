# class profile:kirby::master defines a kirby installation

# Setup the following:
# * apache
# * php-fpm
# * php-mbstring
# * registers for an SSL cert


class profile::kirby (
  # read from hiera
  $hostname,
  $kirbykey,
  ) {

  class {'::apache':

  }

  apache::vhost { $hostname:
    port            => '80',
    docroot         => '/var/www/kirby/public',
    custom_fragment => 'AddType application/x-httpd-php .php',
  }

  apache::fastcgi::server { 'php':
    host       => '127.0.0.1:9000',
    timeout    => 15,
    flush      => false,
    faux_path  => '/var/www/php.fcgi',
    fcgi_alias => 'php.fcgi',
    file_type  => 'appalication/x-httpd-php',
  }

  class {'::php':
    extensions => {
      mbstring => { },
    }
  }

  class {'::letsencrypt':
    domains    => [ $hostname ],
  }
}
