# frozen_string_literal: true

require 'tmpdir'
require 'yaml'
require 'agent_status_bulb/configure'

RSpec.describe AgentStatusBulb::Configure do
  def with_temp_path
    Dir.mktmpdir do |dir|
      path = File.join(dir, 'config.yml')
      stub_const("#{described_class}::DEFAULT_PATH", path)
      yield path
    end
  end

  describe '#configure!' do
    it 'writes token, secret, and device_id to yaml' do
      with_temp_path do |path|
        configurator = described_class.new
        allow(configurator).to receive(:prompt).and_return('token-x', 'secret-y', 'device-z')

        configurator.configure!

        data = YAML.safe_load_file(path)
        expect(data).to eq('token' => 'token-x', 'secret' => 'secret-y', 'device_id' => 'device-z')
      end
    end

    it 'prints the saved path' do
      with_temp_path do |path|
        configurator = described_class.new
        allow(configurator).to receive(:prompt).and_return('token-x', 'secret-y', 'device-z')

        expect { configurator.configure! }.to output(/Saved config to: #{path}/).to_stdout
      end
    end
  end

  describe '#load!' do
    it 'raises when file is missing' do
      with_temp_path do |_path|
        configurator = described_class.new
        expect { configurator.load! }.to raise_error(/Config file not found/)
      end
    end

    it 'raises when required keys are empty' do
      with_temp_path do |path|
        File.write(path, { 'token' => '', 'secret' => nil, 'device_id' => '' }.to_yaml)
        configurator = described_class.new
        expect { configurator.load! }.to raise_error(/Config must contain token, secret, and device_id/)
      end
    end

    it 'returns symbolized credentials when present' do
      with_temp_path do |path|
        File.write(path, { 'token' => 'tk', 'secret' => 'sc', 'device_id' => 'dev' }.to_yaml)
        configurator = described_class.new
        expect(configurator.load!).to eq(token: 'tk', secret: 'sc', device_id: 'dev')
      end
    end
  end
end
