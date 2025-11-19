# frozen_string_literal: true

require 'thor'
require 'agent_status_bulb'
require 'agent_status_bulb/configure'
require 'agent_status_bulb/bulb'

module AgentStatusBulb
  class Cli < Thor
    map 'run' => :run_command
    map 'wait' => :wait_command
    map 'idle' => :idle_command
    map 'off' => :off_command

    desc 'configure', 'Save Token/Secret/Device ID'
    def configure
      configurator.configure!
    rescue StandardError => e
      raise Thor::Error, e.message
    end

    desc 'run', 'Set color to running (blue)'
    def run_command
      bulb.blue
    rescue StandardError => e
      raise Thor::Error, e.message
    end

    desc 'wait', 'Set color to waiting (orange)'
    def wait_command
      bulb.orange
    rescue StandardError => e
      raise Thor::Error, e.message
    end

    desc 'idle', 'Set color to idle (green)'
    def idle_command
      bulb.green
    rescue StandardError => e
      raise Thor::Error, e.message
    end

    desc 'off', 'Turn off the bulb'
    def off_command
      bulb.off
    rescue StandardError => e
      raise Thor::Error, e.message
    end

    no_commands do
      def bulb
        @bulb ||= AgentStatusBulb::Bulb.from_config(configurator.load!)
      end

      def configurator
        @configurator ||= AgentStatusBulb::Configure.new
      end
    end
  end
end
