Apache Zookeeper Cookbook
=========================

[![Cookbook Version](https://img.shields.io/cookbook/v/apache_zookeeper.svg)](https://community.opscode.com/cookbooks/apache_zookeeper)

Installs and configures [Apache Zookeeper](http://zookeeper.apache.org/).

View the [Change Log](https://github.com/bbaugher/apache_zookeeper/blob/master/CHANGELOG.md) to see what has changed.

Supports
--------

 * CentOS
 * Ubuntu

Usage
-----

Using the default attributes will setup a single Zookeeper server in standalone mode.

If you are wanting to setup Zookeeper in a multi-server cluster make sure to fill out the 
`node["zookeeper"]["servers"]` attribute with an array of fqdn/hostnames/ips of your zookeeper 
servers. This array is used to calculate the server ids for each zookeeper.

You can also provide the server ids yourself by including values for the attributes 
`node["zookeeper"]["zoo.cfg"]["server.[ID]"]`. If this is done you don't have to provide the 
`node["zookeeper"]["servers"]` attribute.

What does the installation look like
------------------------------------

By default the installation will look like,

    zkCli | /usr/bin/zkCli  - The Zookeeper cli binary command
    /opt/zookeeper/*        - All of Zookeeper's files (config, binaries, event handlers, logs...)
    /etc/init.d/zookeeper   - An init.d script to start/stop zookeeper. You can use service 
    				        zookeeper [start|stop|restart|status] instead

Attributes
----------

 * `node["zookeeper"]["user"]` : The user that owns the Zookeeper installation (default="zookeeper")
 * `node["zookeeper"]["group"]` : The group that owns the Zookeeper installation (default="zookeeper")
 * `node["zookeeper"]["open_file_limit"]` : The open file limit for the zookeeper user (default=32768)
 * `node["zookeeper"]["max_processes"]` : The max processes limit for the zookeeper user (default=1024)
 * `node["zookeeper"]["env_vars"]` : The environment variables set for the zookeeper user (default={})
 * `node["zookeeper"]["servers"]` : The array of fqdn/hostnames/ips for the zookeeper servers in the cluster
 * `node["zookeeper"]["mirror"]` : The mirror used to download the binary (default="http://apache.claz.org/zookeeper")
 * `node["zookeeper"]["version"]` : The version of the Serf agent to install (default="3.4.5")
 * `node["zookeeper"]["binary_url"]` : The full binary url of Zookeeper. If you override this value make sure to provide a valid and up to date value for `node["zookeeper"]["version"]` (default=`File.join node["zookeeper"]["mirror"], "zookeeper-#{node["zookeeper"]["version"]}", "zookeeper-#{node["zookeeper"]["version"]}.tar.gz"`)
 * `node["zookeeper"]["base_directory"]` : The base directory Zookeeper should be installed into (default="/opt/zookeeper")
 * `node["zookeeper"]["zoo.cfg"][*]` : The key/values set for the `zoo.cfg` config file (see attributes file for defaults)
 * `node["zookeeper"]["log4j.properties"][*]` : The key/values set for the `log4j.properties` config file (see attributes file for defaults)