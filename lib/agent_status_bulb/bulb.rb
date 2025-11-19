# frozen_string_literal: true

require 'switchbot'

module AgentStatusBulb
  class Bulb
    def self.from_config(config)
      client = Switchbot::Client.new(config.fetch(:token), config.fetch(:secret))
      new(client.color_bulb(config.fetch(:device_id)))
    end

    def initialize(device)
      @device = device
    end

    def blue
      apply_color('0:0:255')
    end

    def orange
      apply_color('255:125:0')
    end

    def green
      apply_color('0:255:0')
    end

    def off
      @device.off
    end

    private

    def apply_color(value)
      turn_on_if_needed
      @device.color(value)
    end

    def turn_on_if_needed
      @device.on if @device.off?
    end
  end
end
