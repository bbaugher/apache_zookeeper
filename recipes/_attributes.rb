# Cookbook Name:: apache_zookeeper
# Recipe:: _attributes
# Recipe to set derived attributes


case node['apache_zookeeper']['install']['type']
when 'source'
  version_tag = "zookeeper-#{node['apache_zookeeper']['version']}"
  node.default['apache_zookeeper']['binary_url'] = ::File.join(node['apache_zookeeper']['mirror'],
                    "#{version_tag}/#{version_tag}.tar.gz")

  base_dir = ::File.join(node['apache_zookeeper']['install_dir'], 'current')
  local_state_dir = node['apache_zookeeper']['local_state_dir']

  node.default['apache_zookeeper']['bin_dir'] = ::File.join(base_dir, 'bin')
  node.default['apache_zookeeper']['data_dir'] = ::File.join(local_state_dir, 'data')
  node.default['apache_zookeeper']['log_dir'] = ::File.join(local_state_dir, 'log')
when 'package'
  base_dir = '/etc/zookeeper'
  node.default['apache_zookeeper']['local_state_dir'] = '/var/lib/zookeeper'

  local_state_dir = node['apache_zookeeper']['local_state_dir']

  node.default['apache_zookeeper']['data_dir'] = local_state_dir
  node.default['apache_zookeeper']['log_dir'] = '/var/log/zookeeper'
end

node.default['apache_zookeeper']['config_dir'] = ::File.join(base_dir, 'conf')

node.default['apache_zookeeper']['env_vars']['ZOO_LOG_DIR'] = node['apache_zookeeper']['log_dir']

node.default['apache_zookeeper']['zoo.cfg']['dataDir'] = node['apache_zookeeper']['data_dir']

node.default['apache_zookeeper']['log4j.properties']['zookeeper.log.dir'] = node['apache_zookeeper']['log_dir']
