require_relative 'spec_helper'
require_relative 'ubuntu1204_options'

describe 'rackspace_apache_php_test::default on Ubuntu 12.04' do
  before do
    stub_resources
  end

  context 'Apache 2.2' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new(UBUNTU1204_SERVICE_OPTS) do |node|
        node.set['apache']['version'] = '2.2'
      end.converge('rackspace_apache_php_test::default')
    end
    it_behaves_like 'Apache2', 'ubuntu', '12.04'
    it_behaves_like 'Apache2 PHP handler', 'ubuntu', '2.2', 'default'
    it_behaves_like 'PHP-FPM', 'ubuntu', 'default'
    it_behaves_like 'APT php repo', 5.6
  end

  context 'disable PHP packages install' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new(UBUNTU1204_SERVICE_OPTS) do |node|
        node.set['rackspace_apache_php']['php_packages_install']['enable'] = false
      end.converge('rackspace_apache_php_test::default')
    end
    it_behaves_like 'Apache2', 'ubuntu', '12.04'
    it_behaves_like 'Apache2 PHP handler', 'ubuntu', '2.2', 'default'
    it_behaves_like 'PHP-FPM', 'ubuntu', 'default'
    it_behaves_like 'APT php repo', 5.6
    it_behaves_like 'PHP-fpm packages without PHP packages, version 5.6 UBUNTU'
  end

  context 'PHP 5.5' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new(UBUNTU1204_SERVICE_OPTS) do |node|
        node.set['rackspace_apache_php']['php_version'] = '5.5'
      end.converge('rackspace_apache_php_test::default')
    end
    it_behaves_like 'Apache2', 'ubuntu', '12.04'
    it_behaves_like 'Apache2 PHP handler', 'ubuntu', '2.2', 'default'
    it_behaves_like 'PHP-FPM', 'ubuntu', 'default'
    it_behaves_like 'APT php repo', 5.5
    it_behaves_like 'PHP and PHP-fpm packages version 5.5 UBUNTU'
  end

  context 'PHP 5.6' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new(UBUNTU1204_SERVICE_OPTS) do |node|
        node.set['rackspace_apache_php']['php_version'] = '5.6'
      end.converge('rackspace_apache_php_test::default')
    end
    it_behaves_like 'Apache2', 'ubuntu', '12.04'
    it_behaves_like 'Apache2 PHP handler', 'ubuntu', '2.2', 'default'
    it_behaves_like 'PHP-FPM', 'ubuntu', 'default'
    it_behaves_like 'APT php repo', 5.6
    it_behaves_like 'PHP and PHP-fpm packages version 5.6 UBUNTU'
  end
end
