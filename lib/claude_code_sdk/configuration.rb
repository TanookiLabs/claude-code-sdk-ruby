# frozen_string_literal: true

require "singleton"

module ClaudeCodeSDK
  class Configuration
    include Singleton

    attr_accessor :default_system_prompt, :default_cwd,
                  :default_permission_mode, :cli_path

    def initialize
      @default_system_prompt = nil
      @default_cwd = nil
      @default_permission_mode = PermissionMode::DEFAULT
      @cli_path = nil
    end

    def to_options
      Options.new(
        system_prompt: default_system_prompt,
        cwd: default_cwd,
        permission_mode: default_permission_mode
      )
    end
  end
end
