name             'apache_zookeeper'
maintainer       'Bryan Baugher'
maintainer_email 'Bryan.Baugher@Cerner.com'
license          'All rights reserved'
description      'Installs/Configures Apache Zookeeper'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
issues_url       'https://github.com/bbaugher/apache_zookeeper/issues'
source_url       'https://github.com/bbaugher/apache_zookeeper'


depends "java"
depends "ulimit"

%w{ ubuntu centos }.each do |os|
  supports os
end

version          '1.1.0'
