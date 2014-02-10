require 'spec_helper_acceptance'

describe 'including all modules' do
  case fact('osfamily')
  when 'RedHat'
    mysql_service_name     = 'mysqld'
    apache_service_name    = 'httpd'
  else
    mysql_service_name     = 'mysql'
    apache_service_name    = 'apache2'
  end

  it 'includes all the modules' do
    pp = <<-EOS
      include '::apache'
      include '::ntp'
      include '::apache'
      include '::mysql::server'
      include '::postgresql::server'

      concat { '/tmp/file':
        ensure => present,
      }

      concat::fragment { 'tmpfile':
        target  => '/tmp/file',
        content => 'test',
      }
    EOS

    if fact('osfamily') == 'Debian'
      pp << "include '::apt'"
    end

    backup_site
    create_site(pp)
    run_agent
    restore_site
  end

  describe service('ntp'), :node => 'agent' do
    it { should be_running }
  end

  describe service(apache_service_name), :node => 'agent' do
    it { should be_running }
  end

  describe service(mysql_service_name), :node => 'agent' do
    it { should be_running }
  end

  describe file('/tmp/file'), :node => 'agent' do
    it { should be_file }
  end
end
