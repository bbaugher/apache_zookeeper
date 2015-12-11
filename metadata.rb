name             'apache_zookeeper'
maintainer       'Bryan Baugher'
maintainer_email 'Bryan.Baugher@Cerner.com'
license          'All rights reserved'
description      'Installs/Configures Apache Zookeeper'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))

depends "java"
depends "ulimit"

%w{ ubuntu centos }.each do |os|
  supports os
end

version          '1.0.0'
