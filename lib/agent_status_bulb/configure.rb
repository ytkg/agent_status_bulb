# frozen_string_literal: true

require 'fileutils'
require 'yaml'
require 'io/console'

module AgentStatusBulb
  class Configure
    DEFAULT_PATH = File.expand_path('~/.config/agent_status_bulb.yml').freeze

    def initialize(path: DEFAULT_PATH, io: $stdin, out: $stdout)
      @path = path
      @io = io
      @out = out
    end

    def configure!
      token = prompt('Token', conceal: true)
      secret = prompt('Secret', conceal: true)
      device_id = prompt('Device ID')

      FileUtils.mkdir_p(File.dirname(@path))
      File.write(@path, { 'token' => token, 'secret' => secret, 'device_id' => device_id }.to_yaml)
      @out.puts "Saved config to: #{@path}"
    end

    def load!
      raise "Config file not found: #{@path}" unless File.file?(@path)

      data = YAML.safe_load_file(@path, permitted_classes: [], aliases: false) || {}
      token = data['token'].to_s
      secret = data['secret'].to_s
      device_id = data['device_id'].to_s

      if token.empty? || secret.empty? || device_id.empty?
        raise "Config must contain token, secret, and device_id: #{@path}"
      end

      { token: token, secret: secret, device_id: device_id }
    end

    private

    def prompt(label, conceal: false)
      @out.print "#{label}: "
      input = conceal ? @io.noecho(&:gets) : @io.gets
      @out.puts if conceal
      input.to_s.strip
    end
  end
end
