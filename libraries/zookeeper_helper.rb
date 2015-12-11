# coding: UTF-8

module ZookeeperHelper

  attr_reader :zookeeper_myid

  # Initializes the helper class
  def setup_helper

    # Define ZOO_LOG_DIR
    node.default['apache_zookeeper']["env_vars"]["ZOO_LOG_DIR"] = node['apache_zookeeper']['log_dir']

    # Make sure server ids are set or set them
    if !node['apache_zookeeper']["zoo.cfg"].select{ |key, value| key.to_s.match(/\Aserver.\d+\z/)}.empty?
      log "Using given zoo.cfg config for server ids"

      node['apache_zookeeper']["zoo.cfg"].select{ |key, value| key.to_s.match(/\Aserver.\d+\z/)}.each do |key, value|
        if does_server_match_node? value
          @zookeeper_myid = key["server.".size, key.size]
          break
        end
      end

      raise "Unable to find server [#{node["fqdn"]} in zoo.cfg attributes #{node['apache_zookeeper']["zoo.cfg"].select{ |key, value| key.to_s.match(/\Aserver.\d+\z/)}}" if @zookeeper_myid.nil?

    elsif node['apache_zookeeper']["servers"].empty?
      log "Configuring standalone zookeeper cluster"
    else
      log "Configuring mult-server zookeeper cluster"

      id = 1
      node['apache_zookeeper']["servers"].each do |server|
        if server.include? ":"
          # If they include port information in their list of servers just use the raw value
          node.default['apache_zookeeper']["zoo.cfg"]["server.#{id}"] = server
        else
          node.default['apache_zookeeper']["zoo.cfg"]["server.#{id}"] = "#{server}:#{node['apache_zookeeper']["follower_port"]}:#{node['apache_zookeeper']["election_port"]}"
        end

        if does_server_match_node? server
          @zookeeper_myid = id.to_s
        end

        id = id + 1
      end

      raise "Unable to find server [#{node["fqdn"]} in servers attribute #{node['apache_zookeeper']["servers"]}" if @zookeeper_myid.nil?
    end

  end

  def zookeeper_version
    build_xml_path = File.join node['apache_zookeeper']["base_directory"], "build.xml"

    if File.exists? build_xml_path
      require 'rexml/document'
      doc = REXML::Document.new(IO.read(build_xml_path))

      doc.get_elements('//property').select{|e|
        e.attributes.has_key?('name') && e.attributes['name'] == 'version' && e.attributes['value'] != '${version}'
      }.first.attributes['value']
    end

    "N/A"
  end

  private

  def does_server_match_node? server
    # We check that the server value is either the nodes fqdn, hostname or ipaddress.
    identities = [node["fqdn"], node["hostname"]]

    node["network"]["interfaces"].each_value do |interface|
      interface["addresses"].each_key do |address|
          identities << address
      end
    end

    # We also include ec2 identities as well
    identities << node["machinename"] if node.attribute?("machinename")
    identities << node["ec2"]["public_hostname"] if node.attribute?("ec2") && node["ec2"].attribute?("public_hostname")
    identities << node["ec2"]["public_ipv4"] if node.attribute?("ec2") && node["ec2"].attribute?("public_ipv4")

    identities.each do |id|
      # We also check if instead the value is of the form [HOST]:[PORT]:[PORT] which is also
      # valid in the case of defining quorum and leader election ports
      if server == id || server.start_with?("#{id}:")
        return true
      end
    end

    # Nothing matched
    false
  end

end
