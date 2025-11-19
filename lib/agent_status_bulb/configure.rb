# frozen_string_literal: true

require 'fileutils'
require 'yaml'
require 'io/console'

module AgentStatusBulb
  class Configure
    DEFAULT_PATH = File.expand_path('~/.config/agent_status_bulb.yml').freeze
    CREDENTIAL_FIELDS = [
      { key: :token, label: 'Token', conceal: true },
      { key: :secret, label: 'Secret', conceal: true },
      { key: :device_id, label: 'Device ID', conceal: false }
    ].freeze

    def initialize(path = DEFAULT_PATH)
      @path = path
    end

    def configure!
      credentials = gather_credentials
      write_config(credentials)
      $stdout.puts "Saved config to: #{@path}"
    end

    def load!
      data = read_config
      CREDENTIAL_FIELDS.each_with_object({}) do |field, result|
        value = data.fetch(field[:key].to_s, '').to_s.strip
        raise missing_config_error if value.empty?

        result[field[:key]] = value
      end
    end

    private

    def gather_credentials
      CREDENTIAL_FIELDS.each_with_object({}) do |field, result|
        result[field[:key]] = prompt(field[:label], conceal: field[:conceal])
      end
    end

    def write_config(credentials)
      FileUtils.mkdir_p(File.dirname(@path))
      File.write(@path, credentials.transform_keys(&:to_s).to_yaml)
    end

    def read_config
      raise "Config file not found: #{@path}" unless File.file?(@path)

      YAML.safe_load_file(@path, permitted_classes: [], aliases: false) || {}
    end

    def missing_config_error
      "Config must contain token, secret, and device_id: #{@path}"
    end

    def prompt(label, conceal: false)
      $stdout.print "#{label}: "
      input = conceal ? $stdin.noecho(&:gets) : $stdin.gets
      $stdout.puts if conceal
      input.to_s.strip
    end
  end
end
