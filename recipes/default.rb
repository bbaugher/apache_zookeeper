#
# Cookbook Name:: apache_zookeeper
# Recipe:: default
#

include_recipe 'apache_zookeeper::install'
include_recipe 'apache_zookeeper::configure'
include_recipe 'apache_zookeeper::service'
