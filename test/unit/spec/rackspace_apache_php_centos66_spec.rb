require_relative 'spec_helper'
require_relative 'centos67_options'

describe 'rackspace_apache_php_test::default on Centos 6.7' do
  before do
    stub_resources
  end

  cached(:chef_run) do
    ChefSpec::SoloRunner.new(CENTOS67_SERVICE_OPTS) do |node|
      node_resources(node)
    end.converge('rackspace_apache_php_test::default')
  end

  context 'Apache 2.2' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new(CENTOS67_SERVICE_OPTS) do |node|
        node.set['apache']['version'] = '2.2'
      end.converge('rackspace_apache_php_test::default')
    end
    it_behaves_like 'Apache2', 'centos', '6.7'
    it_behaves_like 'Apache2 PHP handler', 'centos', '2.2', 'default'
    it_behaves_like 'PHP-FPM', 'redhat', 'default'
    it_behaves_like 'Yum IUS repo'
  end

  context 'disable PHP packages install' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new(CENTOS67_SERVICE_OPTS) do |node|
        node.set['rackspace_apache_php']['php_packages_install']['enable'] = false
      end.converge('rackspace_apache_php_test::default')
    end
    it_behaves_like 'Apache2', 'centos', '6.7'
    it_behaves_like 'Apache2 PHP handler', 'centos', '2.2', 'default'
    it_behaves_like 'PHP-FPM', 'redhat', 'default'
    it_behaves_like 'Yum IUS repo'
    it_behaves_like 'PHP-fpm packages without PHP packages, version 5.6 CENTOS'
  end

  context 'PHP 5.5' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new(CENTOS67_SERVICE_OPTS) do |node|
        node.set['rackspace_apache_php']['php_version'] = '5.5'
      end.converge('rackspace_apache_php_test::default')
    end
    it_behaves_like 'Apache2', 'centos', '6.7'
    it_behaves_like 'Apache2 PHP handler', 'centos', '2.2', 'default'
    it_behaves_like 'PHP-FPM', 'redhat', 'default'
    it_behaves_like 'Yum IUS repo'
    it_behaves_like 'PHP and PHP-fpm packages version 5.5 CENTOS'
  end

  context 'PHP 5.6' do
    cached(:chef_run) do
      ChefSpec::SoloRunner.new(CENTOS67_SERVICE_OPTS) do |node|
        node.set['rackspace_apache_php']['php_version'] = '5.6'
      end.converge('rackspace_apache_php_test::default')
    end
    it_behaves_like 'Apache2', 'centos', '6.7'
    it_behaves_like 'Apache2 PHP handler', 'centos', '2.2', 'default'
    it_behaves_like 'PHP-FPM', 'redhat', 'default'
    it_behaves_like 'Yum IUS repo'
    it_behaves_like 'PHP and PHP-fpm packages version 5.6 CENTOS'
  end
end
