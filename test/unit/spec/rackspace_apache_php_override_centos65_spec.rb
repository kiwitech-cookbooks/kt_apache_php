require_relative 'spec_helper'
require_relative 'centos65_options'

describe 'rackspace_apache_php_test::override on Centos 6.5' do
  before do
    stub_resources
  end

  cached(:chef_run) do
    ChefSpec::SoloRunner.new(CENTOS65_SERVICE_OPTS) do |node|
      node_resources(node)
    end.converge('rackspace_apache_php_test::override')
  end

  context 'Apache 2.2' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new(CENTOS65_SERVICE_OPTS) do |node|
        node.set['apache']['version'] = '2.2'
      end.converge('rackspace_apache_php_test::override')
    end
    it_behaves_like 'Apache2'
    it_behaves_like 'Apache2 PHP handler', 'centos', '2.2', 'override'
    it_behaves_like 'PHP-FPM', 'redhat', 'override'
    it_behaves_like 'Yum IUS repo'
  end
  context 'Apache 2.4' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new(CENTOS65_SERVICE_OPTS) do |node|
        node.set['apache']['version'] = '2.4'
      end.converge('rackspace_apache_php_test::override')
    end
    it_behaves_like 'Apache2'
    it_behaves_like 'Apache2 PHP handler', 'centos', '2.4', 'override'
    it_behaves_like 'PHP-FPM', 'redhat', 'override'
    it_behaves_like 'Yum IUS repo'
  end
  context 'disable PHP packages install' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new(CENTOS65_SERVICE_OPTS) do |node|
        node.set['rackspace_apache_php']['php_packages_install']['enable'] = false
      end.converge('rackspace_apache_php_test::override')
    end
    it_behaves_like 'Apache2'
    it_behaves_like 'Apache2 PHP handler', 'centos', '2.2', 'override'
    it_behaves_like 'PHP-FPM', 'redhat', 'override'
    it_behaves_like 'Yum IUS repo'
    it_behaves_like 'PHP-fpm packages without PHP packages, version 5.6 CENTOS'
  end
  context 'PHP 5.4' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new(CENTOS65_SERVICE_OPTS) do |node|
        node.set['rackspace_apache_php']['php_version'] = '5.4'
      end.converge('rackspace_apache_php_test::override')
    end
    it_behaves_like 'Apache2'
    it_behaves_like 'Apache2 PHP handler', 'centos', '2.2', 'override'
    it_behaves_like 'PHP-FPM', 'redhat', 'override'
    it_behaves_like 'Yum IUS repo'
    it_behaves_like 'PHP and PHP-fpm packages version 5.4 CENTOS'
  end
  context 'PHP 5.5' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new(CENTOS65_SERVICE_OPTS) do |node|
        node.set['rackspace_apache_php']['php_version'] = '5.5'
      end.converge('rackspace_apache_php_test::override')
    end
    it_behaves_like 'Apache2'
    it_behaves_like 'Apache2 PHP handler', 'centos', '2.2', 'override'
    it_behaves_like 'PHP-FPM', 'redhat', 'override'
    it_behaves_like 'Yum IUS repo'
    it_behaves_like 'PHP and PHP-fpm packages version 5.5 CENTOS'
  end
  context 'PHP 5.6' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new(CENTOS65_SERVICE_OPTS) do |node|
        node.set['rackspace_apache_php']['php_version'] = '5.6'
      end.converge('rackspace_apache_php_test::override')
    end
    it_behaves_like 'Apache2'
    it_behaves_like 'Apache2 PHP handler', 'centos', '2.2', 'override'
    it_behaves_like 'PHP-FPM', 'redhat', 'override'
    it_behaves_like 'Yum IUS repo'
    it_behaves_like 'PHP and PHP-fpm packages version 5.6 CENTOS'
  end
end
