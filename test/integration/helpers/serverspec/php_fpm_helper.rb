shared_examples_for 'php-fpm' do |enabled_suite, disabled_suite|
  # Basic tests
  describe service(get_helper_data_value(enabled_suite, :fpm_service_name)) do
    it { should be_enabled }
    it { should be_running }
  end

  if os[:family] == 'ubuntu' && os[:release] == '14.04' # On Trusty we need to check a TCP/IP socket
    describe port(get_helper_data_value(enabled_suite, :fpm_port)) do
      it { should be_listening }
    end

    describe port(get_helper_data_value(disabled_suite, :fpm_port)) do
      it { should_not be_listening }
    end
  else
    describe file(get_helper_data_value(enabled_suite, :fpm_socket)) do
      it { should be_socket }
    end

    describe file(get_helper_data_value(disabled_suite, :fpm_socket)) do
      it { should_not be_socket }
    end
  end

  # Pool tests
  describe file(get_helper_data_value(enabled_suite, :default_pool)) do
    it { should be_file }
  end

  describe file(get_helper_data_value(disabled_suite, :default_pool)) do
    it { should_not be_file }
  end
end
