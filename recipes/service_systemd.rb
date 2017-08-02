# encoding: UTF-8
# Cookbook Name: apache_zookeeper
# Recipe:: service_systemd

include_recipe 'apache_zookeeper::_attributes'

dist_dir, conf_dir = value_for_platform_family(
  ['debian'] => %w{ debian default },
  ['fedora'] => %w{ redhat sysconfig },
  ['rhel']   => %w{ redhat sysconfig },
  ['suse']   => %w{ suse sysconfig }
)

# Reload systemd on template change
execute 'systemctl-daemon-reload' do
  command '/bin/systemctl --system daemon-reload'
  subscribes :run, 'template[mesos-master-init]'
  action :nothing
  only_if { node['apache_zookeeper']['init_style'] == 'systemd' }
end

template '/etc/systemd/system/zookeeper' do
  source "#{dist_dir}/init.d/zookeeper.erb"
  mode 0755
  variables :zkserver_bin => "#{node['apache_zookeeper']['bin_dir']}/zkServer.sh",
    :zkuser => node['apache_zookeeper']['user']
  notifies :restart, 'service[zookeeper]', :delayed
end

template "/etc/#{conf_dir}/zookeeper" do
  source "#{dist_dir}/#{conf_dir}/zookeeper.erb"
  mode 0644
  notifies :restart, 'service[zookeeper]', :delayed
end

service 'zookeeper' do
  supports :status => true, :restart => true
  action [:enable, :start]
end
