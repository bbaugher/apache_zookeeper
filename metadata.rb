name             'apache_zookeeper'
maintainer       'Bryan Baugher'
maintainer_email 'Bryan.Baugher@Cerner.com'
license          'All rights reserved'
description      'Installs/Configures Apache Zookeeper'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.1'

depends "java"

%w{ ubuntu debian redhat centos }.each do |os|
  supports os
end
