# coding: UTF-8

require 'spec_helper'

describe user('zookeeper') do
  it { should exist }
  it { should belong_to_group 'zookeeper' }
end

describe service('zookeeper') do
  it { should be_running   }
end

# Zookeeper client port
describe port(2181) do
  it { should be_listening }
end

describe file('/opt/zookeeper/conf/zoo.cfg') do
  it { should be_file }
  it { should be_owned_by 'zookeeper' }
  it { should be_grouped_into 'zookeeper' }
  it { should contain 'bogus.for.cfg=value1' }
end

describe file('/opt/zookeeper/conf/log4j.properties') do
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

describe file('/opt/zookeeper/logs/zookeeper.log') do
  it { should be_file }
  it { should be_owned_by 'zookeeper' }
  it { should be_grouped_into 'zookeeper' }
end

describe 'zookeeper' do

  it 'should own all files' do
    # Ensure we reload ruby's usernames/groups
    Etc.endgrent
    Etc.endpwent
    Dir["/opt/zookeeper/**/*"].each do |filePath|
      expect(Etc.getpwuid(File.stat(filePath).uid).name).to eq("zookeeper")
      expect(Etc.getgrgid(File.stat(filePath).gid).name).to eq("zookeeper")
    end
  end

  it 'should have zkCli command available' do
    output = `echo -ne 'quit' | zkCli`
    expect(output).to contain('Connecting to localhost:2181')
    expect($?.success?).to eq(true)
  end

end
