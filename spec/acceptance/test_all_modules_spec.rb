require 'spec_helper_acceptance'

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
    apply_manifest_on(agents, pp, :catch_failures => true)
  end

  describe package('httpd'), :node => 'agent' do
    it { should be_installed }
  end
end
