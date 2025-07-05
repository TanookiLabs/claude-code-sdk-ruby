# frozen_string_literal: true

require "pathname"
require_relative "claude_code_sdk/version"
require_relative "claude_code_sdk/errors"
require_relative "claude_code_sdk/types"
require_relative "claude_code_sdk/messages"
require_relative "claude_code_sdk/configuration"
require_relative "claude_code_sdk/transport/base"
require_relative "claude_code_sdk/transport/subprocess_cli"
require_relative "claude_code_sdk/internal/client"

module ClaudeCodeSDK
  # Set environment variable for SDK identification
  ENV["CLAUDE_CODE_SDK"] = "ruby/#{VERSION}"

  class << self
    # Query Claude Code with a prompt
    #
    # @param prompt [String] The prompt to send to Claude
    # @param options [ClaudeCodeSDK::Options, Hash, nil] Configuration options
    # @yield [Message] Messages from the conversation
    # @return [Array<Message>] All messages if no block given
    #
    # @example With a block
    #   ClaudeCodeSDK.query("Hello Claude") do |message|
    #     puts message.text if message.is_a?(AssistantMessage)
    #   end
    #
    # @example Without a block
    #   messages = ClaudeCodeSDK.query("Hello Claude")
    #   messages.each { |msg| puts msg }
    #
    # @example With options
    #   ClaudeCodeSDK.query("Help me code",
    #     system_prompt: "You are a Ruby expert",
    #     allowed_tools: ["read_file", "write_file"]
    #   )
    def query(prompt, options = nil, &block)
      # Convert hash to Options if needed
      options = Options.new(**options) if options.is_a?(Hash)

      client = Internal::Client.new

      if block_given?
        client.query(prompt: prompt, options: options, &block)
      else
        messages = []
        client.query(prompt: prompt, options: options) { |msg| messages << msg }
        messages
      end
    end

    # Convenience method for simple text queries
    #
    # @param prompt [String] The prompt to send
    # @return [String] The concatenated text response
    def ask(prompt)
      response_text = []

      query(prompt) do |message|
        if message.is_a?(AssistantMessage)
          message.content.each do |block|
            response_text << block.text if block.is_a?(Content::TextBlock)
          end
        end
      end

      response_text.join("\n")
    end

    # Configure global defaults
    #
    # @yield [Configuration] The configuration object
    # @example
    #   ClaudeCodeSDK.configure do |config|
    #     config.default_system_prompt = "You are helpful"
    #     config.default_cwd = "/home/user/projects"
    #   end
    def configure
      yield Configuration.instance
    end
  end
end
