# encoding: UTF-8
# Cookbook Name: apache_zookeeper
# Attributes:: default
#
# Apache Zookeeper global attributes



#################  Installation attributes ###########################
default["apache_zookeeper"]["install_java"] = true

default["apache_zookeeper"]["install_dir"] = "/opt/zookeeper"
default["apache_zookeeper"]["version"] = "3.4.6"
default["apache_zookeeper"]["mirror"] = "http://archive.apache.org/dist/zookeeper"

# User/group creation and limits
default['apache_zookeeper']['user'] = 'zookeeper'
default['apache_zookeeper']['group'] = 'zookeeper'
default['ulimit']['users'][node['apache_zookeeper']['user']]['filehandle_limit'] = 32768 # ~FC047
default['ulimit']['users'][node['apache_zookeeper']['user']]['process_limit'] = 1024 # ~FC047

################ Configuration Attributes #############################
base_dir = ::File.join(node['apache_zookeeper']['install_dir'], 'current')
default['apache_zookeeper']['local_state_dir'] = '/var/opt/zookeeper'
local_state_dir = node['apache_zookeeper']['local_state_dir']

default['apache_zookeeper']['config_dir'] = base_dir + '/conf'
default['apache_zookeeper']['bin_dir'] =    base_dir + '/bin'
default['apache_zookeeper']['data_dir'] =   local_state_dir + '/data'
default['apache_zookeeper']['log_dir'] =    local_state_dir + '/log'

# This are used to configure a cluster
default['apache_zookeeper']['servers'] = []
default['apache_zookeeper']['follower_port'] = 2888
default['apache_zookeeper']['election_port'] = 3888

############## Service Attributes #####################################
default['apache_zookeeper']['init_style'] = 'init'


################# Template attributes ################################
default['apache_zookeeper']['env_vars']['ZOO_LOG4J_PROP'] = 'INFO,ROLLINGFILE'
default['apache_zookeeper']['env_vars']['ZOO_LOG_DIR'] = node['apache_zookeeper']['log_dir']

# Zookeeper configuration options
default['apache_zookeeper']['zoo.cfg']['clientPort'] = 2181
default['apache_zookeeper']['zoo.cfg']['dataDir'] = node['apache_zookeeper']['data_dir']
default['apache_zookeeper']['zoo.cfg']['tickTime'] = 2000
default['apache_zookeeper']['zoo.cfg']['autopurge.purgeInterval'] = 24
default['apache_zookeeper']['zoo.cfg']['initLimit'] = 10
default['apache_zookeeper']['zoo.cfg']['syncLimit'] = 5

# Settings from default zookeeper installation
default['apache_zookeeper']['log4j.properties']['zookeeper.root.logger'] = 'CONSOLE,ROLLINGFILE'
default['apache_zookeeper']['log4j.properties']['zookeeper.console.threshold'] = 'INFO'
default['apache_zookeeper']['log4j.properties']['zookeeper.log.dir'] = node['apache_zookeeper']['log_dir']
default['apache_zookeeper']['log4j.properties']['zookeeper.log.file'] = 'zookeeper.log'
default['apache_zookeeper']['log4j.properties']['zookeeper.log.threshold'] = 'INFO'
default['apache_zookeeper']['log4j.properties']['zookeeper.tracelog.file'] = 'zookeeper_trace.log'
default['apache_zookeeper']['log4j.properties']['log4j.rootLogger'] = '${zookeeper.root.logger}'
default['apache_zookeeper']['log4j.properties']['log4j.appender.CONSOLE'] = 'org.apache.log4j.ConsoleAppender'
default['apache_zookeeper']['log4j.properties']['log4j.appender.CONSOLE.Threshold'] = "${zookeeper.console.threshold}"
default['apache_zookeeper']['log4j.properties']['log4j.appender.CONSOLE.layout'] = 'org.apache.log4j.PatternLayout'
default['apache_zookeeper']['log4j.properties']['log4j.appender.CONSOLE.layout.ConversionPattern'] = "%d{ISO8601} [myid:%X{myid}] - %-5p [%t:%C{1}@%L] - %m%n"
default['apache_zookeeper']['log4j.properties']['log4j.appender.ROLLINGFILE'] = 'org.apache.log4j.RollingFileAppender'
default['apache_zookeeper']['log4j.properties']['log4j.appender.ROLLINGFILE.Threshold'] = "${zookeeper.log.threshold}"
default['apache_zookeeper']['log4j.properties']['log4j.appender.ROLLINGFILE.File'] = "${zookeeper.log.dir}/${zookeeper.log.file}"
default['apache_zookeeper']['log4j.properties']['log4j.appender.ROLLINGFILE.MaxFileSize'] = '10MB'
default['apache_zookeeper']['log4j.properties']['log4j.appender.ROLLINGFILE.MaxBackupIndex'] = '10'
default['apache_zookeeper']['log4j.properties']['log4j.appender.ROLLINGFILE.layout'] = 'org.apache.log4j.PatternLayout'
default['apache_zookeeper']['log4j.properties']['log4j.appender.ROLLINGFILE.layout.ConversionPattern'] = "%d{ISO8601} [myid:%X{myid}] - %-5p [%t:%C{1}@%L] - %m%n"
default['apache_zookeeper']['log4j.properties']['log4j.appender.TRACEFILE'] = 'org.apache.log4j.FileAppender'
default['apache_zookeeper']['log4j.properties']['log4j.appender.TRACEFILE.Threshold'] = 'TRACE'
default['apache_zookeeper']['log4j.properties']['log4j.appender.TRACEFILE.File'] = "${zookeeper.log.dir}/${zookeeper.tracelog.file}"
default['apache_zookeeper']['log4j.properties']['log4j.appender.TRACEFILE.layout'] = 'org.apache.log4j.PatternLayout'
default['apache_zookeeper']['log4j.properties']['log4j.appender.TRACEFILE.layout.ConversionPattern'] = "%d{ISO8601} [myid:%X{myid}] - %-5p [%t:%C{1}@%L][%x] - %m%n"
