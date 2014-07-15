#
# Cookbook Name:: apache_zookeeper
# Recipe:: default
#

# include helper methods
class ::Chef::Recipe
  include ::ZookeeperHelper
end

class ::Chef::Resource
  include ::ZookeeperHelper
end

# Setup helper and include any nested default attributes
setup_helper

# Install java
include_recipe "java"

# Create zookeeper user/group
group node["zookeeper"]["group"] do
  action :create
end

user node["zookeeper"]["user"] do
  comment "Zookeeper user"
  gid node["zookeeper"]["group"]
  home "/home/#{node["zookeeper"]["user"]}"
  supports :manage_home => true
end

# Create limits.d conf to set zookeeper open file limit and max processes
template "/etc/security/limits.d/#{node["zookeeper"]["user"]}.conf" do
  source "limits.conf.erb"
  owner node["zookeeper"]["user"]
  group node["zookeeper"]["group"]
  mode "0755"
  backup false

  notifies :restart, "service[zookeeper]"
end

# Configure zookeeper user's bash profile
template "/home/#{node["zookeeper"]["user"]}/.bash_profile" do
  source  "bash_profile.erb"
  owner node["zookeeper"]["user"]
  group node["zookeeper"]["group"]
  mode  00755
  notifies :restart, "service[zookeeper]"
end

# Download binary zip file
remote_file zookeeper_tar_path do
  action :create_if_missing
  source node["zookeeper"]["binary_url"]
  group node["zookeeper"]["group"]
  owner node["zookeeper"]["user"]
  mode 00644
  backup false
end

# Install/Upgrade zookeeper installation
bash "install/upgrade zookeeper" do

  code <<-EOH
  rm -rf #{zookeeper_base}
  tar zxf #{zookeeper_tar_path} -C /tmp
  mv /tmp/zookeeper-#{node["zookeeper"]["version"]} #{zookeeper_base}
    EOH

  only_if do
    !File.exists? zookeeper_base or zookeeper_version != node["zookeeper"]["version"]
  end

  notifies :restart, "service[zookeeper]"
end

# Ensure data directory is created
directory node["zookeeper"]["zoo.cfg"]["dataDir"] do
  group node["zookeeper"]["group"]
  owner node["zookeeper"]["user"]
  mode 00755
  recursive true
  action :create
end

# Configure zookeeper's log4j properties
template zookeeper_conf("log4j.properties") do
  source  "log4j.properties.erb"
  group node["zookeeper"]["group"]
  owner node["zookeeper"]["user"]
  mode 00755
  backup false
  notifies :restart, "service[zookeeper]"
end

# Configure zookeeper's server properties
template zookeeper_conf("zoo.cfg") do
  source  "zoo.cfg.erb"
  group node["zookeeper"]["group"]
  owner node["zookeeper"]["user"]
  mode 00755
  backup false
  notifies :restart, "service[zookeeper]"
end

# Theres a strange chef/ruby issue where zookeeper_myid can't
# get resolved inside of the file resource so we do this hack here
id = zookeeper_myid

# Create the zookeeper myid file
file "#{node["zookeeper"]["zoo.cfg"]["dataDir"]}/myid" do
  group node["zookeeper"]["group"]
  owner node["zookeeper"]["user"]
  content id
  mode 00755
  backup false
end

# Setup zookeeper's init script
template "/etc/init.d/zookeeper" do
  source  "init.erb"
  group node["zookeeper"]["group"]
  owner node["zookeeper"]["user"]
  mode 00755
  backup false
end

# Setup zookeeper's zkCli command
template "/usr/bin/zkCli" do
  source  "zkCli.erb"
  group node["zookeeper"]["group"]
  owner node["zookeeper"]["user"]
  mode 00755
  backup false
end

# Ensure everything is owned by zookeeper user/group
execute "chown -R #{node["zookeeper"]["user"]}:#{node["zookeeper"]["group"]} #{zookeeper_base}"

# Start zookeeper service
service "zookeeper" do
  supports :status => true, :restart => true
  action [ :enable, :start ]
end
