# coding: UTF-8

module ZookeeperHelper

  attr_reader :zookeeper_myid

  # Initializes the helper class
  def setup_helper

    # Install and require the xml-simple library
    chef_gem "xml-simple"
    require 'xmlsimple'

    # Build out binary url
    node.default["zookeeper"]["binary_url"] = "#{node["zookeeper"]["mirror"]}/zookeeper-#{node["zookeeper"]["version"]}/zookeeper-#{node["zookeeper"]["version"]}.tar.gz"

    # Make sure server ids are set or set them
    if !node["zookeeper"]["zoo.cfg"].select{ |key, value| key.to_s.match(/\Aserver.\d+\z/)}.empty?
      log "Using given zoo.cfg config for server ids"

      node["zookeeper"]["zoo.cfg"].select{ |key, value| key.to_s.match(/\Aserver.\d+\z/)}.each do |key, value|
        if value == node["fqdn"] || value == node["hostname"] || value == node["ipaddress"]
          @zookeeper_myid = key["server.".size, key.size]
          break
        end
      end

      raise "Unable to find server [#{node["fqdn"]} in zoo.cfg attributes #{node["zookeeper"]["zoo.cfg"].select{ |key, value| key.to_s.match(/\Aserver.\d+\z/)}}" if @zookeeper_myid.nil?

    elsif node["zookeeper"]["servers"].empty?
      log "Configuring standalone zookeeper cluster"
      node.default["zookeeper"]["zoo.cfg"]["server.1"] = "#{node["fqdn"]}:#{node["zookeeper"]["zoo.cfg"]["clientPort"]}"
      @zookeeper_myid = '1'
    else
      log "Configuring mult-server zookeeper cluster"

      id = 1
      node["zookeeper"]["servers"].each do |server|
        node.default["zookeeper"]["zoo.cfg"]["server.#{id}"] = "#{server}:#{node["zookeeper"]["zoo.cfg"]["clientPort"]}"

        if node["zookeeper"]["servers"].include?(node["fqdn"]) || node["zookeeper"]["servers"].include?(node["hostname"]) || node["zookeeper"]["servers"].include?(node["ipaddress"])
          @zookeeper_myid = id.to_s
        end

        id = id + 1
      end

      raise "Unable to find server [#{node["fqdn"]} in servers attribute #{node["zookeeper"]["servers"]}" if @zookeeper_myid.nil?
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
