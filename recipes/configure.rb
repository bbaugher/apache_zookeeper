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
  end
end

template 'log4j properties' do
  path ::File.join(node['apache_zookeeper']['config_dir'], 'log4j.properties')
  group node['apache_zookeeper']['group']
  owner 'root'
  mode  00644
  backup false
  source 'log4j.properties.erb'
  #notifies :restart, 'service[zookeeper]'
end

template 'zookeeper config' do
  path ::File.join(node['apache_zookeeper']['config_dir'], 'zookeeper.properties')
  group node['apache_zookeeper']['group']
  owner 'root'
  mode 00644
  backup false
  source 'zoo.cfg.erb'
  #notifies :restart, 'service[zookeeper]'
end

file 'zookeeper id' do
  path ::File.join(node['apache_zookeeper']['data_dir'], 'myid')
  group node['apache_zookeeper']['group']
  owner 'root'
  content "#{ zookeeper_myid }"
  mode 00644
  backup false
end


