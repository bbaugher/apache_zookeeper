#
# Cookbook Name:: apache_zookeeper
# Recipe:: default
#

include_recipe['install']
include_recipe['configure']
include_recipe['service']
