# frozen_string_literal: true

require 'agent_status_bulb/bulb'

class FakeSwitchbotDevice
  def off?; end
  def color(_); end
  def on; end
  def off; end
end

RSpec.describe AgentStatusBulb::Bulb do
  let(:device) { instance_spy(FakeSwitchbotDevice, off?: off_state, color: nil, on: nil, off: nil) }
  let(:bulb) { described_class.new(device) }
  let(:off_state) { false }

  shared_examples 'a color setter' do |method_name, value|
    describe "##{method_name}" do
      context 'when device is off' do
        let(:off_state) { true }

        before { bulb.public_send(method_name) }

        it 'turns on' do
          expect(device).to have_received(:on)
        end

        it 'sets the color' do
          expect(device).to have_received(:color).with(value)
        end
      end

      context 'when device is already on' do
        before { bulb.public_send(method_name) }

        it 'does not call on' do
          expect(device).not_to have_received(:on)
        end

        it 'sets the color' do
          expect(device).to have_received(:color).with(value)
        end
      end
    end
  end

  it_behaves_like 'a color setter', :blue, '0:0:255'
  it_behaves_like 'a color setter', :orange, '255:125:0'
  it_behaves_like 'a color setter', :green, '0:255:0'

  describe '#off' do
    before { bulb.off }

    it 'turns the device off' do
      expect(device).to have_received(:off)
    end
  end
end
