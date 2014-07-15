require 'spec_helper'

describe 'apache_zookeeper::default' do

  let(:chef_run) do
    ChefSpec::Runner.new do |node|
      node.set['zookeeper']['servers'] = ['chefspec']
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

  end

  it 'includes many servers' do
    chef = ChefSpec::Runner.new do |node|
      node.set['zookeeper']['servers'] = ['other1', 'other2', 'chefspec']
    end

    chef.converge(described_recipe)

    expect(chef).to create_file('/var/zookeeper/myid').with(
      user:   'zookeeper',
      group:  'zookeeper',
      backup: false,
      content: '3'
    )

  end

  it 'includes many servers and is not last' do
    chef = ChefSpec::Runner.new do |node|
      node.set['zookeeper']['servers'] = ['other1', 'chefspec', 'other2']
    end

    chef.converge(described_recipe)

    expect(chef).to create_file('/var/zookeeper/myid').with(
      user:   'zookeeper',
      group:  'zookeeper',
      backup: false,
      content: '2'
    )

  end

  it 'includes many servers with leader and quorum ports' do
    chef = ChefSpec::Runner.new do |node|
      node.set['zookeeper']['servers'] = ['other1:2888:3188', 'other2:2888:3188', 'chefspec:2888:3188']
    end

    chef.converge(described_recipe)

    expect(chef).to create_file('/var/zookeeper/myid').with(
      user:   'zookeeper',
      group:  'zookeeper',
      backup: false,
      content: '3'
    )

  end

  it 'does not include servers or zoo.cfg attribute' do
    chef = ChefSpec::Runner.new do |node|
    end

    chef.converge(described_recipe)

    expect(chef).to create_file('/var/zookeeper/myid').with(
      user:   'zookeeper',
      group:  'zookeeper',
      backup: false,
      content: '1'
    )

  end

  it 'has zoo.cfg server.X config' do
    chef = ChefSpec::Runner.new do |node|
      node.set['zookeeper']['zoo.cfg']['server.1'] = 'chefspec'
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
    chef = ChefSpec::Runner.new do |node|
      node.set['zookeeper']['zoo.cfg']['server.1'] = 'other1'
      node.set['zookeeper']['zoo.cfg']['server.2'] = 'other2'
      node.set['zookeeper']['zoo.cfg']['server.3'] = 'chefspec'
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
    chef = ChefSpec::Runner.new do |node|
      node.set['zookeeper']['zoo.cfg']['server.1'] = 'other1'
      node.set['zookeeper']['zoo.cfg']['server.2'] = 'chefspec'
      node.set['zookeeper']['zoo.cfg']['server.3'] = 'other2'
    end

    chef.converge(described_recipe)

    expect(chef).to create_file('/var/zookeeper/myid').with(
      user:   'zookeeper',
      group:  'zookeeper',
      backup: false,
      content: '2'
    )

  end

  it 'has many zoo.cfg server.X config with leader and quorum ports' do
    chef = ChefSpec::Runner.new do |node|
      node.set['zookeeper']['zoo.cfg']['server.1'] = 'other1:2188:3188'
      node.set['zookeeper']['zoo.cfg']['server.2'] = 'other2:2188:3188'
      node.set['zookeeper']['zoo.cfg']['server.3'] = 'chefspec:2188:3188'
    end

    chef.converge(described_recipe)

    expect(chef).to create_file('/var/zookeeper/myid').with(
      user:   'zookeeper',
      group:  'zookeeper',
      backup: false,
      content: '3'
    )

  end

  it 'has servers attribute but does not include server' do
    chef = ChefSpec::Runner.new do |node|
      node.set['zookeeper']['servers'] = ['otherServer']
    end

    expect {
      chef.converge(described_recipe)
    }.to raise_error(RuntimeError)
  end

  it 'has zoo.cfg server.X but does not include server' do
    chef = ChefSpec::Runner.new do |node|
      node.set['zookeeper']['zoo.cfg']['server.1'] = 'otherServer'
    end

    expect {
      chef.converge(described_recipe)
    }.to raise_error(RuntimeError)
  end

end
