# encoding: UTF-8
# Cookbook Name: apache_zookeeper
# Attributes:: install
#
# Zookeeper Attributes only needed for installation
default["apache_zookeeper"]["install_java"] = true

default["apache_zookeeper"]["install_dir"] = "/opt/zookeeper"
default["apache_zookeeper"]["version"] = "3.4.6"
default["apache_zookeeper"]["mirror"] = "http://archive.apache.org/dist/zookeeper"
default["apache_zookeeper"]["dist"] = "http://www.us.apache.org"

