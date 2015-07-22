# encoding: UTF-8

require 'spec_helper'

describe service('zookeeper') do
  it { should be_running   }
end

# Zookeeper client port
describe port(2181) do
  it { should be_listening }
end

describe file('/var/opt/zookeeper/log/zookeeper.log') do
  it { should be_file }
  it { should be_owned_by 'zookeeper' }
  it { should be_grouped_into 'zookeeper' }
end

