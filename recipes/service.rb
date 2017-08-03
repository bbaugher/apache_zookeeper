# encoding: UTF-8
# Cookbook Name: apache_zookeeper
# Recipe:: service

include_recipe 'apache_zookeeper::_attributes'

init_style = node['apache_zookeeper']['init_style']

case node['apache_zookeeper']['init_style']
when 'init'
  include_recipe "apache_zookeeper::service_#{init_style}"
when 'systemd'
  include_recipe "apache_zookeeper::service_#{init_style}"
else
  log 'Could not determine service init style, manual intervention required to'\
      ' start up the zookeeper service.'
end
