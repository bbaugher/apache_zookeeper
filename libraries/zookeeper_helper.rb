# coding: UTF-8

module ZookeeperHelper

  # Initializes the helper class
  def setup_helper

    # Install and require the xml-simple library
    chef_gem "xml-simple"
    require 'xmlsimple'

    # Build out binary url
    node.default["zookeeper"]["binary_url"] = "#{node["zookeeper"]["mirror"]}/zookeeper-#{node["zookeeper"]["version"]}/zookeeper-#{node["zookeeper"]["version"]}.tar.gz"

    # Make sure server ids are set or set them
	if !node["zookeeper"]["zoo.cfg"].select{ |key, value| key.to_s.match(/\Aserver.\d+\z/)}.empty?
	  log "Using given config for server ids"
	elsif node["zookeeper"]["servers"].empty?
		log "Configuring up single server zookeeper cluster"
	  node["zookeeper"]["zoo.cfg"]["server.1"] = node["fqdn"]
	else
	  log "Configuring up mult-server zookeeper cluster"
	  if node["zookeeper"]["servers"].include? node["fqdn"]
	  	id = node["zookeeper"]["servers"].index node["fqdn"]
	  	node["zookeeper"]["zoo.cfg"]["server.#{id}"] = node["fqdn"]
	  elsif node["zookeeper"]["servers"].include? node["fqdn"]
	  	id = node["zookeeper"]["servers"].index node["fqdn"]
	  	node["zookeeper"]["zoo.cfg"]["server.#{id}"] = node["fqdn"]
	  elsif node["zookeeper"]["servers"].include? node["fqdn"]
	  	id = node["zookeeper"]["servers"].index node["fqdn"]
	  	node["zookeeper"]["zoo.cfg"]["server.#{id}"] = node["fqdn"]
	  else
	  	raise "Unable to determine server id from list of servers [#{node["zookeeper"]["servers"]}]"
	  end
	end

  end

  def zookeeper_base *files
    File.join node["zookeeper"]["base_directory"], *files
  end

  def zookeeper_bin *files
  	zookeeper_base "bin", *files
  end

  def zookeeper_conf *files
  	zookeeper_base "conf", *files
  end

  def zookeeper_tar_path
    File.join Chef::Config[:file_cache_path], "zookeeper-#{node["zookeeper"]["version"]}.tar.gz"
  end

  def zookeeper_version
  	build_xml_path = File.join node["zookeeper"]["base_directory"], "build.xml"
    
    if File.exists? build_xml_path
      xml = XmlSimple.xml_in(IO.read(build_xml_path))

      xml["property"].each do |property|
      	if property["name"] == "version"
      	  return property["value"]
      	end
      end
    end

    "N/A"
  end

end