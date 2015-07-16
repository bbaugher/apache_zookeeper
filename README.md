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
`node["zookeeper"]["servers"]` like this,

    node["zookeeper"]["servers"] = ["myzkhost1.com", "myzkhost2.com", myzkhost3.com"]

The array should include a value per server and can be any of the following values,

 * FQDN - `node['fqdn']`
 * Host Name - `node['hostname']`
 * Machine Name - `node['machinename']`
 * Any network interface - `node["network"]["interfaces"][..]`
 * EC2 Host Name - `node['ec2']['public_hostname']`
 * EC2 IP Address - `node['ec2']['public_ipv4']`

This array is used to configure/calculate the server ids for each zookeeper.

You can also provide the server ids yourself by including values for the attributes
`node["zookeeper"]["zoo.cfg"]["server.[ID]"]`. If this is done you don't have to provide the
`node["zookeeper"]["servers"]` attribute.

What does the installation look like
------------------------------------

By default the installation will look like,

    zkCli | /usr/bin/zkCli  - The Zookeeper cli binary command
    /opt/zookeeper/*        - All of Zookeeper's files (config, binaries, logs...)
    /etc/init.d/zookeeper   - An init.d script to start/stop zookeeper. You can use service
    				        zookeeper [start|stop|restart|status] instead

Unique Quorum and Leader Election Ports
---------------------------------------

It is possible to provide unique quorum and leader election ports in a few different ways.

    node["zookeeper"]["servers"] = ["host1", "host2", "host3"]
    node["zookeeper"]["follower_port"] = 2888
    node["zookeeper"]["election_port"] = 3888

OR

    node["zookeeper"]["servers"] = ["host1:2888:3888", "host2:2888:3888", "host3:2888:3888"]

OR

    node["zookeeper"]["zoo.cfg"]["server.1"] = "host1:2888:3888"
    node["zookeeper"]["zoo.cfg"]["server.2"] = "host2:2888:3888"
    node["zookeeper"]["zoo.cfg"]["server.3"] = "host3:2888:3888"

Environment Variables
---------------------

Should note that the `zkServer.sh` and other various scripts provided by zookeeper taken in various environment variables to tweak
runtime settings. Here are some,

 * `ZOO_LOG_DIR` : Overwrites log4j `zookeeper.log.file`. Defaults to `.` if not set which is why we provide a default value for it to the `node["zookeeper"]["log_directory"]` value.
 * `ZOO_LOG4J_PROP` : Overwrites log4j `zookeeper.root.logger`. Defaults to `'INFO, CONSOLE'` if not set which is why we provide a default value for it `'INFO,CONSOLE,ROLLINGFILE'`
 * `JMXDISABLE` : Disables jmx. Defaults to enabling JMX. To disable set to any value
 * `SERVER_JVMFLAGS` : JVM flags for the server process

Attributes
----------

 * `node["zookeeper"]["install_java"]` : If you want to use the `java` cookbook to install java (default=`true`)
 * `node["zookeeper"]["user"]` : The user that owns the Zookeeper installation (default="zookeeper")
 * `node["zookeeper"]["group"]` : The group that owns the Zookeeper installation (default="zookeeper")
 * `node["zookeeper"]["env_vars"]` : The environment variables set for the zookeeper user (default={"ZOO_LOG_DIR" => `node["zookeeper"]["log_directory"]`, "ZOO_LOG4J_PROP" => "'INFO, CONSOLE, ROLLINGFILE'"})
 * `node["zookeeper"]["servers"]` : The array of fqdn/hostnames/ips for the zookeeper servers in the cluster (default=[])
 * `node["zookeeper"]["follower_port"]` : The port used by zookeeper followers (default=2888)
 * `node["zookeeper"]["election_port"]` : The port used for zookeeper elections (default=3888)
 * `node["zookeeper"]["version"]` : The version of Zookeeper to install (default="3.4.5")
 * `node["zookeeper"]["mirror"]` : The URL to the mirror that hosts the zookeeper binary (default=`http://archive.apache.org/dist/zookeeper`)
 * `node["zookeeper"]["binary_url"]` : The full binary url of Zookeeper. If you override this value make sure to provide a valid and up to date value for `node["zookeeper"]["version"]` (default=`File.join node["zookeeper"]["mirror"], "zookeeper-#{node["zookeeper"]["version"]}", "zookeeper-#{node["zookeeper"]["version"]}.tar.gz"`)
 * `node["zookeeper"]["base_directory"]` : The base directory Zookeeper should be installed into (default="/opt/zookeeper")
 * `node["zookeeper"]["log_directory"]` : The log directory for Zookeeper (default=`"#{node["zookeeper"]["base_directory"]}/logs"`)
 * `node["zookeeper"]["zoo.cfg"][*]` : The key/values set for the `zoo.cfg` config file (see attributes file for defaults)
 * `node["zookeeper"]["log4j.properties"][*]` : The key/values set for the `log4j.properties` config file (see attributes file for defaults)
