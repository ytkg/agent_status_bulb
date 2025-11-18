# frozen_string_literal: true

require 'agent_status_bulb'
require 'switchbot'
require 'agent_status_bulb/configure'

module AgentStatusBulb
  class Cli
    def self.start(argv)
      new(argv).run
    end

    def initialize(argv, io: $stdin, out: $stdout, err: $stderr)
      @argv = argv.dup
      @io = io
      @out = out
      @err = err
    end

    def run
      command = @argv.shift
      handle_command(command)
    rescue StandardError => e
      @err.puts(e.message)
      1
    end

    private

    def handle_command(command)
      return configure! if command == 'configure'
      return apply!(command) if status_colors.key?(command) || command == 'off'

      @err.puts usage
      1
    end

    def configure!
      configurator.configure!
      0
    end

    def apply!(command)
      bulb = build_bulb(configurator.load!)
      apply_status(bulb, command)
      0
    end

    def build_bulb(config)
      client = Switchbot::Client.new(config[:token], config[:secret])
      bulb = client.color_bulb(config[:device_id])
      bulb.on if bulb.off?
      bulb
    end

    def apply_status(bulb, command)
      return bulb.off if command == 'off'

      bulb.color(status_colors.fetch(command))
    end

    def usage
      "Usage: #{File.basename($PROGRAM_NAME)} [run|wait|idle|off|configure]"
    end

    def configurator
      @configurator ||= AgentStatusBulb::Configure.new(io: @io, out: @out)
    end

    def status_colors
      {
        'idle' => '0:255:0',
        'run' => '0:0:255',
        'wait' => '255:125:0'
      }
    end
  end
end
