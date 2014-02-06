require 'spec_helper_acceptance'

def backup_site
  on master, shell("cp #{master['puppetpath']}/manifests/site.pp /tmp/site.pp")
end

def create_site(pp)
  test = master['puppetpath']
  on master, create_remote_file(master, File.join(test, "manifests", "site.pp"), pp)
end

def restore_site
  on master, shell("cp #{master['puppetpath']}/manifests/site.pp /tmp/site.pp")
end

def run_agent
  puppet('agent')
end

describe 'including all modules' do
  it 'includes all the modules' do
    pp = <<-EOS
      include '::apache'
      include '::ntp'
      include '::apache'
      include '::mysql'
      include '::postgresql'
      include '::registry'
      include '::concat'
    EOS

    if fact('osfamily') == 'Debian'
      pp << "include '::apt'"
    end

    backup_site
    create_site(pp)
    run_agent
    restore_site
  end

  describe package('httpd'), :node => 'agent' do
    it { should be_installed }
  end
end
