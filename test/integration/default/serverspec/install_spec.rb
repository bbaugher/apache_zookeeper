# encoding: UTF-8

require 'spec_helper'

describe user('zookeeper') do
  it { should exist }
  it { should belong_to_group 'zookeeper' }
end

describe file('/opt/zookeeper/current') do
  it { should be_symlink }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
  it { should be_linked_to '/opt/zookeeper/zookeeper-3.4.10' }
end

describe file('/opt/zookeeper/zookeeper-3.4.10') do
  it { should exist }
  it { should be_directory }
  it { should be_owned_by 'zookeeper' }
  it { should be_grouped_into 'zookeeper' }
end

describe 'zookeeper' do
  it 'should own all files' do
    # Ensure we reload ruby's usernames/groups
    Etc.endgrent
    Etc.endpwent
    Dir["/opt/zookeeper/current/**/*"].reject{
        |f| f['/opt/zookeeper/current/conf']}.each do |filePath|
      expect(Etc.getpwuid(File.stat(filePath).uid).name).to eq("zookeeper")
      expect(Etc.getgrgid(File.stat(filePath).gid).name).to eq("zookeeper")
    end
  end

  it 'should have zkCli command available' do
    output = `echo "\nquit" | zkCli`
    expect(output).to contain('Connecting to localhost:2181')
    expect($?.success?).to eq(true)
  end

end
