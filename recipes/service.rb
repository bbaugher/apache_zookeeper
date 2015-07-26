
supported_init_styles = %w{
  init
  systemd
}

init_style = node['apache_zookeeper']['init_style']

# Services moved to recipes
if supported_init_styles.include? init_style
  include_recipe "apache_zookeeper::service_#{init_style}"
else
  log 'Could not determine service init style, manual intervention required to'\
      ' start up the zookeeper service.'
end
