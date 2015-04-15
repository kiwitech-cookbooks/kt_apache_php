# Encoding: utf-8
#
# Cookbook Name:: rackspace_apache_php
# Recipe:: default
#
# Copyright 2014, Rackspace
#
include_recipe 'chef-sugar'

# APACHE
include_recipe 'apache2::mod_actions'
include_recipe 'apache2::mod_fastcgi'

apache_conf 'php-handler' do
  source node['rackspace_apache_php']['php_handler']['template']
  cookbook node['rackspace_apache_php']['php_handler']['cookbook']
  enable node['rackspace_apache_php']['php_handler']['enable']
end

# PHP-FPM
# repo dependencies for php-fpm
#
php_fpm = {
  'rhel' => {
    '5.4' => {
      'php_packages' => ['php54-pear', 'php54-devel', 'php54-cli', 'php54-pear'],
      'php_fpm_package' => 'php54-fpm',
      'service' => 'php-fpm'
    },
    '5.5' => {
      'php_packages' => ['php55u-pear', 'php55u-devel', 'php55u-cli', 'php55u-pear'],
      'php_fpm_package' => 'php55u-fpm',
      'service' => 'php-fpm'
    },
    '5.6' => {
      'php_packages' => ['php56u-pear', 'php56u-devel', 'php56u-cli', 'php56u-pear'],
      'php_fpm_package' => 'php56u-fpm',
      'service' => 'php-fpm'
    }
  },
  'debian' => {
    '5.4' => {
      'repo'    => 'http://ppa.launchpad.net/ondrej/php5-oldstable/ubuntu',
      'php_packages' => ['php5-cgi', 'php5', 'php5-dev', 'php5-cli', 'php-pear'],
      'php_fpm_package' => 'php5-fpm',
      'service' => 'php5-fpm'
    },
    '5.5' => {
      'repo'    => 'http://ppa.launchpad.net/ondrej/php5/ubuntu',
      'php_packages' => ['php5-cgi', 'php5', 'php5-dev', 'php5-cli', 'php-pear'],
      'php_fpm_package' => 'php5-fpm',
      'service' => 'php5-fpm'
    },
    '5.6' => {
      'repo'    => 'http://ppa.launchpad.net/ondrej/php5-5.6/ubuntu',
      'php_packages' => ['php5-cgi', 'php5', 'php5-dev', 'php5-cli', 'php-pear'],
      'php_fpm_package' => 'php5-fpm',
      'service' => 'php5-fpm'
    }
  }
}

# Platform PHP repositories
# RHEL
if platform_family?('rhel')
  include_recipe 'yum-ius'
elsif platform_family?('debian')
  # DEBIAN
  include_recipe 'apt'
  # using http://ppa rather than ppa: to be sure it passes firewall
  apt_repository "php-#{node['rackspace_apache_php']['php_version']}" do
    uri          php_fpm[node['platform_family']][node['rackspace_apache_php']['php_version']]['repo']
    keyserver    'hkp://keyserver.ubuntu.com:80'
    key          '14AA40EC0831756756D7F66C4F4EA0AAE5267A6C'
    components   ['main']
    distribution node['lsb']['codename']
  end
  # however we don't want apache from ondrej/php5
  apt_preference 'apache' do
    glob         '*apache*'
    pin          'release o=Ubuntu'
    pin_priority '600'
  end
end

# ondrej repos doesn't support PHP 5.4 on Trusty
if ubuntu_trusty? && node['rackspace_apache_php']['php_version'] == '5.4'
  Chef::Log.warn('PHP 5.4 is not supported on Ubuntu Trusty, the default Trusty PHP version will be installed')
end

# PHP-FPM
# Set the correct php-fpm packages to install
node.default['php-fpm']['package_name'] = php_fpm[node['platform_family']][node['rackspace_apache_php']['php_version']]['php_fpm_package']
node.default['php-fpm']['service_name'] = php_fpm[node['platform_family']][node['rackspace_apache_php']['php_version']]['service']
include_recipe 'php-fpm::default'

# PHP
# Set the correct php packages to install
if node['rackspace_apache_php']['php_packages_install']['enable']
  Chef::Log.info 'XXXX installs XXXX'
  node.default['php']['packages'] = php_fpm[node['platform_family']][node['rackspace_apache_php']['php_version']]['php_packages']
  include_recipe 'php::default'
  # Emptying php packages, to be sure if another cookbook tries to include php::default it
  # will not install unwanted php version. If a user decided to use override we assume he knows what he is doing.
  node.default['php']['packages'] = []
end

# TODO
# * downgrade / upgrade Apache if required
# Refactor mapping outside of the recipe
