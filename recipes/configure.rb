# encoding: UTF-8
# Cookbook Name:: apache_zookeeper
# Re
# Recipe:: configure

# Create all the directories
#class ::Chef::Recipe
#  include ::ZookeeperHelper
#end
class ::Chef::Recipe
  include ::ZookeeperHelper
end
class ::Chef::Resource
  include ::ZookeeperHelper
end

[
  node['apache_zookeeper']['config_dir'],
  node['apache_zookeeper']['bin_dir'],
  node['apache_zookeeper']['data_dir'],
  node['apache_zookeeper']['log_dir'],
].each do |dir|
  directory dir do
    recursive true
    owner node['apache_zookeeper']['user']
    group node['apache_zookeeper']['group']
  end
end

template 'log4j properties' do
  path ::File.join(node['apache_zookeeper']['config_dir'], 'log4j.properties')
  owner node['apache_zookeeper']['user']
  group node['apache_zookeeper']['group']
  mode  00644
  backup false
  source 'log4j.properties.erb'
  notifies :run, 'ruby_block[restart_zookeeper_svc]'
end

template 'zookeeper config' do
  path ::File.join(node['apache_zookeeper']['config_dir'], 'zoo.cfg')
  owner node['apache_zookeeper']['user']
  group node['apache_zookeeper']['group']
  mode 00644
  backup false
  source 'zoo.cfg.erb'
  notifies :run, 'ruby_block[restart_zookeeper_svc]'
end

setup_helper
myid = zookeeper_myid

file 'zookeeper id' do
  path ::File.join(node['apache_zookeeper']['data_dir'], 'myid')
  owner node['apache_zookeeper']['user']
  group node['apache_zookeeper']['group']
  content  myid
  mode 00644
  backup false
  notifies :run, 'ruby_block[restart_zookeeper_svc]'
end

ruby_block 'restart_zookeeper_svc' do
  block do
    begin
      r = resources(service: 'zookeeper')
      r.action(:restart)
    rescue Chef::Exceptions::ResourceNotFound
      # Do nothing
    end
  end
  action :nothing
end
