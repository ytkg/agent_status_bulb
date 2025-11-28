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
    def configure(*_args)
      handle_error { configurator.configure! }
    end

    desc 'version', 'Print the current version'
    def version(*_args)
      puts AgentStatusBulb::VERSION
    end

    desc 'run', 'Set color to running (blue)'
    def run_command(*_args)
      handle_error { bulb.blue }
    end

    desc 'wait', 'Set color to waiting (orange)'
    def wait_command(*_args)
      handle_error { bulb.orange }
    end

    desc 'idle', 'Set color to idle (green)'
    def idle_command(*_args)
      handle_error { bulb.green }
    end

    desc 'off', 'Turn off the bulb'
    def off_command(*_args)
      handle_error { bulb.off }
    end

    no_commands do
      def handle_error
        yield
      rescue StandardError => e
        raise Thor::Error, e.message
      end

      def bulb
        @bulb ||= AgentStatusBulb::Bulb.from_config(configurator.load!)
      end

      def configurator
        @configurator ||= AgentStatusBulb::Configure.new
      end
    end

    def self.exit_on_failure?
      true
    end
  end
end
