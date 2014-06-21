#
# Cookbook Name:: apache_zookeeper
# Recipe:: default
#

require 'pathname'

# include helper methods
class ::Chef::Recipe
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
  gid node["zookeeper"]["group"]
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
  user node["zookeeper"]["user"]
  
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

# Link zkServer.sh to /etc/init.d/zookeeper
link "/etc/init.d/zookeeper" do
  to zookeeper_bin("zkServer.sh")
end

# Link zkCli.sh to /usr/bin/zkCli
link "/usr/bin/zkCli" do
  to zookeeper_bin("zkCli.sh")
end

# Ensure everything is owned by zookeeper user/group
execute "chown -R #{node["zookeeper"]["user"]}:#{node["zookeeper"]["group"]} #{zookeeper_base}"

# Start zookeeper service
service "zookeeper" do
  supports :status => true, :restart => true
  action [ :enable, :start ]
end