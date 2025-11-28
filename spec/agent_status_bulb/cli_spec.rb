# frozen_string_literal: true

require 'agent_status_bulb/cli'

RSpec.describe AgentStatusBulb::Cli do
  let(:bulb) { instance_spy(AgentStatusBulb::Bulb, blue: nil, orange: nil, green: nil, off: nil) }
  let(:configurator) { instance_spy(AgentStatusBulb::Configure, configure!: nil, load!: { token: 't', secret: 's', device_id: 'd' }) }
  let(:options) { { debug: true } }

  before do
    allow(AgentStatusBulb::Configure).to receive(:new).and_return(configurator)
    allow(AgentStatusBulb::Bulb).to receive(:from_config).and_return(bulb)
  end

  it 'configures credentials' do
    described_class.start(['configure'])
    expect(configurator).to have_received(:configure!)
  end

  it 'sets blue on run' do
    described_class.start(['run'])
    expect(bulb).to have_received(:blue)
  end

  it 'sets orange on wait' do
    described_class.start(['wait'])
    expect(bulb).to have_received(:orange)
  end

  it 'sets green on idle' do
    described_class.start(['idle'])
    expect(bulb).to have_received(:green)
  end

  it 'turns off on off' do
    described_class.start(['off'])
    expect(bulb).to have_received(:off)
  end

  it 'wraps bulb errors into Thor::Error' do
    allow(bulb).to receive(:blue).and_raise(StandardError, 'boom')
    expect { described_class.start(['run'], options) }.to raise_error(Thor::Error, 'boom')
  end

  it 'prints version with version command' do
    expect { described_class.start(['version']) }.to output("#{AgentStatusBulb::VERSION}\n").to_stdout
  end

  it 'raises on unknown command' do
    expect { described_class.start(['unknown'], options) }.to raise_error(Thor::UndefinedCommandError)
  end
end
