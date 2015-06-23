require 'spec_helper'

describe 'apache_zookeeper::default' do

  let(:chef_run) do
    ChefSpec::SoloRunner.new do |node|
      node.set['zookeeper']['servers'] = ['fauxhai.local']
    end
  end

  it 'has servers attribute' do
    chef_run.converge(described_recipe)
    expect(chef_run).to start_service('zookeeper')

    expect(chef_run).to create_file('/var/zookeeper/myid').with(
      user:   'zookeeper',
      group:  'zookeeper',
      backup: false,
      content: '1'
    )

    expect(chef_run.node["zookeeper"]["zoo.cfg"]).to include("server.1" => 'fauxhai.local:2888:3888')
    expect(chef_run).to include_recipe('java')
  end

  it 'will not install java if install_java set to false' do
    chef = ChefSpec::SoloRunner.new do |node|
      node.set['zookeeper']['servers'] = ['fauxhai.local']
      node.set['zookeeper']['install_java'] = false
    end

    chef.converge(described_recipe)
    expect(chef).to start_service('zookeeper')

    expect(chef).to create_file('/var/zookeeper/myid').with(
      user:   'zookeeper',
      group:  'zookeeper',
      backup: false,
      content: '1'
    )

    expect(chef.node["zookeeper"]["zoo.cfg"]).to include("server.1" => 'fauxhai.local:2888:3888')
    expect(chef).not_to include_recipe('java')
  end

  it 'has servers attribute and sets follower/election ports' do
    chef = ChefSpec::SoloRunner.new do |node|
      node.set['zookeeper']['servers'] = ['fauxhai.local']
      node.set['zookeeper']['follower_port'] = 1234
      node.set['zookeeper']['election_port'] = 4321
    end

    chef.converge(described_recipe)

    expect(chef).to create_file('/var/zookeeper/myid').with(
      user:   'zookeeper',
      group:  'zookeeper',
      backup: false,
      content: '1'
    )

    expect(chef.node["zookeeper"]["zoo.cfg"]).to include("server.1" => 'fauxhai.local:1234:4321')

  end

  it 'includes many servers' do
    chef = ChefSpec::SoloRunner.new do |node|
      node.set['zookeeper']['servers'] = ['other1', 'other2', 'fauxhai.local']
    end

    chef.converge(described_recipe)

    expect(chef).to create_file('/var/zookeeper/myid').with(
      user:   'zookeeper',
      group:  'zookeeper',
      backup: false,
      content: '3'
    )

    expect(chef.node["zookeeper"]["zoo.cfg"]).to include("server.1" => 'other1:2888:3888')
    expect(chef.node["zookeeper"]["zoo.cfg"]).to include("server.2" => 'other2:2888:3888')
    expect(chef.node["zookeeper"]["zoo.cfg"]).to include("server.3" => 'fauxhai.local:2888:3888')

  end

  it 'includes many servers and is not last' do
    chef = ChefSpec::SoloRunner.new do |node|
      node.set['zookeeper']['servers'] = ['other1', 'fauxhai.local', 'other2']
    end

    chef.converge(described_recipe)

    expect(chef).to create_file('/var/zookeeper/myid').with(
      user:   'zookeeper',
      group:  'zookeeper',
      backup: false,
      content: '2'
    )

    expect(chef.node["zookeeper"]["zoo.cfg"]).to include("server.1" => 'other1:2888:3888')
    expect(chef.node["zookeeper"]["zoo.cfg"]).to include("server.2" => 'fauxhai.local:2888:3888')
    expect(chef.node["zookeeper"]["zoo.cfg"]).to include("server.3" => 'other2:2888:3888')

  end

  it 'includes many servers with leader and quorum ports' do
    chef = ChefSpec::SoloRunner.new do |node|
      node.set['zookeeper']['servers'] = ['other1:2881:3881', 'other2:2882:3882', 'fauxhai.local:2883:3883']
    end

    chef.converge(described_recipe)

    expect(chef).to create_file('/var/zookeeper/myid').with(
      user:   'zookeeper',
      group:  'zookeeper',
      backup: false,
      content: '3'
    )

    expect(chef.node["zookeeper"]["zoo.cfg"]).to include("server.1" => 'other1:2881:3881')
    expect(chef.node["zookeeper"]["zoo.cfg"]).to include("server.2" => 'other2:2882:3882')
    expect(chef.node["zookeeper"]["zoo.cfg"]).to include("server.3" => 'fauxhai.local:2883:3883')

  end

  it 'does not include servers or zoo.cfg attribute' do
    chef = ChefSpec::SoloRunner.new do |node|
    end

    chef.converge(described_recipe)

    expect(chef).to create_file('/var/zookeeper/myid').with(
      user:   'zookeeper',
      group:  'zookeeper',
      backup: false,
      content: nil
    )

  end

  it 'has zoo.cfg server.X config' do
    chef = ChefSpec::SoloRunner.new do |node|
      node.set['zookeeper']['zoo.cfg']['server.1'] = 'fauxhai.local'
    end

    chef.converge(described_recipe)

    expect(chef).to create_file('/var/zookeeper/myid').with(
      user:   'zookeeper',
      group:  'zookeeper',
      backup: false,
      content: '1'
    )

  end

  it 'has many zoo.cfg server.X config' do
    chef = ChefSpec::SoloRunner.new do |node|
      node.set['zookeeper']['zoo.cfg']['server.1'] = 'other1:2888:3888'
      node.set['zookeeper']['zoo.cfg']['server.2'] = 'other2:2888:3888'
      node.set['zookeeper']['zoo.cfg']['server.3'] = 'fauxhai.local:2888:3888'
    end

    chef.converge(described_recipe)

    expect(chef).to create_file('/var/zookeeper/myid').with(
      user:   'zookeeper',
      group:  'zookeeper',
      backup: false,
      content: '3'
    )

  end

  it 'has many zoo.cfg server.X config and is not last' do
    chef = ChefSpec::SoloRunner.new do |node|
      node.set['zookeeper']['zoo.cfg']['server.1'] = 'other1:2888:3888'
      node.set['zookeeper']['zoo.cfg']['server.2'] = 'fauxhai.local:2888:3888'
      node.set['zookeeper']['zoo.cfg']['server.3'] = 'other2:2888:3888'
    end

    chef.converge(described_recipe)

    expect(chef).to create_file('/var/zookeeper/myid').with(
      user:   'zookeeper',
      group:  'zookeeper',
      backup: false,
      content: '2'
    )

  end

  it 'has servers attribute but does not include server' do
    chef = ChefSpec::SoloRunner.new do |node|
      node.set['zookeeper']['servers'] = ['otherServer']
    end

    expect {
      chef.converge(described_recipe)
    }.to raise_error(RuntimeError)
  end

  it 'has zoo.cfg server.X but does not include server' do
    chef = ChefSpec::SoloRunner.new do |node|
      node.set['zookeeper']['zoo.cfg']['server.1'] = 'otherServer'
    end

    expect {
      chef.converge(described_recipe)
    }.to raise_error(RuntimeError)
  end

end
