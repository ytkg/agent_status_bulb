# frozen_string_literal: true

require 'agent_status_bulb'
require 'agent_status_bulb/configure'
require 'agent_status_bulb/bulb'

module AgentStatusBulb
  class Cli
    def self.start(argv)
      new(argv).run
    end

    def initialize(argv)
      @argv = argv.dup
    end

    def run
      command = @argv.shift
      handle_command(command)
    end

    private

    def handle_command(command)
      case command
      when 'configure'
        configure!
      when 'run'
        run!
      when 'wait'
        wait!
      when 'idle'
        idle!
      when 'off'
        off!
      else
        raise ArgumentError, usage
      end
    end

    def configure!
      AgentStatusBulb::Configure.new.configure!
    end

    def run!
      bulb.blue
    end

    def wait!
      bulb.orange
    end

    def idle!
      bulb.green
    end

    def off!
      bulb.off
    end

    def usage
      "Usage: #{File.basename($PROGRAM_NAME)} [run|wait|idle|off|configure]"
    end

    def bulb
      @bulb ||= AgentStatusBulb::Bulb.from_config(configurator.load!)
    end

    def configurator
      @configurator ||= AgentStatusBulb::Configure.new
    end
  end
end
