require 'beaker-rspec/spec_helper'
require 'beaker-rspec/helpers/serverspec'

hosts.each do |host|
  if host['platform'] =~ /debian/
    on host, 'echo \'export PATH=/var/lib/gems/1.8/bin/:${PATH}\' >> ~/.bashrc'
  end
  if host.is_pe?
    install_pe
  else
    # Install Puppet
    install_package host, 'rubygems'
    on host, 'gem install puppet --no-ri --no-rdoc'
    on host, "mkdir -p #{host['distmoduledir']}"
  end
end

RSpec.configure do |c|
  # Readable test descriptions
  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do
    # Install module and dependencies
    on master, puppet('module','install','puppetlabs-ntp'),        {  :acceptable_exit_codes => [0,1] }
    on master, puppet('module','install','puppetlabs-firewall'),   {  :acceptable_exit_codes => [0,1] }
    on master, puppet('module','install','puppetlabs-apt'),        {  :acceptable_exit_codes => [0,1] }
    on master, puppet('module','install','puppetlabs-apache'),     {  :acceptable_exit_codes => [0,1] }
    on master, puppet('module','install','puppetlabs-mysql'),      {  :acceptable_exit_codes => [0,1] }
    on master, puppet('module','install','puppetlabs-postgresql'), {  :acceptable_exit_codes => [0,1] }
    on master, puppet('module','install','puppetlabs-registry'),   {  :acceptable_exit_codes => [0,1] }
    on master, puppet('module','install','puppetlabs-reboot'),     {  :acceptable_exit_codes => [0,1] }
    on master, puppet('module','install','puppetlabs-inifile'),    {  :acceptable_exit_codes => [0,1] }
    on master, puppet('module','install','puppetlabs-java_ks'),    {  :acceptable_exit_codes => [0,1] }
    on master, puppet('module','install','puppetlabs-concat'),     {  :acceptable_exit_codes => [0,1] }
    on master, puppet('module','install','puppetlabs-stdlib'),     {  :acceptable_exit_codes => [0,1] }
  end
end
