# encoding: UTF-8

require 'spec_helper'

describe service('zookeeper') do
  it { should be_running   }
end

# Zookeeper client port
describe port(2181) do
  it { should be_listening }
end
