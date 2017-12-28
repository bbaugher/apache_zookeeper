# encoding: UTF-8
# Cookbook Name: apache_zookeeper
# Recipe:: service_systemd

include_recipe 'apache_zookeeper::_attributes'

dist_dir, conf_dir = value_for_platform_family(
  ['debian'] => %w{ debian default },
  ['fedora'] => %w{ redhat sysconfig },
  ['rhel']   => %w{ redhat sysconfig }
)

# Reload systemd on template change
execute 'systemctl-daemon-reload' do
  command '/bin/systemctl --system daemon-reload'
  subscribes :run, 'template[/lib/systemd/system/zookeeper.service]'
  action :nothing
  only_if { node['apache_zookeeper']['init_style'] == 'systemd' }
end

template '/lib/systemd/system/zookeeper.service' do
  source "systemd/zookeeper.service.erb"
  mode 0755
  case node['apache_zookeeper']['install']['type']
  when 'package'
    variables(
      :zkserver_bin => "/usr/share/zookeeper/bin/zkServer.sh",
      :zkuser => node['apache_zookeeper']['user']
    )
  else
    variables(
      :zkserver_bin => "#{node['apache_zookeeper']['bin_dir']}/zkServer.sh",
      :zkuser => node['apache_zookeeper']['user']
    )
  end
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
