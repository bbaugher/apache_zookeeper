# coding: UTF-8

default["zookeeper"]["user"] = "zookeeper"
default["zookeeper"]["group"] = "zookeeper"

default["zookeeper"]["open_file_limit"] = 32768
default["zookeeper"]["max_processes"] = 1024

default["zookeeper"]["env_vars"] = {}

default["zookeeper"]["servers"] = []

default["zookeeper"]["mirror"] = "http://apache.claz.org/zookeeper"
default["zookeeper"]["version"] = "3.4.5"

default["zookeeper"]["base_directory"] = "/opt/zookeeper"

default["zookeeper"]["zoo.cfg"]["clientPort"] = 2181
default["zookeeper"]["zoo.cfg"]["dataDir"] = "/var/zookeeper"
default["zookeeper"]["zoo.cfg"]["tickTime"] = 2000
default["zookeeper"]["zoo.cfg"]["autopurge.purgeInterval"] = 24
default["zookeeper"]["zoo.cfg"]["initLimit"] = 10
default["zookeeper"]["zoo.cfg"]["syncLimit"] = 5

# Settings from default zookeeper installation
default["zookeeper"]["log4j.properties"]["zookeeper.root.logger"] = "INFO, CONSOLE, ROLLINGFILE"
default["zookeeper"]["log4j.properties"]["zookeeper.console.threshold"] = "INFO"
default["zookeeper"]["log4j.properties"]["zookeeper.log.dir"] = "."
default["zookeeper"]["log4j.properties"]["zookeeper.log.file"] = "zookeeper.log"
default["zookeeper"]["log4j.properties"]["zookeeper.log.threshold"] = "DEBUG"
default["zookeeper"]["log4j.properties"]["zookeeper.tracelog.dir"] = "."
default["zookeeper"]["log4j.properties"]["zookeeper.tracelog.file"] = "zookeeper_trace.log"
default["zookeeper"]["log4j.properties"]["log4j.rootLogger"] = "${zookeeper.root.logger}"
default["zookeeper"]["log4j.properties"]["log4j.appender.CONSOLE"] = "org.apache.log4j.ConsoleAppender"
default["zookeeper"]["log4j.properties"]["log4j.appender.CONSOLE.Threshold"] = "${zookeeper.console.threshold}"
default["zookeeper"]["log4j.properties"]["log4j.appender.CONSOLE.layout"] = "org.apache.log4j.PatternLayout"
default["zookeeper"]["log4j.properties"]["log4j.appender.CONSOLE.layout.ConversionPattern"] = "%d{ISO8601} [myid:%X{myid}] - %-5p [%t:%C{1}@%L] - %m%n"
default["zookeeper"]["log4j.properties"]["log4j.appender.ROLLINGFILE"] = "org.apache.log4j.RollingFileAppender"
default["zookeeper"]["log4j.properties"]["log4j.appender.ROLLINGFILE.Threshold"] = "${zookeeper.log.threshold}"
default["zookeeper"]["log4j.properties"]["log4j.appender.ROLLINGFILE.File"] = "${zookeeper.log.dir}/${zookeeper.log.file}"
default["zookeeper"]["log4j.properties"]["log4j.appender.ROLLINGFILE.MaxFileSize"] = "10MB"
default["zookeeper"]["log4j.properties"]["log4j.appender.ROLLINGFILE.MaxBackupIndex"] = "10"
default["zookeeper"]["log4j.properties"]["log4j.appender.ROLLINGFILE.layout"] = "org.apache.log4j.PatternLayout"
default["zookeeper"]["log4j.properties"]["log4j.appender.ROLLINGFILE.layout.ConversionPattern"] = "%d{ISO8601} [myid:%X{myid}] - %-5p [%t:%C{1}@%L] - %m%n"
default["zookeeper"]["log4j.properties"]["log4j.appender.TRACEFILE"] = "org.apache.log4j.FileAppender"
default["zookeeper"]["log4j.properties"]["log4j.appender.TRACEFILE.Threshold"] = "TRACE"
default["zookeeper"]["log4j.properties"]["log4j.appender.TRACEFILE.File"] = "${zookeeper.tracelog.dir}/${zookeeper.tracelog.file}"
default["zookeeper"]["log4j.properties"]["log4j.appender.TRACEFILE.layout"] = "org.apache.log4j.PatternLayout"
default["zookeeper"]["log4j.properties"]["log4j.appender.TRACEFILE.layout.ConversionPattern"] = "%d{ISO8601} [myid:%X{myid}] - %-5p [%t:%C{1}@%L][%x] - %m%n"
