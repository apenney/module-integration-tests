require 'beaker-rspec/spec_helper'
require 'beaker-rspec/helpers/serverspec'

hosts.each do |host|
  if host['platform'] =~ /debian/
    on host, 'echo \'export PATH=/var/lib/gems/1.8/bin/:${PATH}\' >> ~/.bashrc'
  end
  if host.is_pe?
    if host['platform'] =~ /el/
      on master, shell('iptables -I INPUT 4 -p tcp -m state --state NEW -m tcp --dport 8140 -j ACCEPT'), { :acceptable_exit_codes => [0,1] }
    end
    install_pe
  else
    install_puppet
  end
end

RSpec.configure do |c|
  # Readable test descriptions
  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do
    # Install module and dependencies
    install_options = "--modulepath #{master['distmoduledir']} --ignore-dependencies --force"
    on master, puppet('module','install','puppetlabs-ntp', install_options),        { :acceptable_exit_codes => [0,1] }
    on master, puppet('module','install','puppetlabs-firewall', install_options),   { :acceptable_exit_codes => [0,1] }
    on master, puppet('module','install','puppetlabs-apt', install_options),        { :acceptable_exit_codes => [0,1] }
    on master, puppet('module','install','puppetlabs-apache', install_options),     { :acceptable_exit_codes => [0,1] }
    on master, puppet('module','install','puppetlabs-mysql', install_options),      { :acceptable_exit_codes => [0,1] }
    on master, puppet('module','install','puppetlabs-postgresql', install_options), { :acceptable_exit_codes => [0,1] }
    on master, puppet('module','install','puppetlabs-registry', install_options),   { :acceptable_exit_codes => [0,1] }
    on master, puppet('module','install','puppetlabs-reboot', install_options),     { :acceptable_exit_codes => [0,1] }
    on master, puppet('module','install','puppetlabs-inifile', install_options),    { :acceptable_exit_codes => [0,1] }
    on master, puppet('module','install','puppetlabs-java_ks', install_options),    { :acceptable_exit_codes => [0,1] }
    on master, puppet('module','install','puppetlabs-concat', install_options),     { :acceptable_exit_codes => [0,1] }
    on master, puppet('module','install','puppetlabs-stdlib', install_options),     { :acceptable_exit_codes => [0,1] }
  end
end
