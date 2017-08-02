# encoding: UTF-8
# Cookbook Name: apache_zookeeper
# Recipe:: install

include_recipe 'apache_zookeeper::_attributes'

case node['apache_zookeeper']['install']['type']
when 'source'
# Download remote file first. If we fail here, no need to continue
binary_file_name = File.basename(node['apache_zookeeper']['binary_url'])
version_directory = File.basename(binary_file_name, '.tar.gz')
download_path = ::File.join(Chef::Config[:file_cache_path], binary_file_name)

remote_file download_path do
  action :create_if_missing
  source node['apache_zookeeper']['binary_url']
  backup false
  not_if { ::File.exist?(
    ::File.join(node['apache_zookeeper']['install_dir'], version_directory)
  ) }
end

# Okay, now we can install java
include_recipe "java" if node['apache_zookeeper']['install_java']

# Create user/group accounts
group node['apache_zookeeper']['group']

user node['apache_zookeeper']['user'] do
  comment 'Apache Zookeeper service account'
  home    ::File.join(node['apache_zookeeper']['install_dir'], "current")
  gid     node['apache_zookeeper']['group']
  shell   '/bin/false'
  system  true
end

# Create installation dir
directory node['apache_zookeeper']['install_dir'] do
  recursive true
  owner node['apache_zookeeper']['user']
  group node['apache_zookeeper']['group']
end

execute 'extract zookeeper source' do
  command "tar -xzf #{download_path} -C"\
    " #{node['apache_zookeeper']['install_dir']}"
  not_if { ::File.exist?(
    ::File.join(node['apache_zookeeper']['install_dir'], version_directory)
  ) }
  notifies :run, "execute[set zookeeper install owner]", :immediately
end

# TODO: this should actually probably be owned by root and only data dirs, etc
# owned by zookeeper user
execute 'set zookeeper install owner' do
  command "chown -R "\
    "#{node['apache_zookeeper']['user']}:#{node['apache_zookeeper']['group']} "\
    " #{::File.join(node['apache_zookeeper']['install_dir'], version_directory)}"
end

link ::File.join(node['apache_zookeeper']['install_dir'], "current") do
  to ::File.join(node['apache_zookeeper']['install_dir'], version_directory)
  link_type :symbolic
  owner 'root'
  group 'root'
end

# Setup zookeeper's zkCli command
template '/usr/bin/zkCli' do
  source  'zkCli.erb'
  group node['apache_zookeeper']['group']
  owner node['apache_zookeeper']['user']
  mode 00755
  backup false
end
when 'package'

  include_recipe "java" if node['apache_zookeeper']['install_java']

  if node['apache_zookeeper']['package']['version'].nil?
    package 'zookeeperd'
  else
    package 'zookeeperd' do
      version node['apache_zookeeper']['package']['version']
    end
  end
end
