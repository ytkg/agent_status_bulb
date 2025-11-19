# frozen_string_literal: true

require 'agent_status_bulb/bulb'

RSpec.describe AgentStatusBulb::Bulb do
  let(:device) { instance_double('SwitchbotDevice', off?: off_state) }
  let(:bulb) { described_class.new(device) }
  let(:off_state) { false }

  shared_examples 'a color setter' do |method_name, value|
    context "##{method_name}" do
      context 'when device is off' do
        let(:off_state) { true }

        it 'turns on and sets the color' do
          expect(device).to receive(:on)
          expect(device).to receive(:color).with(value)
          bulb.public_send(method_name)
        end
      end

      context 'when device is already on' do
        it 'sets the color without turning on' do
          expect(device).not_to receive(:on)
          expect(device).to receive(:color).with(value)
          bulb.public_send(method_name)
        end
      end
    end
  end

  include_examples 'a color setter', :blue, '0:0:255'
  include_examples 'a color setter', :orange, '255:125:0'
  include_examples 'a color setter', :green, '0:255:0'

  describe '#off' do
    it 'turns the device off' do
      expect(device).to receive(:off)
      bulb.off
    end
  end
end
