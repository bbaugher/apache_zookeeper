# encoding: UTF-8

require 'spec_helper'

describe service('zookeeper') do
  it { should be_running   }
end

# Zookeeper client port
describe port(2181) do
  it { should be_listening }
end

describe file('/opt/zookeeper/current/conf/zoo.cfg') do
  it { should be_file }
  it { should be_owned_by 'zookeeper' }
  it { should be_grouped_into 'zookeeper' }
  it { should contain 'bogus.for.cfg=value1' }
end

describe file('/opt/zookeeper/current/conf/log4j.properties') do
  it { should be_file }
  it { should be_owned_by 'zookeeper' }
  it { should be_grouped_into 'zookeeper' }
  it { should contain 'bogus.for.log4j=value2' }
end

describe file('/var/zookeeper/myid') do
  it { should be_file }
  it { should be_owned_by 'zookeeper' }
  it { should be_grouped_into 'zookeeper' }
end

describe file('/opt/zookeeper/current/logs/zookeeper.log') do
  it { should be_file }
  it { should be_owned_by 'zookeeper' }
  it { should be_grouped_into 'zookeeper' }
end


